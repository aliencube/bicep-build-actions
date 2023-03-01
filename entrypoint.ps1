Param(
    [string]
    [Parameter(Mandatory=$true)]
    $Files,

    [string]
    [Parameter(Mandatory=$false)]
    $Version = "latest",

    [boolean]
    [Parameter(Mandatory=$false)]
    $ExitOnFailure
)

if ($Files -eq $null) {
    Write-Host "Please provide at least one .bicep file" -ForegroundColor Red -BackgroundColor Yellow
}

$items = Get-ChildItem -Path $($Files -split " ") -Recurse
if (($items -eq $null) -or ($items.Count -eq 0)) {
    Write-Host "Please provide at least one .bicep file" -ForegroundColor Red -BackgroundColor Yellow

    return
}

# Check Bicep version
$uri = "https://api.github.com/repos/Azure/bicep/releases"
$headers = @{ Accept = "application/vnd.github.v3+json" }

$releases = Invoke-RestMethod -Method GET -Uri $uri -Headers $headers
if (($Version -eq "latest") -or ($Version -eq "")) {
    $release = ($releases | Select-Object -Property tag_name | Sort-Object -Descending)[0]
} else {
    $release = ($releases | Where-Object { $_.tag_name -like $Version.Replace("x", "*") } | Select-Object -Property tag_name | Sort-Object -Descending)[0]
}

$uri = "https://github.com/Azure/bicep/releases/download/$($release.tag_name)/bicep-linux-x64"

# Fetch the given version of Bicep CLI binary
curl -Lo bicep $uri

# Mark it as executable
chmod +x ./bicep

# Add bicep to your PATH (requires admin)
sudo mv ./bicep /usr/local/bin/bicep

# Verify you can now access the 'bicep' command
bicep --help
# Done!

# Build bicep files individually
$items | ForEach-Object {
    bicep build $_.FullName
    if($ExitOnFailure -and ($LASTEXITCODE -ne 0)) {
        Write-Host "Bicep build failed for $($_.FullName)" -ForegroundColor Red -BackgroundColor Yellow
        exit $LASTEXITCODE
    } else {
        Write-Host "$($_.FullName) -> $($_.FullName.Replace(".bicep", ".json"))"
    }
}

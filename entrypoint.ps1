Param(
    [string]
    [Parameter(Mandatory=$true)]
    $Files,

    [string]
    [Parameter(Mandatory=$false)]
    $Version = "latest"
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
if ($Version -eq "latest") {
    $release = ($releases | Select-Object -Property tag_name | Sort-Object -Descending)[0]
} else {
    $release = ($releases | Where-Object { $_.tag_name -like $Version.Replace("x", "*") } | Select-Object -Property tag_name | Sort-Object -Descending)[0]
}

$uri = "https://github.com/Azure/bicep/releases/download/$($release.tag_name)/bicep-linux-x64"

# Install curl
RUN apt-get update && apt-get install -y \
    sudo \
    curl \
 && rm -rf /var/lib/apt/lists/*

# Fetch the given version of Bicep CLI binary
RUN curl -Lo bicep $uri

# Mark it as executable
RUN chmod +x ./bicep

# Add bicep to your PATH (requires admin)
RUN sudo mv ./bicep /usr/local/bin/bicep

# Verify you can now access the 'bicep' command
RUN bicep --help
# Done!

# Build bicep files individually
$items | ForEach-Object {
    bicep build $_.FullName

    Write-Host "$($_.FullName) -> $($_.FullName.Replace(".bicep", ".json"))"
}

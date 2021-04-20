Param(
    [string]
    [Parameter(Mandatory=$true)]
    $Files
)

if ($Files -eq $null) {
    Write-Host "Please provide at least one .bicep file" -ForegroundColor Red -BackgroundColor Yellow
}

$items = Get-ChildItem -Path $($Files -split " ") -Recurse
if (($items -eq $null) -or ($items.Count -eq 0)) {
    Write-Host "Please provide at least one .bicep file" -ForegroundColor Red -BackgroundColor Yellow

    return
}

$items | ForEach-Object {
    bicep build $_.FullName

    Write-Host "$($_.FullName) -> $($_.FullName.Replace(".bicep", ".json"))"
}

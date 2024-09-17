function Remove-SleeperUserAlias {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$LeagueID,    # League ID

        [Parameter(Mandatory = $true)]
        [string]$Username     # Sleeper username
    )

    # Path to the alias JSON file
    $jsonFilePath = "$HOME/.sleeper/useralias.json"

    # Load the existing aliases if the file exists
    if (-not (Test-Path $jsonFilePath)) {
        Write-Error "Alias file not found."
        return
    }

    $aliases = Get-Content -Path $jsonFilePath | ConvertFrom-Json

    # Remove the alias if it exists
    $updatedAliases = $aliases | Where-Object { -not ($_.LeagueID -eq $LeagueID -and $_.Username -eq $Username) }

    if ($aliases.Count -eq $updatedAliases.Count) {
        Write-Warning "Alias for $Username in League $LeagueID not found."
        return
    }

    # Save the updated aliases back to the file
    $updatedAliases | ConvertTo-Json -Depth 3 | Set-Content -Path $jsonFilePath
    Write-Host "Alias for $Username in League $LeagueID removed."
}

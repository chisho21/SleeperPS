function Get-SleeperUserAlias {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$Username,     # Sleeper username (optional)    
    
        [Parameter(Mandatory = $false)]
        [string]$LeagueID    # League ID (optional)
        
    )

    # Path to the alias JSON file
    $jsonFilePath = "$HOME/.sleeper/useralias.json"

    # Load the existing aliases if the file exists
    if (-not (Test-Path $jsonFilePath)) {
        Write-Error "Alias file not found. Please add some aliases first using New-SleeperUserAlias."
        return
    }

    $aliases = Get-Content -Path $jsonFilePath | ConvertFrom-Json

    # Filter based on provided LeagueID and/or Username
    if ($LeagueID) {
        $aliases = $aliases | Where-Object { $_.LeagueID -eq $LeagueID }
    }

    if ($Username) {
        $aliases = $aliases | Where-Object { $_.Username -eq $Username }
    }

    return $aliases
}

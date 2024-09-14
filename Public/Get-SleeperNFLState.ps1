<#
.SYNOPSIS
Retrieves the current state of the NFL season.

.DESCRIPTION
The Get-SleeperNFLState cmdlet retrieves the current state of the NFL season, including the current week and phase (regular season, playoffs, etc.).

.EXAMPLE
PS C:\> Get-SleeperNFLState

Retrieves the current state of the NFL season.

.OUTPUTS
SleeperNFLState

.NOTES
Version: 1.0.0
Author: Your Name
#>

function Get-SleeperNFLState {
    $url = "https://api.sleeper.app/v1/state/nfl"
    $response = Invoke-RestMethod -Uri $url -Method Get

    return [SleeperNFLState]::new($response)
}

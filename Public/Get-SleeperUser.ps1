<#
.SYNOPSIS
Retrieves user information from the Sleeper API by username.

.DESCRIPTION
The Get-SleeperUser cmdlet retrieves user information from the Sleeper API based on the specified username. It returns the user's profile information, including display name, avatar, and more.

.PARAMETER Username
Specifies the username of the Sleeper user whose information will be retrieved.

.EXAMPLE
PS C:\> Get-SleeperUser -Username "example_user"

Retrieves the user profile for the specified Sleeper username.

.OUTPUTS
SleeperUser

.NOTES
Version: 1.0.0
Author: Your Name
#>
function Get-SleeperUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true)]
        [string]$Username
    )

    $url = "https://api.sleeper.app/v1/user/$Username"
    $response = Invoke-RestMethod -Uri $url -Method Get

    # Instantiate a new SleeperUser object using New-Object
    $Object = [SleeperUser]::new($response)

    return $Object
}

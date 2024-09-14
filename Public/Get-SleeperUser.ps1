<#
.SYNOPSIS
Retrieves user information from the Sleeper API by username or user ID.

.DESCRIPTION
The Get-SleeperUser cmdlet retrieves user information from the Sleeper API based on the specified username or user ID. It returns the user's profile information, including display name, avatar, and more.

.PARAMETER Username
Specifies the username of the Sleeper user whose information will be retrieved. This parameter is optional if UserId is specified.

.PARAMETER UserId
Specifies the user ID of the Sleeper user whose information will be retrieved. If provided, this takes precedence over the Username parameter.

.EXAMPLE
PS C:\> Get-SleeperUser -Username "example_user"

Retrieves the user profile for the specified Sleeper username.

.EXAMPLE
PS C:\> Get-SleeperUser -UserId "1234567890"

Retrieves the user profile for the specified Sleeper user ID.

.OUTPUTS
SleeperUser

.NOTES
Version: 1.0.0
Author: Your Name
#>
function Get-SleeperUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true)]
        [string]$Username,

        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, ValueFromPipeline = $true)]
        [string]$UserId
    )

    # Validate that either Username or UserId is provided
    if (-not $UserId -and -not $Username) {
        Write-Error "You must specify either a Username or a UserId."
        return
    }

    # Use UserId if specified, otherwise use Username
    if ($UserId) {
        $url = "https://api.sleeper.app/v1/user/$UserId"
        Write-Verbose "Fetching user information by UserId: $UserId"
    } else {
        $url = "https://api.sleeper.app/v1/user/$Username"
        Write-Verbose "Fetching user information by Username: $Username"
    }

    # Fetch user data from Sleeper API
    try {
        $response = Invoke-RestMethod -Uri $url -Method Get
    } catch {
        Write-Error "Failed to retrieve user information. Check the provided Username or UserId."
        return
    }

    # Instantiate a new SleeperUser object
    $Object = [SleeperUser]::new($response)

    return $Object
}

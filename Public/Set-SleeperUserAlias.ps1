function Set-SleeperUserAlias {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$LeagueID,    # League ID

        [Parameter(Mandatory = $true)]
        [string]$Username,    # Sleeper username

        [Parameter(Mandatory = $true)]
        [string]$Alias        # Alias (e.g., Slack handle)
    )

    # Path to the alias JSON file
    $jsonFilePath = "$HOME/.sleeper/useralias.json"

    # Create the directory if it doesn't exist
    if (-not (Test-Path "$HOME/.sleeper")) {
        New-Item -ItemType Directory -Path "$HOME/.sleeper" -Force | Out-Null
    }

    # Load the existing aliases if the file exists, otherwise initialize an empty array
    $aliases = if (Test-Path $jsonFilePath) {
        $content = Get-Content -Path $jsonFilePath | ConvertFrom-Json
        if ($content -is [array]) {
            $content
        } else {
            @($content)
        }
    } else {
        @()
    }

    # Check if the alias already exists
    $existingAlias = $aliases | Where-Object { $_.LeagueID -eq $LeagueID -and $_.Username -eq $Username }

    if ($existingAlias) {
        # Update the existing alias
        $existingAlias.Alias = $Alias
    } else {
        # Add a new alias
        $newAlias = [PSCustomObject]@{
            LeagueID = $LeagueID
            Username = $Username
            Alias    = $Alias
        }
        # Ensure $aliases is treated as an array
        $aliases = @($aliases)
        $aliases += $newAlias
    }

    # Save the updated aliases back to the file
    $aliases | ConvertTo-Json -Depth 3 | Set-Content -Path $jsonFilePath
    Write-Host "Alias for $Username in League $LeagueID set to $Alias"
}

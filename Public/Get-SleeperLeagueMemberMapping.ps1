function Get-SleeperLeagueMemberMapping {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$LeagueId,   # Optionally filter by League ID
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$UserName    # Optionally filter by Sleeper Username
    )

    # Path to the CSV file
    $csvFilePath = "$HOME/.sleeper/leaguemembermap.csv"

    # Check if the CSV file exists
    if (-not (Test-Path $csvFilePath)) {
        Write-Error "Mapping file not found at $csvFilePath. Please run New-SleeperLeagueMemberMapping first."
        return
    }

    # Import the CSV data
    $mappings = Import-Csv -Path $csvFilePath

    # If both LeagueId and UserName are provided, filter by both
    if ($LeagueId -and $UserName) {
        $mappings = $mappings | Where-Object { $_.LeagueID -eq $LeagueId -and $_.SleeperUsername -eq $UserName }
    }
    # If only LeagueId is provided, filter by LeagueId
    elseif ($LeagueId) {
        $mappings = $mappings | Where-Object { $_.LeagueID -eq $LeagueId }
    }
    # If only UserName is provided, filter by UserName
    elseif ($UserName) {
        $mappings = $mappings | Where-Object { $_.SleeperUsername -eq $UserName }
    }

    # Return filtered or unfiltered mappings
    return $mappings
}

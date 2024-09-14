Sleeper PowerShell Module
=========================

This PowerShell module provides cmdlets for interacting with the Sleeper API, allowing users to retrieve data related to NFL leagues, players, matchups, and more. Player data is cached locally for improved performance, and various filtering options are available to tailor the results.

Cmdlets
-------

### `Get-SleeperLeague`

Retrieves information about a specific Sleeper league.

**Parameters:**

-   `LeagueId` (required): The ID of the league to retrieve.

**Example:**

powershell

Copy code

`Get-SleeperLeague -LeagueId 123456789`

### `Get-SleeperLeagueMatchups`

Retrieves matchup data for a specific Sleeper league.

**Parameters:**

-   `LeagueId` (required): The ID of the league to retrieve matchups for.
-   `Week`: The week for which to retrieve matchups. If omitted, the current week will be used.

**Example:**

powershell

Copy code

`Get-SleeperLeagueMatchups -LeagueId 123456789 -Week 5`

### `Get-SleeperLeagueRosters`

Retrieves roster information for a specific Sleeper league.

**Parameters:**

-   `LeagueId` (required): The ID of the league to retrieve rosters for.

**Example:**

powershell

Copy code

`Get-SleeperLeagueRosters -LeagueId 123456789`

### `Get-SleeperNFLState`

Retrieves the current state of the NFL, such as the current week and season.

**Example:**

powershell

Copy code

`Get-SleeperNFLState`

### `Get-SleeperPlayer`

Retrieves player data from the Sleeper API or from a local cache.

**Parameters:**

-   `Player`: The name or ID of the player to search for (supports wildcards).
-   `Position`: Filter players by position (e.g., QB, RB).
-   `Force`: Forces a refresh from the Sleeper API, bypassing the cache.
-   `SaveLocation`: The location to save the player cache (default: `$HOME/.sleeper/nfl_players.json`).

**Example:**

powershell

Copy code

`Get-SleeperPlayer -Player "*mahomes*"`

### `Get-SleeperTrendingPlayers`

Retrieves the trending players on the Sleeper platform.

**Parameters:**

-   `Sport`: The sport to filter trending players by (`nfl`, `nba`, etc.).
-   `Type`: The type of trending players to retrieve (`add` or `drop`).

**Example:**

powershell

Copy code

`Get-SleeperTrendingPlayers -Sport nfl -Type add`

### `Get-SleeperUser`

Retrieves user information from Sleeper by username or user ID.

**Parameters:**

-   `UserId` (required): The ID of the user to retrieve.

**Example:**

powershell

Copy code

`Get-SleeperUser -UserId 1065124741360615424`

### `Get-SleeperUserLeagues`

Retrieves the leagues for a specific Sleeper user.

**Parameters:**

-   `UserId` (required): The ID of the user to retrieve leagues for.
-   `Sport`: Filter by sport (`nfl`, `nba`, etc.).
-   `Season`: Filter by season (e.g., `2023`).

**Example:**

powershell

Copy code

`Get-SleeperUserLeagues -UserId 1065124741360615424 -Sport nfl -Season 2023`

Installation
------------

1.  Clone or download this repository.
2.  Import the module into your PowerShell session:

    powershell

    Copy code

    `Import-Module -Path /path/to/module`

Usage
-----

After importing the module, you can use any of the provided cmdlets to interact with the Sleeper API. Use `-Verbose` for additional output and `-Force` to refresh cached data.

License
-------

This module is provided under the Creative Commons License.

Author
------

This module was developed by Feros Technologies.
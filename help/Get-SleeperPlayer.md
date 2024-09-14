---
external help file: Sleeper-help.xml
Module Name: Sleeper
online version:
schema: 2.0.0
---

# Get-SleeperPlayer

## SYNOPSIS
Retrieves player data from the Sleeper API or cache based on player name, ID, or position.

## SYNTAX

```
Get-SleeperPlayer [[-Player] <String>] [[-Position] <String>] [-Force] [[-SaveLocation] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-SleeperPlayer cmdlet fetches NFL player data from the Sleeper API or uses a locally cached file for faster access. 
The cmdlet supports filtering by player name (with wildcards), player ID, and position. 
Player data is cached in a global variable to avoid reloading from the JSON file unless explicitly requested using the -Force parameter.

## EXAMPLES

### EXAMPLE 1
```
Get-SleeperPlayer -Player "*mahomes*"
```

Retrieves all players with "mahomes" in their name from the Sleeper API or cache.

### EXAMPLE 2
```
Get-SleeperPlayer -Player 4046
```

Retrieves the player with the exact ID of 4046.

### EXAMPLE 3
```
Get-SleeperPlayer -Position QB
```

Fetches all players with the position of Quarterback (QB) from the Sleeper API or cache.

### EXAMPLE 4
```
Get-SleeperPlayer -Force
```

Forces a fresh update from the Sleeper API, ignoring the cache and saving new data to the JSON file.

## PARAMETERS

### -Player
Specifies the player name or ID to search for.
Accepts wildcards (*) for name searches or an exact match for player ID. 
Default is "*" which returns all players.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: *
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Position
Specifies the position to filter by (e.g., QB, RB, WR).
Only players matching the specified position are returned.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Forces an update from the Sleeper API, bypassing the cache and fetching fresh data.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SaveLocation
Specifies the location where the player data JSON file is saved or loaded from. 
Default is "$HOME/.sleeper/nfl_players.json".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: "$HOME/.sleeper/nfl_players.json"
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### SleeperPlayer[]
### Returns a list of SleeperPlayer objects that match the search criteria.
## NOTES
Author: Your Name
Version: 1.0.0
This cmdlet caches data in a global variable to improve performance by avoiding repeated API calls.
To force a cache refresh, use the -Force parameter.
The cache is automatically updated if the data is older than 7 days.

## RELATED LINKS

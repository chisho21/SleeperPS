---
external help file: Sleeper-help.xml
Module Name: Sleeper
online version:
schema: 2.0.0
---

# Get-SleeperLeague

## SYNOPSIS
Retrieves detailed information for one or more Sleeper leagues by LeagueId.

## SYNTAX

```
Get-SleeperLeague [-LeagueId] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-SleeperLeague cmdlet retrieves detailed information for a specific Sleeper league or multiple leagues. 
It accepts input via the pipeline, allowing you to pass a LeagueId or an object containing a LeagueId property directly.

## EXAMPLES

### EXAMPLE 1
```
Get-SleeperLeague -LeagueId "123456789"
```

Retrieves detailed information for the league with ID "123456789".

### EXAMPLE 2
```
Get-SleeperUserLeagues -UserId "1065124741360615424" | Get-SleeperLeague
```

Fetches all leagues for the user and pipes each league's LeagueId into Get-SleeperLeague to retrieve the details for each one.

### EXAMPLE 3
```
$leagueIds = @("123456789", "987654321")
PS C:\> $leagueIds | Get-SleeperLeague
```

Fetches league details for each LeagueId in the array.

## PARAMETERS

### -LeagueId
Specifies the unique identifier of the Sleeper league to retrieve details for. 
This can be passed directly or through the pipeline.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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

### PSCustomObject
### Returns detailed information about each Sleeper league.
## NOTES
Version: 1.0.0
Author: Feros Technologies

## RELATED LINKS

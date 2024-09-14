---
external help file: Sleeper-help.xml
Module Name: Sleeper
online version:
schema: 2.0.0
---

# Get-SleeperUserLeagues

## SYNOPSIS
Retrieves a list of leagues for the specified Sleeper user.

## SYNTAX

```
Get-SleeperUserLeagues [-UserId] <String> [[-Sport] <String>] [[-Season] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-SleeperUserLeagues cmdlet retrieves all leagues that a user is a part of for the nfl and season. 
It fetches data from the Sleeper API based on the user's ID and the specified sport and season.

## EXAMPLES

### EXAMPLE 1
```
Get-SleeperUserLeagues -UserId 12345 -sport nfl -Season 2023
```

Retrieves all NFL leagues for the specified user in the 2023 season.

## PARAMETERS

### -UserId
Specifies the unique identifier of the Sleeper user whose leagues are to be retrieved.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Sport
{{ Fill Sport Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Nfl
Accept pipeline input: False
Accept wildcard characters: False
```

### -Season
Specifies the season year for which leagues should be retrieved.
Defaults to the current year.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: (Get-Date).Year
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

### SleeperLeague[]
## NOTES
Version: 1.0.0
Author: Your Name

## RELATED LINKS

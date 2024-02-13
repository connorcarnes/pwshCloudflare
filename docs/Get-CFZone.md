---
external help file: pwshCloudflare-help.xml
Module Name: pwshCloudflare
online version: https://github.com/connorcarnes/pwshCloudflare
schema: 2.0.0
---

# Get-CFZone

## SYNOPSIS
Retrieves information about a Cloudflare zone.

## SYNTAX

```
Get-CFZone [[-ZoneName] <String>] [[-ZoneID] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-CFZone function queries the Cloudflare API to retrieve information about a specific zone.
It can query zones based on either the zone name or the zone ID.

## EXAMPLES

### EXAMPLE 1
```
Get-CFZone -ZoneName "example.com"
This example retrieves information about the zone named "example.com".
```

### EXAMPLE 2
```
Get-CFZone -ZoneID "1234567890abcdef1234567890abcdef"
This example retrieves information about the zone with the ID "1234567890abcdef1234567890abcdef".
```

## PARAMETERS

### -ZoneName
The name of the zone to retrieve.
This parameter is mutually exclusive with ZoneID.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ZoneID
The unique identifier of the zone to retrieve.
This parameter is mutually exclusive with ZoneName.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -Verbose, -WarningAction, -WarningVariable, and -ProgressAction.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Cloudflare.Zone
## NOTES

## RELATED LINKS

[https://github.com/connorcarnes/pwshCloudflare](https://github.com/connorcarnes/pwshCloudflare)

[https://developers.cloudflare.com/api/operations/zones-get](https://developers.cloudflare.com/api/operations/zones-get)

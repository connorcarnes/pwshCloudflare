---
external help file: pwshCloudflare-help.xml
Module Name: pwshCloudflare
online version: https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-list-dns-records
schema: 2.0.0
---

# Get-CFZoneRecord

## SYNOPSIS
Retrieves DNS records for a Cloudflare zone.

## SYNTAX

### ZoneId
```
Get-CFZoneRecord -ZoneId <String> [<CommonParameters>]
```

### ZoneName
```
Get-CFZoneRecord -ZoneName <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-CFZoneRecord function retrieves DNS records for a Cloudflare zone.
It can be used to get all DNS records for a specific zone by providing either the ZoneId or ZoneName parameter.

## EXAMPLES

### EXAMPLE 1
```
Get-CFZoneRecord -ZoneId "1234567890"
Retrieves all DNS records for the Cloudflare zone with the specified ZoneId.
```

### EXAMPLE 2
```
Get-CFZoneRecord -ZoneName "example.com"
Retrieves all DNS records for the Cloudflare zone with the specified ZoneName.
```

## PARAMETERS

### -ZoneId
Specifies the ID of the Cloudflare zone for which to retrieve DNS records.
This parameter is mandatory when using the ZoneId parameter set.

```yaml
Type: String
Parameter Sets: ZoneId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ZoneName
Specifies the name of the Cloudflare zone for which to retrieve DNS records.
This parameter is mandatory when using the ZoneName parameter set.

```yaml
Type: String
Parameter Sets: ZoneName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

## NOTES

## RELATED LINKS

[https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-list-dns-records](https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-list-dns-records)


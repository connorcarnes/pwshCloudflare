---
external help file: pwshCloudflare-help.xml
Module Name: pwshCloudflare
online version: https://github.com/connorcarnes/pwshCloudflare
schema: 2.0.0
---

# Remove-CFZoneRecord

## SYNOPSIS
Removes a DNS record from a Cloudflare zone.

## SYNTAX

### ZoneId
```
Remove-CFZoneRecord -ZoneId <String> -RecordId <String>
 [<CommonParameters>]
```

### ZoneName
```
Remove-CFZoneRecord -ZoneName <String> -RecordId <String>
 [<CommonParameters>]
```

## DESCRIPTION
The Remove-CFZoneRecord function removes a DNS record from a Cloudflare zone.
It can be used to delete a specific DNS record by providing the ZoneId and RecordId parameters, or by providing the ZoneName and RecordId parameters.

## EXAMPLES

### EXAMPLE 1
```
Remove-CFZoneRecord -ZoneId "123456789" -RecordId "987654321"
Removes the DNS record with the specified RecordId from the Cloudflare zone with the specified ZoneId.
```

### EXAMPLE 2
```
Remove-CFZoneRecord -ZoneName "example.com" -RecordId "987654321"
Removes the DNS record with the specified RecordId from the Cloudflare zone with the specified ZoneName.
```

## PARAMETERS

### -ZoneId
The ID of the Cloudflare zone from which the DNS record should be removed.
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
The name of the Cloudflare zone from which the DNS record should be removed.
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

### -RecordId
The ID of the DNS record to be removed.
This parameter is mandatory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -Verbose, -WarningAction, -WarningVariable, and -ProgressAction.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/connorcarnes/pwshCloudflare](https://github.com/connorcarnes/pwshCloudflare)

[https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-delete-dns-record](https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-delete-dns-record)

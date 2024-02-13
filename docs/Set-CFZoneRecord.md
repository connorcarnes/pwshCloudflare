---
external help file: pwshCloudflare-help.xml
Module Name: pwshCloudflare
online version: https://github.com/connorcarnes/pwshCloudflare
schema: 2.0.0
---

# Set-CFZoneRecord

## SYNOPSIS
Updates a DNS record for a Cloudflare zone.

## SYNTAX

### ZoneId
```
Set-CFZoneRecord -RecordId <String> -ZoneId <String> [-Content <String>] [-Name <String>] [-Type <String>]
 [-TTL <Int32>] [-Proxied <Boolean>] [-Priority <Int32>]
 [<CommonParameters>]
```

### ZoneName
```
Set-CFZoneRecord -RecordId <String> -ZoneName <String> [-Content <String>] [-Name <String>] [-Type <String>]
 [-TTL <Int32>] [-Proxied <Boolean>] [-Priority <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
The Set-CFZoneRecord function updates a DNS record for a Cloudflare zone using the Cloudflare API.

## EXAMPLES

### EXAMPLE 1
```
Set-CFZoneRecord -ZoneName example.com -RecordId 123abc456abc -Content 'UpdatedContent'
This example updates the content for record with id 123abc456abc in the zone example.com to 'UpdatedContent'.
```

## PARAMETERS

### -RecordId
The ID of the DNS record to update.

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

### -ZoneId
The ID of the Cloudflare zone.

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
The name of the Cloudflare zone.

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

### -Content
The content of the DNS record.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the DNS record.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The type of the DNS record.
Valid values are 'A', 'AAAA', 'CNAME', 'TXT', and 'MX'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TTL
The Time To Live (TTL) of the DNS record in seconds.
Setting to 1 means 'automatic'.
Value must be between 60 and 86400, with the minimum reduced to 30 for Enterprise zones.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Proxied
Specifies whether the record is proxied through Cloudflare (orange cloud).

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Priority
Required for MX, SRV, and URI records; unused by other record types.
Records with lower priorities are preferred.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -Verbose, -WarningAction, -WarningVariable, and -ProgressAction.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Cloudflare.ZoneRecord
## NOTES

## RELATED LINKS

[https://github.com/connorcarnes/pwshCloudflare](https://github.com/connorcarnes/pwshCloudflare)

[https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-patch-dns-record](https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-patch-dns-record)

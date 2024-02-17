---
external help file: pwshCloudflare-help.xml
Module Name: pwshCloudflare
online version: https://github.com/connorcarnes/pwshCloudflare
schema: 2.0.0
---

# New-CFZoneRecord

## SYNOPSIS
Creates a new DNS record for a Cloudflare zone.

## SYNTAX

### ZoneId
```
New-CFZoneRecord -ZoneId <String> -Content <String> -Name <String> -Type <String> [-TTL <Int32>]
 [-Proxied <Boolean>] [<CommonParameters>]
```

### ZoneName
```
New-CFZoneRecord -ZoneName <String> -Content <String> -Name <String> -Type <String> [-TTL <Int32>]
 [-Proxied <Boolean>] [<CommonParameters>]
```

## DESCRIPTION
The New-CFZoneRecord function creates a new DNS record for a Cloudflare zone.
It supports creating records by either ZoneId or ZoneName.
The function requires the Content, Name, Type, TTL, and Proxied parameters to be specified.
Additional parameters are required for specific record types (MX, SRV, and URI).

## EXAMPLES

### EXAMPLE 1
```
New-CFZoneRecord -ZoneId '1234567890abcdef' -Content '192.168.1.1' -Name 'example.com' -Type 'A' -TTL 3600 -Proxied $true
Creates a new 'A' record with the specified parameters in the Cloudflare zone with the ID '1234567890abcdef'.
```

### EXAMPLE 2
```
New-CFZoneRecord -ZoneName 'example.com' -Content 'mail.example.com' -Name 'example.com' -Type 'MX' -TTL 3600 -Proxied $false -Priority 10
Creates a new 'MX' record with the specified parameters in the Cloudflare zone with the name 'example.com'.
```

## PARAMETERS

### -ZoneId
Specifies the ID of the Cloudflare zone where the DNS record will be created.
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
Specifies the name of the Cloudflare zone where the DNS record will be created.
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

### -Content
Specifies the content of the DNS record.

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

### -Name
Specifies the name of the DNS record.

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

### -Type
Specifies the type of the DNS record.
Valid values are 'A', 'AAAA', 'CNAME', 'TXT', and 'MX'.

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

### -TTL
Specifies the Time To Live (TTL) of the DNS record in seconds.
Setting it to 1 means 'automatic'.
The value must be between 60 and 86400, with the minimum reduced to 30 for Enterprise zones.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -Verbose, -WarningAction, -WarningVariable, and -ProgressAction. 
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Cloudflare.ZoneRecord
## NOTES

## RELATED LINKS

[https://github.com/connorcarnes/pwshCloudflare](https://github.com/connorcarnes/pwshCloudflare)

[https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-create-dns-record](https://developers.cloudflare.com/api/operations/dns-records-for-a-zone-create-dns-record)

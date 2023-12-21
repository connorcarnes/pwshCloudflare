---
external help file: pwshCloudflare-help.xml
Module Name: pwshCloudflare
online version: https://developers.cloudflare.com/api/operations/cloudflare-d1-list-databases
schema: 2.0.0
---

# Get-CFD1Database

## SYNOPSIS
Gets Cloudflare D1 database(s).

## SYNTAX

### AccountId
```
Get-CFD1Database [-Name <String>] [-Id <String>] -AccountId <String> [<CommonParameters>]
```

### AccountName
```
Get-CFD1Database [-Name <String>] [-Id <String>] -AccountName <String> [<CommonParameters>]
```

## DESCRIPTION
Gets Cloudflare D1 database(s).
Must provide exactly one of AccountId or AccountName.
If Name or Id is not specified, all databases will be returned.

## EXAMPLES

### EXAMPLE 1
```
Get-CFD1Database -AccountId '12345'
Gets all databases for account with ID 12345.
```

### EXAMPLE 2
```
Get-CFD1Database -AccountName 'My Account' -Name 'myDb'
Gets databsse 'myDb' for account 'My Account'.
```

### EXAMPLE 3
```
Get-CFD1Database -AccountName 'My Account' -Id '12345'
Gets database with ID 12345 for account 'My Account'.
```

## PARAMETERS

### -Name
Name of database to retrieve.
If not specified, all databases will be returned.

```yaml
Type: String
Parameter Sets: (All)
Aliases: DatabaseName

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
ID of database to retrieve.
If not specified, all databases will be returned.

```yaml
Type: String
Parameter Sets: (All)
Aliases: DatabaseId

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccountId
ID of account to retrieve.
If not specified, all accounts will be returned.

```yaml
Type: String
Parameter Sets: AccountId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccountName
Name of account to retrieve.
If not specified, all accounts will be returned.

```yaml
Type: String
Parameter Sets: AccountName
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

## OUTPUTS

### Cloudflare.D1Database
## NOTES
The cloudflare-d1-list-databases API endpoint returns the properties uuid, name, version and created_at.
The cloudflare-d1-get-database API endpoint returns the same properties as well as num_tables, file_size and running_in region.
When listing all databases or getting a database by name this function makes multiple API calls.
The first call is to get the database ID(s).
The subsequent call(s) use the ID(s) to get the database details.
This is done so that the same output is returned regardless of parameters used.

## RELATED LINKS

[https://developers.cloudflare.com/api/operations/cloudflare-d1-list-databases](https://developers.cloudflare.com/api/operations/cloudflare-d1-list-databases)

[https://developers.cloudflare.com/api/operations/cloudflare-d1-get-database](https://developers.cloudflare.com/api/operations/cloudflare-d1-get-database)


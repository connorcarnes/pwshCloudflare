---
external help file: pwshCloudflare-help.xml
Module Name: pwshCloudflare
online version: https://developers.cloudflare.com/api/operations/cloudflare-d1-query-database
schema: 2.0.0
---

# Invoke-CFD1Query

## SYNOPSIS
Executes a SQL query against a Cloudflare D1 database.

## SYNTAX

### AccountId
```
Invoke-CFD1Query [-Name <String>] [-Id <String>] [-AccountId <String>] -Query <String>
 [-QueryParams <String[]>] [<CommonParameters>]
```

### AccountName
```
Invoke-CFD1Query [-Name <String>] [-Id <String>] [-AccountName <String>] -Query <String>
 [-QueryParams <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Executes a SQL query against a Cloudflare D1 database.
Must include a query as well as the account name or id as well as the database name or id.

## EXAMPLES

### EXAMPLE 1
```
$Query = 'CREATE TABLE IF NOT EXISTS users (id integer PRIMARY KEY AUTOINCREMENT, userName text NOT NULL);'
Invoke-CFD1Query -AccountName 'myAccount' -Name 'myDb' -Query $Query
Creates a 'users' table in the 'myDb' database.
```

### EXAMPLE 2
```
$Query = "INSERT INTO users (userName) VALUES ('JohnDoe');"
Invoke-CFD1Query -AccountName 'myAccount' -Name 'myDb' -Query $Query
Inserts a user with username 'JohnDoe' into the 'users' table of the 'myDb' database.
```

### EXAMPLE 3
```
$Query       = 'SELECT ?1 FROM users;'
$QueryParams = @('JohnDoe')
Invoke-CFD1Query -AccountName 'myAccount' -Name 'myDb' -Query $Query -QueryParams $QueryParams
Returns the user with username 'JohnDoe' from the 'users' table of the 'myDb' database.
```

## PARAMETERS

### -Name
The name of the database to query.

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
The ID of the database to query.

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
The ID of the account that owns the database.

```yaml
Type: String
Parameter Sets: AccountId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccountName
The name of the account that owns the database.

```yaml
Type: String
Parameter Sets: AccountName
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Query
The SQL query to execute.

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

### -QueryParams
The parameters to pass to the query.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
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

### Cloudflare.D1QueryResult
## NOTES

## RELATED LINKS

[https://developers.cloudflare.com/api/operations/cloudflare-d1-query-database](https://developers.cloudflare.com/api/operations/cloudflare-d1-query-database)

[https://developers.cloudflare.com/d1/platform/client-api](https://developers.cloudflare.com/d1/platform/client-api)

[https://developers.cloudflare.com/d1/learning/querying-json/](https://developers.cloudflare.com/d1/learning/querying-json/)


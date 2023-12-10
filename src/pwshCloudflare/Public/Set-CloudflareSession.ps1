<#
.SYNOPSIS
    Configures authentication for the Cloudflare API using an API token, legacy authentication (email and global API key), or both.
.DESCRIPTION
    By default configuration data is stored as a [Microsoft.PowerShell.Commands.WebRequestSession] object in $script:cfSession and does not persist across PowerShell sessions.
    Alternatively you can save the configuration to a file to load as needed or on module import. Export-Clixml and Import-Clixml are used to save and load the configuration.
    As such, secrets are not stored securely. See https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/import-clixml?view=powershell-7.3#example-2-import-a-secure-credential-object
    The default path for the configuration file is "$([Environment]::GetFolderPath([Environment+SpecialFolder]::UserProfile))\.pwshCloudflare\config.xml"
.PARAMETER Email
    Specifies the email associated with the Cloudflare account.
.PARAMETER ApiKey
    Specifies the API key associated with the Cloudflare account.
.PARAMETER ApiToken
    Specifies the API token associated with the Cloudflare account.
.PARAMETER SaveToFile
    Indicates whether to save the session data to a file. If specified, the session data will be saved to the file specified by the FilePath parameter.
.PARAMETER LoadOnImport
    Indicates whether to load the session data from the file specified by the FilePath parameter when importing session data.
.PARAMETER ImportFromFile
    Indicates whether to import the session data from a file. If specified, the session data will be imported from the file specified by the FilePath parameter.
.PARAMETER FilePath
    Specifies the path to the file where the session data will be saved or imported from. If not specified, the default path will be used.
.EXAMPLE
    Set-CloudflareSession -Email "user@example.com" -ApiKey "API_KEY"
    Configures legacy authentication for the current session.
.EXAMPLE
    Set-CloudflareSession -Email "user@example.com" -ApiKey "API_KEY" -ApiToken "API_TOKEN"
    Configures legacy authentication and API token authentication for the current session.
.EXAMPLE
    $Splat = @{
        Email        = "user@example.com"
        ApiKey       = "API_KEY"
        ApiToken     = "API_TOKEN"
        SaveToFile   = $true
        LoadOnImport = $true
    }
    Set-CloudflareSession @Splat
    Configures authentication, saves the configuration to the default location and sets the module to load the configuration on import.
.LINK
    https://developers.cloudflare.com/fundamentals/api/
#>
function Set-CloudflareSession {
    [CmdletBinding(DefaultParameterSetName = 'SessionOnly')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Parameter sets are being used to control the flow of the function.')]
    param(
        [Parameter(ParameterSetName = 'SessionOnly')]
        [Parameter(ParameterSetName = 'SaveToFile')]
        [string]$Email,
        [Parameter(ParameterSetName = 'SessionOnly')]
        [Parameter(ParameterSetName = 'SaveToFile')]
        [string]$ApiKey,
        [Parameter(ParameterSetName = 'SessionOnly')]
        [Parameter(ParameterSetName = 'SaveToFile')]
        [string]$ApiToken,
        [Parameter(Mandatory = $true, ParameterSetName = 'SaveToFile')]
        [switch]$SaveToFile,
        [Parameter(ParameterSetName = 'SaveToFile')]
        [bool]$LoadOnImport,
        [Parameter(Mandatory = $true, ParameterSetName = 'ImportFromFile')]
        [switch]$ImportFromFile,
        [Parameter(Mandatory = $false, ParameterSetName = 'SaveToFile')]
        [Parameter(Mandatory = $false, ParameterSetName = 'ImportFromFile')]
        [string]$FilePath = $Script:cfConfigPath
    )

    begin {
        Write-Verbose "$($MyInvocation.MyCommand.Name) :: BEGIN :: $(Get-Date)"
        Write-Verbose "ParameterSetName: $($PSCmdlet.ParameterSetName)"
    }

    process {
        if ($PSCmdlet.ParameterSetName -eq 'ImportFromFile') {
            $FileExists = Test-Path $FilePath
            if (-not $FileExists) {
                throw "File $FilePath does not exist. By default session data only persists for the current PowerShell session. Use -SaveToFile and -ImportFromFile to save and load session data from disk."
            }
            $SavedConfig = Import-Clixml -Path $FilePath
            $Params = @{
                Email    = $SavedConfig.Email
                ApiKey   = $SavedConfig.ApiKey
                ApiToken = $SavedConfig.ApiToken
            }
            $Output = Test-CloudflareSession @Params -ErrorAction Stop
        }
        else {
            $Splat = @{}
            if ($Email) {
                $Splat.Add('Email', $Email)
            }
            if ($ApiKey) {
                $Splat.Add('ApiKey', $ApiKey)
            }
            if ($ApiToken) {
                $Splat.Add('ApiToken', $ApiToken)
            }
            $Output = Test-CloudflareSession @Splat -ErrorAction Stop
        }

        if ($PSCmdlet.ParameterSetName -eq 'SaveToFile') {
            [PSCustomObject]@{
                Email        = $Email
                ApiKey       = $ApiKey
                ApiToken     = $ApiToken
                LoadOnImport = $LoadOnImport
            } | Export-Clixml -Path $FilePath
        }

        $script:cfSession = $Output.Session
        Register-CFArgumentCompleter
        $Output
    }
    end {}
}

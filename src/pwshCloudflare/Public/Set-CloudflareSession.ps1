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
        [Parameter(ParameterSetName = 'SessionOnly')]
        [Parameter(ParameterSetName = 'SaveToFile')]
        [string]$AccountId,
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
                AccountId    = $AccountId
                LoadOnImport = $LoadOnImport
            } | Export-Clixml -Path $FilePath
        }

        $script:cfSession = $Output.Session
        Register-CFArgumentCompleter
        $Output
    }
    end {}
}


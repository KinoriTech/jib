<#
.SYNOPSIS
    Compiles the MarkDown help and deploys to local PowerShell scripts
#>
[CmdletBinding()]
param(
    [ValidateSet('Local', 'Gallery')]
    $Configuration = "Local"
)
# New-ExternalHelp .\docs -OutputPath src\en-US\ -Force

if ($Configuration -eq "Local") {
    $Path = Split-Path $Profile
    Copy-Item "src\Jib.ps1" -Destination "$Path"
    #Copy-Item "src\en-US\Invoke-Jib.xml" -Destination "$Path\Modules\Jib\en-US"
}
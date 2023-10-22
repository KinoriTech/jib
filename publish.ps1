param (
    [string] $apiKey
)

Publish-Module `
    -Path ./src/Jib.ps1 `
    -NuGetApiKey $apiKey `
    -Verbose -Force
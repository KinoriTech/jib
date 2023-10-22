param (
    [string] $apiKey
)

Publish-Script `
    -Path ./src/Jib.ps1 `
    -NuGetApiKey $apiKey `
    -Verbose -Force
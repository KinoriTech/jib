Import-Module PSWriteColor

function Invoke-Jib {
  <#
  .SYNOPSIS
  Provides a CLI with convenient methods for interacting with the Docker 
  container running a Laravel Application.

  .DESCRIPTION
  Jib is a PowerShell implementation of Laravel Sail.

  Laravel Sail is a light-weight command-line interface for interacting with 
  Laravel's default Docker development environment.
  
  Sail provides a great starting point for building a Laravel application using 
  PHP, MySQL, and Redis without requiring prior Docker experience.

  .EXAMPLE
  Invoke-Jib up
   
  Start the application

  .EXAMPLE

  PS> Jib up -d

  .EXAMPLE

  PS> Jib stop

  .EXAMPLE

  PS> Jib restart

  .EXAMPLE

  PS> Jib ps

  #>
  param (
    # The Sail command to run
    [Parameter(Mandatory, ParameterSetName = 'sail', Position = 0)]
    [validateset("up","stop", "restart", "ps")][string]$cmd,
    # If the Sail command should be run in the background. Usefull with 'up'.
    [Parameter(ParameterSetName = 'sail')]
    [switch]$d
  )



# function Show-Help {

#     Write-Host "Laravel Jib"
#     Write-Host
#     Write-Color -Text "Usage:" -Color Yellow
#     Write-Host "  jib COMMAND [options] [arguments]"
#     Write-Host
#     Write-Host "Unknown commands are passed to the docker-compose binary."
#     Write-Host
#     Write-Color -Text "docker-compose Commands:" -Color Yellow
#     Write-Color "sail up", "        Start the application" -Color Green, White
#     Write-Color "sail up -d", "     Start the application in the background" -Color Green, White
#     Write-Color "sail stop", "      Stop the application" -Color Green, White
#     Write-Color "sail restart", "   Restart the application" -Color Green, White
#     Write-Color "sail ps", "        Display the status of all containers" -Color Green, White
#     Write-Host
#     Write-Color -Text "Artisan Commands:" -Color Yellow
#     Write-Color "sail artisan ...", "          Run an Artisan command" -Color Green, White
#     Write-Color "sail artisan queue:work", "" -Color Green, White
#     Write-Host
#     Write-Color -Text "PHP Commands:" -Color Yellow
#     Write-Color "sail php ...", "   Run a snippet of PHP code" -Color Green, White
#     Write-Color "sail php -v", "" -Color Green, White
#     Write-Host
#     Write-Color -Text "Composer Commands:" -Color Yellow
#     Write-Color "sail composer ...", "                       Run a Composer command" -Color Green, White
#     Write-Color "sail composer require laravel/sanctum", "" -Color Green, White
#     Write-Host
#     Write-Color -Text "Node Commands:" -Color Yellow
#     Write-Color "sail node ...", "         Run a Node command" -Color Green, White
#     Write-Color "sail node --version", "" -Color Green, White
#     Write-Host
#     Write-Color -Text "NPM Commands:" -Color Yellow
#     Write-Color "sail npm ...", "        Run a npm command" -Color Green, White
#     Write-Color "sail npx", "            Run a npx command" -Color Green, White
#     Write-Color "sail npm run prod", "" -Color Green, White
#     Write-Host
#     Write-Color -Text "Yarn Commands:" -Color Yellow
#     Write-Color "sail yarn ...", "        Run a Yarn command" -Color Green, White
#     Write-Color "sail yarn run prod", "" -Color Green, White
#     Write-Host
#     Write-Color -Text "Database Commands:" -Color Yellow
#     Write-Color "sail mysql", "     Start a MySQL CLI session within the 'mysql' container" -Color Green, White
#     Write-Color "sail mariadb", "   Start a MySQL CLI session within the 'mariadb' container" -Color Green, White
#     Write-Color "sail psql", "      Start a PostgreSQL CLI session within the 'pgsql' container" -Color Green, White
#     Write-Color "sail redis", "     Start a Redis CLI session within the 'redis' container" -Color Green, White
#     Write-Host
#     Write-Color -Text "Debugging:" -Color Yellow
#     Write-Color "sail debug ...", "          Run an Artisan command in debug mode" -Color Green, White
#     Write-Color "sail debug queue:work", "" -Color Green, White
#     Write-Host
#     Write-Color -Text "Running Tests:" -Color Yellow
#     Write-Color "sail test", "          Run the PHPUnit tests via the Artisan test command" -Color Green, White
#     Write-Color "sail phpunit ...", "   Run PHPUnit" -Color Green, White
#     Write-Color "sail pest ...", "      Run Pest" -Color Green, White
#     Write-Color "sail pint ...", "      Run Pint" -Color Green, White
#     Write-Color "sail dusk", "          Run the Dusk tests (Requires the laravel/dusk package)" -Color Green, White
#     Write-Color "sail dusk:fails", "    Re-run previously failed Dusk tests (Requires the laravel/dusk package)" -Color Green, White
#     Write-Host
#     Write-Color -Text "Container CLI:" -Color Yellow
#     Write-Color "sail shell", "        Start a shell session within the application container" -Color Green, White
#     Write-Color "sail bash", "         Alias for 'sail shell'" -Color Green, White
#     Write-Color "sail root-shell", "   Start a root shell session within the application container" -Color Green, White
#     Write-Color "sail root-bash", "    Alias for 'sail root-shell'" -Color Green, White
#     Write-Color "sail tinker", "       Start a new Laravel Tinker session" -Color Green, White
#     Write-Host
#     Write-Color -Text "Sharing:" -Color Yellow
#     Write-Color "sail share", "   Share the application publicly via a temporary URL" -Color Green, White
#     Write-Color "sail open", "    Open the site in your browser" -Color Green, White
#     Write-Host
#     Write-Color -Text "Binaries:" -Color Yellow
#     Write-Color "sail bin ...", "   Run Composer binary scripts from the vendor/bin directory" -Color Green, White
#     Write-Host
#     Write-Color -Text "Customization:" -Color Yellow
#     Write-Color "sail artisan sail:publish", "   Publish the Sail configuration files" -Color Green, White
#     Write-Color "sail build --no-cache", "       Rebuild all of the Sail containers" -Color Green, White

#     Exit 1

# }

  function Set-Environemnt() {
    <#
    .DESCRIPTION
    Sets environment variables' values from the provided file
    #>
    param (
        # Specifies a path to the file with the environment variables' values
        [string]$EnvFile
    )
    if (Test-Path -Path $EnvFile -PathType leaf) {
      Get-Content -Path $EnvFile | ForEach-Object {
        $name, $value = $_.split('=')
        if($value) {[Environment]::SetEnvironmentVariable($name, $value)}
      }
      return $true
    } else {
      $Cause = "Could not find the '.env' file.`n"
      $Help = "If this is a new Laravel project, you can use the provided 'example' file as a startpoint:`n`n"
      $Copy = "  Copy-Item `".env.example`" -Destination `".env`"`n`n" 
      $Info = "For details about how to configure the Laravel Application, go to:`n"
      $URL = "https://laravel.com/docs/10.x/configuration#environment-configuration"
      Write-Color -Text $Cause, $Help, $Copy, $Info, $URL -Color Red, White, Green, White, Blue
      return $false
    }
  }

  function Show-InactiveLaravel() {
      Write-Color -Text "Sail is not running." -Color Magenta 
      Write-Color "You may run Sail using the following commands: ", "'Invoke-Jib up' or 'Invoke-Jib up -d'" -Color Magenta, Green
  }

  # Source the ".env" file so Laravel's environment variables are available...
  Write-Color -Text "Setting the ENVIRONMENT from the '.env' file" -Color Cyan
  $Loaded = $false
  if ([string]::IsNullOrEmpty($env:APP_ENV) -and (Test-Path -Path "./.env.$env:APP_ENV" -PathType Leaf) ) {
      $Loaded = Set-Environemnt -EnvFile "./.env.$env:APP_ENV"
  } else {
    $Loaded = Set-Environemnt -EnvFile "./.env"
  }
  if (-Not $Loaded) {
    return
  }
  # Define environment variables...
  if([string]::IsNullOrEmpty($env:APP_PORT)) { 
      [Environment]::SetEnvironmentVariable("APP_PORT", 80) 
  }
  if([string]::IsNullOrEmpty($env:APP_SERVICE)) { 
      [Environment]::SetEnvironmentVariable("APP_SERVICE", "laravel.test") 
  }
  if([string]::IsNullOrEmpty($env:DB_PORT)) { 
      [Environment]::SetEnvironmentVariable("DB_PORT", 3306) 
  }
  if([string]::IsNullOrEmpty($env:WWWUSER)) { 
      [Environment]::SetEnvironmentVariable("WWWUSER", 1000) 
  }
  if([string]::IsNullOrEmpty($env:WWWGROUP)) { 
      [Environment]::SetEnvironmentVariable("WWWGROUP", 1000) 
  }
  if([string]::IsNullOrEmpty($env:SAIL_FILES)) { 
      [Environment]::SetEnvironmentVariable("SAIL_FILES", "") 
  }
  if([string]::IsNullOrEmpty($env:SAIL_SHARE_DASHBOARD)) { 
      [Environment]::SetEnvironmentVariable("SAIL_SHARE_DASHBOARD", 4040) 
  }
  if([string]::IsNullOrEmpty($env:SAIL_SHARE_SERVER_HOST)) { 
      [Environment]::SetEnvironmentVariable("SAIL_SHARE_SERVER_HOST", "laravel-sail.site") 
  }
  if([string]::IsNullOrEmpty($env:SAIL_SHARE_SERVER_PORT)) { 
      [Environment]::SetEnvironmentVariable("SAIL_SHARE_SERVER_PORT", 8080) 
  }
  if([string]::IsNullOrEmpty($env:SAIL_SHARE_SUBDOMAIN)) { 
      [Environment]::SetEnvironmentVariable("SAIL_SHARE_SUBDOMAIN", "") 
  }
  if([string]::IsNullOrEmpty($env:SAIL_SHARE_DOMAIN)) { 
      [Environment]::SetEnvironmentVariable("SAIL_SHARE_DOMAIN", $env:SAIL_SHARE_SERVER_HOST) 
  }
  if([string]::IsNullOrEmpty($env:SAIL_SHARE_SERVER)) { 
      [Environment]::SetEnvironmentVariable("SAIL_SHARE_SERVER", "") 
  }

  Write-Color -Text "Deciding what docker compose to use." -Color Cyan 
  docker compose | out-null
  if ($?) {
      $DOCKER_COMPOSE = "docker", "compose"
  } else {
      $DOCKER_COMPOSE = ,"docker-compose"
  }

  if ($env:SAIL_FILES) {
      # Convert SAIL_FILES to an array...
      Write-Color -Text "Using provided sail files." -Color Cyan 
      $SAIL_FILES = $env:SAIL_FILES.Split(":")
      Foreach ($FILE in $SAIL_FILES) {
          if (Test-Path -Path $FILE -PathType Leaf) {
              $DOCKER_COMPOSE = $DOCKER_COMPOSE -join " -f $FILE"    
          } else {
              Write-Color -Text "Unable to find Docker Compose file: $FILE" -Color Magenta 
              Exit 1
          }
      }    
  }

  $EXEC="yes"

  if([string]::IsNullOrEmpty($env:SAIL_SKIP_CHECKS)) { 
      # Ensure that Docker is running...
      Write-Color -Text "Ensure that Docker is running..." -Color Cyan 
      docker info 2>&1>$null
      if ($LASTEXITCODE -ne 0) {
          Write-Color -Text "Docker is not running. Start Docker Desktop." -Color Magenta 
          Exit 1
      }
      # Determine if Sail is currently up...
      Write-Color -Text "Determine if Sail is currently up..." -Color Cyan 
      $cmd = "$DOCKER_COMPOSE ps $env:APP_SERVICE"
      $status = Invoke-Expression $cmd | Select-String -Pattern "Exit\|exited"
      if($status) {
          Write-Color -Text "Shutting down old Sail processes..." -Color Magenta
          $cmd = "$DOCKER_COMPOSE down"
          Invoke-Expression $cmd
          $EXEC="no"
      } else {
          $cmd = "$DOCKER_COMPOSE ps -q"
          $status = Invoke-Expression $cmd
          if ([string]::IsNullOrEmpty($status)) {
              Write-Color -Text "Sail is not running, only up/stop/restart/ps and other docker-composed commands will be invoked" -Color Magenta
              $EXEC="no"
          }
      }
  }

# $SAIL_ARGS = @()

# # Proxy PHP commands to the "php" binary on the application container...
# if ($args[0] -eq "php") {
#     Write-Color -Text "Proxy PHP commands" -Color Cyan 
#     $null, $args = $args

#     if ($EXEC -eq "yes") {
#         $SAIL_ARGS += "exec", "-u", "sail"
#         $SAIL_ARGS += $env:APP_SERVICE, "php", $args
#     } else {
#         Show-InactiveLaravel
#     }
# }

# # Proxy vendor binary commands on the application container...
# elseif ($args[0] -eq "bin") {
#     Write-Color -Text "Proxy vendor binary commands" -Color Cyan 
#     $null, $args = $args

#     if ($EXEC -eq "yes") {
#         $SAIL_ARGS += "exec", "-u", "sail"
#         $dockerCmd = $DOCKER_COMPOSE -join ' '
#         $SAIL_ARGS += $env:APP_SERVICE, $dockerCmd
#     } else {
#         Show-InactiveLaravel
#     }
# }

# # Proxy docker-compose commands to the docker-compose binary on the application container...
# elseif ($args[0] -eq "docker-compose") {
#     Write-Color -Text "Proxy docker-compose commands" -Color Cyan 
#     $null, $args = $args

#     if ($EXEC -eq "yes") {
#         $SAIL_ARGS += "exec", "-u", "sail"
#         $binCmd = $args -join ' '
#         $SAIL_ARGS += $env:APP_SERVICE, "./vendor/bin/$binCmd"
#     } else {
#         Show-InactiveLaravel
#     }
# }

# # Proxy Composer commands to the "composer" binary on the application container...
# elseif ($args[0] -eq "composer") {
#     Write-Color -Text "Proxy Composer commands" -Color Cyan 
#     $null, $args = $args

#     if ($EXEC -eq "yes") {
#         $SAIL_ARGS += "exec", "-u", "sail"
#         $SAIL_ARGS += $env:APP_SERVICE, "composer", $args
#     } else {
#         Show-InactiveLaravel
#     }
# }

# # Proxy Artisan commands to the "artisan" binary on the application container...
# elseif ($args[0] -eq "artisan" -or $args[0] -eq "art") {
#     Write-Color -Text "Proxy Artisan commands to the 'artisan' binary" -Color Cyan 
#     $null, $args = $args

#     if ($EXEC -eq "yes") {
#         $SAIL_ARGS += "exec", "-u", "sail"
#         $SAIL_ARGS += $env:APP_SERVICE, "php artisan", $args
#     } else {
#         Show-InactiveLaravel
#     }
# }

# # Proxy the "debug" command to the "php artisan" binary on the application container with xdebug enabled...
# elseif ($args[0] -eq "debug") {
#     Write-Color -Text "Proxy the 'debug' command to the 'artisan' binary with xdebug enabled" -Color Cyan 
#     $null, $args = $args

#     if ($EXEC -eq "yes") {
#         $SAIL_ARGS += "exec", "-u", "sail"
#         $SAIL_ARGS += $env:APP_SERVICE, "php artisan", $args
#     } else {
#         Show-InactiveLaravel
#     }
# }

# # Pass unknown commands to the "docker-compose" binary...
# else {
#     Write-Color -Text "Pass thru to docker-compose" -Color Cyan 
#     $SAIL_ARGS += $args
# }

  Write-Host $SAIL_ARGS
  $cmd = "$DOCKER_COMPOSE $SAIL_ARGS"
  Invoke-Expression $cmd
}
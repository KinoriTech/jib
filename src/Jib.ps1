<#PSScriptInfo

.VERSION 1.0
.GUID f50d40a4-5ab1-4a3b-9294-4cbe60197c8b
.AUTHOR Horacio Hoyos
.COMPANYNAME Kinori Tech
.COPYRIGHT Kinori tech
.TAGS Laravel Sail Docker
.LICENSEURI https://opensource.org/license/mit/
.PROJECTURI https://github.com/KinoriTech/jib
.ICONURI 
.EXTERNALMODULEDEPENDENCIES PSWriteColor
.RELEASENOTES Initial Release

.DESCRIPTION
Jib provides a Docker powered local development experience for Laravel that is compatible with Windows using PowerShell
#> 

Import-Module PSWriteColor

function Invoke-Jib {
	<#
	.SYNOPSIS
	Jib is PowerShell replacement for the Laravel Sail bash/shell command.

	.DESCRIPTION
	Laravel Sail is a light-weight command-line interface for interacting with
	Laravel's default Docker development environment. Sail provides a great
	starting point for building a Laravel application using PHP, MySQL, and
	Redis without requiring prior Docker experience.

	At its heart, Sail is the docker-compose.yml file and the sail script that
	is stored at the root of your project. The sail script provides a CLI with
	convenient methods for interacting with the Docker containers defined by
	the docker-compose.yml file.

	.EXAMPLE

	PS> Invoke-Jib help
	Jib

	Usage:
	Invoke-Jib -[Command] <String> [options] [arguments]

	Unknown commands are passed to the docker-compose binary.

	docker-compose Commands:
	sail up        Start the application
	sail up -d     Start the application in the background
	sail stop      Stop the application
	sail restart   Restart the application
	sail ps        Display the Status of all containers
	...

	.EXAMPLE

	PS> Invoke-Jib up
	Setting the ENVIRONMENT from the '.env' file
	Deciding what docker compose to use.
	Ensure that Docker is running...
	Determine if Sail is currently up...
	Pass thru to docker-compose up
	Executing command in container: docker compose up
	[+] Running 4/0
	✔ Container eventastic-mailhog-1       Running                                                                    0.0s
	✔ Container eventastic-redis-1         Running                                                                    0.0s
	✔ Container eventastic-mariadb-1       Running                                                                    0.0s
	✔ Container eventastic-laravel.test-1  Running                                                                    0.0s
	Attaching to eventastic-laravel.test-1, eventastic-mailhog-1, eventastic-mariadb-1, eventastic-redis-1
	eventastic-laravel.test-1  |
	eventastic-laravel.test-1  |    INFO  Server running on [http://0.0.0.0:80].
	eventastic-laravel.test-1  |
	eventastic-laravel.test-1  |   Press Ctrl+C to stop the server
	eventastic-laravel.test-1  |


	.LINK

	https://laravel.com/docs/10.x/sail
	#>
	param (
		[Parameter(Position = 0)]
		[string]$Command,

		[Parameter(Position=1, ValueFromRemainingArguments)]
        [string[]]$Remaining
	)

	function Show-Help {

		Write-Host "Jib`n"
		Write-Color -Text "Usage:" -Color Yellow
		Write-Host "Invoke-Jib -[Command] <String> [options] [arguments]`n"
		Write-Host "Unknown commands are passed to the docker-compose binary.`n"
		Write-Color -Text "docker-compose Commands:" -Color Yellow
		Write-Color "sail up", "        Start the application" -Color Green, White
		Write-Color "sail up -d", "     Start the application in the background" -Color Green, White
		Write-Color "sail stop", "      Stop the application" -Color Green, White
		Write-Color "sail restart", "   Restart the application" -Color Green, White
		Write-Color "sail ps", "        Display the Status of all containers" -Color Green, White -LinesAfter 1
		Write-Color -Text "Artisan Commands:" -Color Yellow
		Write-Color "sail artisan ...", "          Run an Artisan command" -Color Green, White
		Write-Color "sail artisan queue:work", "" -Color Green, White -LinesAfter 1
		Write-Color -Text "PHP Commands:" -Color Yellow
		Write-Color "sail php ...", "   Run a snippet of PHP code" -Color Green, White
		Write-Color "sail php -v", "" -Color Green, White -LinesAfter 1
		Write-Color -Text "Composer Commands:" -Color Yellow
		Write-Color "sail composer ...", "                       Run a Composer command" -Color Green, White
		Write-Color "sail composer require laravel/sanctum", "" -Color Green, White -LinesAfter 1
		Write-Color -Text "Node Commands:" -Color Yellow
		Write-Color "sail node ...", "         Run a Node command" -Color Green, White
		Write-Color "sail node --version", "" -Color Green, White -LinesAfter 1
		Write-Color -Text "NPM Commands:" -Color Yellow
		Write-Color "sail npm ...", "        Run a npm command" -Color Green, White
		Write-Color "sail npx", "            Run a npx command" -Color Green, White
		Write-Color "sail npm run prod", "" -Color Green, White -LinesAfter 1
		Write-Color -Text "Yarn Commands:" -Color Yellow
		Write-Color "sail yarn ...", "        Run a Yarn command" -Color Green, White
		Write-Color "sail yarn run prod", "" -Color Green, White -LinesAfter 1
		Write-Color -Text "Database Commands:" -Color Yellow
		Write-Color "sail mysql", "     Start a MySQL CLI session within the 'mysql' container" -Color Green, White
		Write-Color "sail mariadb", "   Start a MySQL CLI session within the 'mariadb' container" -Color Green, White
		Write-Color "sail psql", "      Start a PostgreSQL CLI session within the 'pgsql' container" -Color Green, White
		Write-Color "sail redis", "     Start a Redis CLI session within the 'redis' container" -Color Green, White -LinesAfter 1
		Write-Color -Text "Debugging:" -Color Yellow
		Write-Color "sail debug ...", "          Run an Artisan command in debug mode" -Color Green, White
		Write-Color "sail debug queue:work", "" -Color Green, White -LinesAfter 1
		Write-Color -Text "Running Tests:" -Color Yellow
		Write-Color "sail test", "          Run the PHPUnit tests via the Artisan test command" -Color Green, White
		Write-Color "sail phpunit ...", "   Run PHPUnit" -Color Green, White
		Write-Color "sail pest ...", "      Run Pest" -Color Green, White
		Write-Color "sail pint ...", "      Run Pint" -Color Green, White
		Write-Color "sail dusk", "          Run the Dusk tests (Requires the laravel/dusk package)" -Color Green, White
		Write-Color "sail dusk:fails", "    Re-run previously failed Dusk tests (Requires the laravel/dusk package)" -Color Green, White -LinesAfter 1
		Write-Color -Text "Container CLI:" -Color Yellow
		Write-Color "sail shell", "        Start a shell session within the application container" -Color Green, White
		Write-Color "sail bash", "         Alias for 'sail shell'" -Color Green, White
		Write-Color "sail root-shell", "   Start a root shell session within the application container" -Color Green, White
		Write-Color "sail root-bash", "    Alias for 'sail root-shell'" -Color Green, White
		Write-Color "sail tinker", "       Start a new Laravel Tinker session" -Color Green, White -LinesAfter 1
		Write-Color -Text "Sharing:" -Color Yellow
		Write-Color "sail share", "   Share the application publicly via a temporary URL" -Color Green, White
		Write-Color "sail open", "    Open the site in your browser" -Color Green, White -LinesAfter 1
		Write-Color -Text "Binaries:" -Color Yellow
		Write-Color "sail bin ...", "   Run Composer binary scripts from the vendor/bin directory" -Color Green, White -LinesAfter 1
		Write-Color -Text "Customization:" -Color Yellow
		Write-Color "sail artisan sail:publish", "   Publish the Sail configuration files" -Color Green, White
		Write-Color "sail build --no-cache", "       Rebuild all of the Sail containers" -Color Green, White
		return
	}

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

	# Proxy the "help" command...
	if ($PSBoundParameters.ContainsKey('Command')) {
		if($Command -eq "help" -or $Command -eq "-h" -or $Command -eq "-help" -or $Command -eq "--help") {
			Show-Help
			return
		}
	} else {
		Show-Help
		return
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
		$DockerCompose = "docker", "compose"
	} else {
		$DockerCompose = ,"docker-compose"
	}

	if ($env:SAIL_FILES) {
		# Convert SAIL_FILES to an array...
		Write-Color -Text "Using provided sail files." -Color Cyan
		$SailFiles = $env:SAIL_FILES.Split(":")
		Foreach ($File in $SailFiles) {
			if (Test-Path -Path $File -PathType Leaf) {
				$DockerCompose = $DockerCompose -join " -f $File"
			} else {
				Write-Color -Text "Unable to find Docker Compose file: $File referenced in the SAIL_FILES env variable." -Color Magenta
				return
			}
		}
	}

	$Exec="yes"

	if([string]::IsNullOrEmpty($env:SAIL_SKIP_CHECKS)) {
		# Ensure that Docker is running...
		Write-Color -Text "Ensure that Docker is running..." -Color Cyan
		docker info 2>&1>$null
		if ($LASTEXITCODE -ne 0) {
			Write-Color -Text "Docker is not running. You need to start Docker Desktop in order to use Jib." -Color Magenta
			return
		}
		# Determine if Sail is currently up...
		Write-Color -Text "Determine if Sail is currently up..." -Color Cyan
		$CmdExpr = "$DockerCompose ps $env:APP_SERVICE"
		$Status = Invoke-Expression $CmdExpr | Select-String -Pattern "Exit\|exited"
		if($Status) {
			Write-Color -Text "Shutting down old Sail processes..." -Color Magenta
			$CmdExpr = "$DockerCompose down"
			Invoke-Expression $CmdExpr
			$Exec="no"
		} else {
			$CmdExpr = "$DockerCompose ps -q"
			$Status = Invoke-Expression $CmdExpr
			if ([string]::IsNullOrEmpty($Status)) {
				$Exec="no"
			}
		}
	}

	$SAIL_ARGS = @()

	# Proxy PHP commands to the "php" binary on the application container...
	if ($Command -eq "php") {
		Write-Color -Text "Proxy PHP commands" -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec", "-u", "sail"
			$SAIL_ARGS += $env:APP_SERVICE, "php", $Remaining
		} else {
			Show-InactiveLaravel
		}
	}

	# Proxy vendor binary commands on the application container...
	elseif ($Command -eq "bin") {
		Write-Color -Text "Proxy vendor binary commands" -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec", "-u", "sail"
			$binCmd = $Remaining -join ' '
			$SAIL_ARGS += $env:APP_SERVICE, "./vendor/bin/$binCmd"
		} else {
			Show-InactiveLaravel
		}


	}

	# Proxy docker-compose commands to the docker-compose binary on the application container...
	elseif ($Command -eq "docker-compose") {
		Write-Color -Text "Proxy docker-compose commands" -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec", "-u", "sail"
			$dockerCmd = $DockerCompose -join ' '
			$SAIL_ARGS += $env:APP_SERVICE, $dockerCmd
		} else {
			Show-InactiveLaravel
		}


	}

	# Proxy Composer commands to the "composer" binary on the application container...
	elseif ($Command -eq "composer") {
		Write-Color -Text "Proxy Composer commands" -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec", "-u", "sail"
			$SAIL_ARGS += $env:APP_SERVICE, "composer", $Remaining
		} else {
			Show-InactiveLaravel
		}
	}

	# Proxy Artisan commands to the "artisan" binary on the application container...
	elseif ($Command -eq "artisan" -or $Command -eq "art") {
		Write-Color -Text "Proxy Artisan commands to the 'artisan' binary" -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec", "-u", "sail"
			$SAIL_ARGS += $env:APP_SERVICE, "php artisan", $Remaining
		} else {
			Show-InactiveLaravel
		}
	}

	# Proxy the "debug" command to the "php artisan" binary on the application container with xdebug enabled...
	elseif ($Command -eq "debug") {
		Write-Color -Text "Proxy the 'debug' command to the 'artisan' binary with xdebug enabled" -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec", "-u", "sail"
			$SAIL_ARGS += $env:APP_SERVICE, "php artisan", $Remaining
		} else {
			Show-InactiveLaravel
		}
	}

	# Pass unknown commands to the "docker-compose" binary...
	else {
		Write-Color -Text "Pass thru to docker-compose $Command $Remaining" -Color Cyan
		$SAIL_ARGS += $Command, $Remaining
	}

	$DockerCmd = "$DockerCompose $SAIL_ARGS"
	Write-Color -Text "Executing command in container: ", $DockerCmd -Color Cyan, Yellow
	Invoke-Expression $DockerCmd
}
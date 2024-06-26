<#PSScriptInfo

.VERSION 1.6
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

	NOTE: When passing 'dash' paramters, e.g. -d, you need to scape the dash 
	with a backtick: `-d.

	.EXAMPLE

	PS> Invoke-Jib help
	Jib

	Usage:
	Invoke-Jib -[Command] <String> [options] [arguments]

	Unknown commands are passed to the docker-compose binary.

	docker-compose Commands:
	Invoke-Jib up        Start the application
	Invoke-Jib up `-d     Start the application in the background
	Invoke-Jib stop      Stop the application
	Invoke-Jib restart   Restart the application
	Invoke-Jib ps        Display the Status of all containers
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
	✔ Container app-mailhog-1       Running                                                                    0.0s
	✔ Container app-redis-1         Running                                                                    0.0s
	✔ Container app-mariadb-1       Running                                                                    0.0s
	✔ Container app-laravel.test-1  Running                                                                    0.0s
	Attaching to app-laravel.test-1, app-mailhog-1, app-mariadb-1, app-redis-1
	app-laravel.test-1  |
	app-laravel.test-1  |    INFO  Server running on [http://0.0.0.0:80].
	app-laravel.test-1  |
	app-laravel.test-1  |   Press Ctrl+C to stop the server
	app-laravel.test-1  |


	.LINK

	https://laravel.com/docs/10.x/sail
	#>
	param (
		[Parameter(mandatory=$true, Position = 0)]
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
		Write-Color "Invoke-Jib up", "        Start the application" -Color Green, White
		Write-Color "Invoke-Jib up `-d", "    Start the application in the background" -Color Green, White
		Write-Color "Invoke-Jib stop", "      Stop the application" -Color Green, White
		Write-Color "Invoke-Jib restart", "   Restart the application" -Color Green, White
		Write-Color "Invoke-Jib ps", "        Display the Status of all containers" -Color Green, White -LinesAfter 1
		Write-Color -Text "Artisan Commands:" -Color Yellow
		Write-Color "Invoke-Jib artisan ...", "          Run an Artisan command" -Color Green, White
		Write-Color "Invoke-Jib artisan queue:work", "" -Color Green, White -LinesAfter 1
		Write-Color -Text "PHP Commands:" -Color Yellow
		Write-Color "Invoke-Jib php ...", "   Run a snippet of PHP code" -Color Green, White
		Write-Color "Invoke-Jib php -v", "" -Color Green, White -LinesAfter 1
		Write-Color -Text "Composer Commands:" -Color Yellow
		Write-Color "Invoke-Jib composer ...", "                       Run a Composer command" -Color Green, White
		Write-Color "Invoke-Jib composer require laravel/sanctum", "" -Color Green, White -LinesAfter 1
		Write-Color -Text "Node Commands:" -Color Yellow
		Write-Color "Invoke-Jib node ...", "         Run a Node command" -Color Green, White
		Write-Color "Invoke-Jib node --version", "" -Color Green, White -LinesAfter 1
		Write-Color -Text "NPM Commands:" -Color Yellow
		Write-Color "Invoke-Jib npm ...", "        Run a npm command" -Color Green, White
		Write-Color "Invoke-Jib npx", "            Run a npx command" -Color Green, White
		Write-Color "Invoke-Jib npm run prod", "" -Color Green, White -LinesAfter 1
		Write-Color -Text "Yarn Commands:" -Color Yellow
		Write-Color "Invoke-Jib yarn ...", "        Run a Yarn command" -Color Green, White
		Write-Color "Invoke-Jib yarn run prod", "" -Color Green, White -LinesAfter 1
		Write-Color -Text "Database Commands:" -Color Yellow
		Write-Color "Invoke-Jib mysql", "     Start a MySQL CLI session within the 'mysql' container" -Color Green, White
		Write-Color "Invoke-Jib mariadb", "   Start a MySQL CLI session within the 'mariadb' container" -Color Green, White
		Write-Color "Invoke-Jib psql", "      Start a PostgreSQL CLI session within the 'pgsql' container" -Color Green, White
		Write-Color "Invoke-Jib redis", "     Start a Redis CLI session within the 'redis' container" -Color Green, White -LinesAfter 1
		Write-Color -Text "Debugging:" -Color Yellow
		Write-Color "Invoke-Jib debug ...", "          Run an Artisan command in debug mode" -Color Green, White
		Write-Color "Invoke-Jib debug queue:work", "" -Color Green, White -LinesAfter 1
		Write-Color -Text "Running Tests:" -Color Yellow
		Write-Color "Invoke-Jib test", "          Run the PHPUnit tests via the Artisan test command" -Color Green, White
		Write-Color "Invoke-Jib phpunit ...", "   Run PHPUnit" -Color Green, White
		Write-Color "Invoke-Jib pest ...", "      Run Pest" -Color Green, White
		Write-Color "Invoke-Jib pint ...", "      Run Pint" -Color Green, White
		Write-Color "Invoke-Jib dusk", "          Run the Dusk tests (Requires the laravel/dusk package)" -Color Green, White
		Write-Color "Invoke-Jib dusk:fails", "    Re-run previously failed Dusk tests (Requires the laravel/dusk package)" -Color Green, White -LinesAfter 1
		Write-Color -Text "Container CLI:" -Color Yellow
		Write-Color "Invoke-Jib shell", "        Start a shell session within the application container" -Color Green, White
		Write-Color "Invoke-Jib bash", "         Alias for 'sail shell'" -Color Green, White
		Write-Color "Invoke-Jib root-shell", "   Start a root shell session within the application container" -Color Green, White
		Write-Color "Invoke-Jib root-bash", "    Alias for 'sail root-shell'" -Color Green, White
		Write-Color "Invoke-Jib tinker", "       Start a new Laravel Tinker session" -Color Green, White -LinesAfter 1
		Write-Color -Text "Sharing:" -Color Yellow
		Write-Color "Invoke-Jib share", "   Share the application publicly via a temporary URL" -Color Green, White
		Write-Color "Invoke-Jib open", "    Open the site in your browser" -Color Green, White -LinesAfter 1
		Write-Color -Text "Binaries:" -Color Yellow
		Write-Color "Invoke-Jib bin ...", "   Run Composer binary scripts from the vendor/bin directory" -Color Green, White -LinesAfter 1
		Write-Color -Text "Customization:" -Color Yellow
		Write-Color "Invoke-Jib artisan sail:publish", "   Publish the Sail configuration files" -Color Green, White
		Write-Color "Invoke-Jib build --no-cache", "       Rebuild all of the Sail containers" -Color Green, White
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
			$SAIL_ARGS += "exec"
			$SAIL_ARGS += $env:APP_SERVICE, "php"
			for ($i = 0; $i -lt $Remaining.Count; $i++) {
				$SAIL_ARGS += $Remaining[$i]
			}
		} else {
			Show-InactiveLaravel
			return
		}
	}

	# Proxy vendor binary commands on the application container...
	elseif ($Command -eq "bin") {
		Write-Color -Text "Proxy vendor binary commands" -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec"
			$binCmd = $Remaining -join ' '
			$SAIL_ARGS += $env:APP_SERVICE, "./vendor/bin/$binCmd"
		} else {
			Show-InactiveLaravel
			return
		}


	}

	# Proxy docker-compose commands to the docker-compose binary on the application container...
	elseif ($Command -eq "docker-compose") {
		Write-Color -Text "Proxy docker-compose commands" -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec"
			$dockerCmd = $DockerCompose -join ' '
			$SAIL_ARGS += $env:APP_SERVICE, $dockerCmd
		} else {
			Show-InactiveLaravel
			return
		}


	}

	# Proxy Composer commands to the "composer" binary on the application container...
	elseif ($Command -eq "composer") {
		Write-Color -Text "Proxy Composer commands" -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec"
			$SAIL_ARGS += $env:APP_SERVICE, "composer"
			for ($i = 0; $i -lt $Remaining.Count; $i++) {
				$SAIL_ARGS += $Remaining[$i]
			}
		} else {
			Show-InactiveLaravel
			return
		}
	}

	# Proxy Artisan commands to the "artisan" binary on the application container...
	elseif ($Command -eq "artisan" -or $Command -eq "art") {
		Write-Color -Text "Proxy Artisan commands to the 'artisan' binary" -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec"
			$SAIL_ARGS += $env:APP_SERVICE, "php artisan"
			for ($i = 0; $i -lt $Remaining.Count; $i++) {
				$SAIL_ARGS += $Remaining[$i]
			}
		} else {
			Show-InactiveLaravel
			return
		}
	}

	# Proxy the "debug" command to the "php artisan" binary on the application container with xdebug enabled...
	elseif ($Command -eq "debug") {
		Write-Color -Text "Proxy the 'debug' command to the 'artisan' binary with xdebug enabled" -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec"
			$SAIL_ARGS += "-e XDEBUG_TRIGGER=1"
			$SAIL_ARGS += $env:APP_SERVICE, "php artisan"
			for ($i = 0; $i -lt $Remaining.Count; $i++) {
				$SAIL_ARGS += $Remaining[$i]
			}
		} else {
			Show-InactiveLaravel
			return
		}
	}

	# Proxy the "test" command to the "php artisan test" Artisan command...
	elseif ($Command -eq "test") {
		Write-Color -Text "Proxy the 'test' command to the 'artisan' binary" -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec"
			$SAIL_ARGS += $env:APP_SERVICE, "php artisan test"
			for ($i = 0; $i -lt $Remaining.Count; $i++) {
				$SAIL_ARGS += $Remaining[$i]
			}
		} else {
			Show-InactiveLaravel
			return
		}
	}

	# Proxy the "phpunit" command to "php vendor/bin/phpunit"...
	elseif ($Command -eq "phpunit") {
		Write-Color -Text "Proxy the 'debug' command to the 'phpunit' binary in the vendor folder" -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec"
			$SAIL_ARGS += $env:APP_SERVICE, "php vendor/bin/phpunit"
			for ($i = 0; $i -lt $Remaining.Count; $i++) {
				$SAIL_ARGS += $Remaining[$i]
			}
		} else {
			Show-InactiveLaravel
			return
		}
	}

	# Proxy the "pest" command to "php vendor/bin/pest"...
	elseif ($Command -eq "pest") {
		Write-Color -Text "Proxy the 'pest' command to the 'pest' binary in the vendor folder" -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec"
			$SAIL_ARGS += $env:APP_SERVICE, "php vendor/bin/pest"
			for ($i = 0; $i -lt $Remaining.Count; $i++) {
				$SAIL_ARGS += $Remaining[$i]
			}
		} else {
			Show-InactiveLaravel
			return
		}
	}

	# Proxy the "pint" command to "php vendor/bin/pint"...
	elseif ($Command -eq "pint") {
		Write-Color -Text "Proxy the 'pint' command to the 'pint' binary in the vendor folder" -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec"
			$SAIL_ARGS += $env:APP_SERVICE, "php vendor/bin/pint"
			for ($i = 0; $i -lt $Remaining.Count; $i++) {
				$SAIL_ARGS += $Remaining[$i]
			}
		} else {
			Show-InactiveLaravel
			return
		}
	}

	# Proxy the "dusk" command to the "php artisan dusk" Artisan command...
	elseif ($Command -eq "dusk") {
		Write-Color -Text "Proxy the 'dusk' command to the 'artisan' binary" -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec"
			$SAIL_ARGS += "-e", "APP_URL=http://$env:APP_SERVICE"
        	$SAIL_ARGS += "-e", "DUSK_DRIVER_URL=http://selenium:4444/wd/hub"
        	$SAIL_ARGS += $env:APP_SERVICE, "php artisan dusk"
			for ($i = 0; $i -lt $Remaining.Count; $i++) {
				$SAIL_ARGS += $Remaining[$i]
			}
		} else {
			Show-InactiveLaravel
			return
		}
	}

	# Proxy the "dusk:fails" command to the "php artisan dusk" Artisan command...
	elseif ($Command -eq "dusk:fails") {
		Write-Color -Text "Proxy the 'dusk:fails' command to the 'artisan' binary" -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec"
			$SAIL_ARGS += "-e", "APP_URL=http://$env:APP_SERVICE"
        	$SAIL_ARGS += "-e", "DUSK_DRIVER_URL=http://selenium:4444/wd/hub"
        	$SAIL_ARGS += $env:APP_SERVICE, " php artisan dusk:fails"
			for ($i = 0; $i -lt $Remaining.Count; $i++) {
				$SAIL_ARGS += $Remaining[$i]
			}
		} else {
			Show-InactiveLaravel
			return
		}
	}

	# Initiate a Laravel Tinker session within the application container...
	elseif ($Command -eq "tinker") {
		Write-Color -Text "Initiate a Laravel Tinker session" -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec"
			$SAIL_ARGS += $env:APP_SERVICE, "php artisan tinker"
		} else {
			Show-InactiveLaravel
			return
		}
	}

	# Proxy Node commands to the "node" binary on the application container...
	elseif ($Command -eq "node") {
		Write-Color -Text "Proxy Node commands to the 'node' binary on the container..." -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec"
			$SAIL_ARGS += $env:APP_SERVICE, "node"
			for ($i = 0; $i -lt $Remaining.Count; $i++) {
				$SAIL_ARGS += $Remaining[$i]
			}
		} else {
			Show-InactiveLaravel
			return
		}
	}

	# Proxy NPM commands to the "npm" binary on the application container...
	elseif ($Command -eq "npm") {
		Write-Color -Text "Proxy NPM commands to the 'npm' binary on the container..." -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec"
			$SAIL_ARGS += $env:APP_SERVICE, "npm"
			for ($i = 0; $i -lt $Remaining.Count; $i++) {
				$SAIL_ARGS += $Remaining[$i]
			}
		} else {
			Show-InactiveLaravel
			return
		}
	}

	# Proxy NPX commands to the "npx" binary on the application container...
	elseif ($Command -eq "npx") {
		Write-Color -Text "Proxy NPX commands to the 'npx' binary on the container..." -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec"
			$SAIL_ARGS += $env:APP_SERVICE, "npx"
			for ($i = 0; $i -lt $Remaining.Count; $i++) {
				$SAIL_ARGS += $Remaining[$i]
			}
		} else {
			Show-InactiveLaravel
			return
		}
	}

	# Proxy YARN commands to the "yarn" binary on the application container...
	elseif ($Command -eq "yarn") {
		Write-Color -Text "Proxy YARN commands to the 'yarn' binary on the container..." -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec"
			$SAIL_ARGS += $env:APP_SERVICE, "yarn"
			for ($i = 0; $i -lt $Remaining.Count; $i++) {
				$SAIL_ARGS += $Remaining[$i]
			}
		} else {
			Show-InactiveLaravel
			return
		}
	}

	# Initiate a MySQL CLI terminal session within the "mysql" container...
	elseif ($Command -eq "mysql") {
		Write-Color -Text "Initiate a MySQL CLI terminal session in mysql..." -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec"
			$SAIL_ARGS += "mysql", "bash", "-c"
			$SAIL_ARGS += "MYSQL_PWD=\$env:MYSQL_PASSWORD mysql -u \$env:MYSQL_USER \$env:MYSQL_DATABASE"
		} else {
			Show-InactiveLaravel
			return
		}
	}

	# Initiate a MySQL CLI terminal session within the "mariadb" container...
	elseif ($Command -eq "mysql") {
		Write-Color -Text "Initiate a MySQL CLI terminal session in mariadb..." -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec"
			$SAIL_ARGS += "mariadb", "bash", "-c"
			$SAIL_ARGS += "MYSQL_PWD=\$env:MYSQL_PASSWORD mysql -u \$env:MYSQL_USER \$env:MYSQL_DATABASE"
		} else {
			Show-InactiveLaravel
			return
		}
	}

	# Initiate a PostgreSQL CLI terminal session within the "pgsql" container...
	elseif ($Command -eq "mysql") {
		Write-Color -Text "Initiate a PostgreSQL CLI terminal session in pgsql..." -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec"
			$SAIL_ARGS += "pgsql", "bash", "-c"
			$SAIL_ARGS += "PGPASSWORD=\$env:PGPASSWORD psql -U \$env:POSTGRES_USER \$env:POSTGRES_DB"
		} else {
			Show-InactiveLaravel
			return
		}
	}

	# Initiate a Bash shell within the application container...
	elseif ($Command -eq "shell" -or $Command -eq "bash") {
		Write-Color -Text "Initiate a Bash shell within the application container..." -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec"
			$SAIL_ARGS += "bash"
			for ($i = 0; $i -lt $Remaining.Count; $i++) {
				$SAIL_ARGS += $Remaining[$i]
			}
		} else {
			Show-InactiveLaravel
			return
		}
	}

	# Initiate a root user Bash shell within the application container...
	elseif ($Command -eq "root-shell" -or $Command -eq "root-bash") {
		Write-Color -Text "Initiate a Bash shell within the application container..." -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec"
			$SAIL_ARGS += "bash"
			for ($i = 0; $i -lt $Remaining.Count; $i++) {
				$SAIL_ARGS += $Remaining[$i]
			}
		} else {
			Show-InactiveLaravel
			return
		}
	}

	# Initiate a Redis CLI terminal session within the "redis" container...
	elseif ($Command -eq "redis") {
		Write-Color -Text "Initiate a Redis CLI terminal session within the 'redis' container..." -Color Cyan

		if ($Exec -eq "yes") {
			$SAIL_ARGS += "exec"
			$SAIL_ARGS += "redis", "redis-cli"
		} else {
			Show-InactiveLaravel
			return
		}
	}

	# Share the site...
	elseif ($Command -eq "share") {
		if ($Exec -eq "yes") {
			$SAIL_ARGS =@'
			 docker run --init --rm -p "$SAIL_SHARE_DASHBOARD":4040 -t beyondcodegmbh/expose-server:latest share http://host.docker.internal:"$APP_PORT" \
            --server-host="$SAIL_SHARE_SERVER_HOST" \
            --server-port="$SAIL_SHARE_SERVER_PORT" \
            --auth="$SAIL_SHARE_TOKEN" \
            --server="$SAIL_SHARE_SERVER" \
            --subdomain="$SAIL_SHARE_SUBDOMAIN" \
            --domain="$SAIL_SHARE_DOMAIN" \
'@
	 		for ($i = 0; $i -lt $Remaining.Count; $i++) {
				$SAIL_ARGS += $Remaining[$i]
			}
			Invoke-Expression $SAIL_ARGS
			return 0
		} else {
			Show-InactiveLaravel
			return
		}
	}

	# Open the site...
	elseif ($Command -eq "open") {
		if ($Exec -eq "yes") {
			Start-Process $env:APP_URL
			return 0
		} else {
			Show-InactiveLaravel
			return
		}
	}

	# Pass unknown commands to the "docker-compose" binary...
	else {
		Write-Color -Text "Pass thru to docker-compose $Command $Remaining" -Color Cyan
		$SAIL_ARGS += $Command
		for ($i = 0; $i -lt $Remaining.Count; $i++) {
			$SAIL_ARGS += $Remaining[$i]
		}
	}

	$DockerCmd = "$DockerCompose $SAIL_ARGS"
	Write-Color -Text "Executing command in container: ", $DockerCmd -Color Cyan, Yellow
	Invoke-Expression $DockerCmd
}
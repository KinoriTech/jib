<p align="center"><img src="https://github.com/KinoriTech/jib/raw/HEAD/art/logo.svg" alt="Logo Jib"></p>

<p align="center">
    <a href="www.powershellgallery.com/packages/Jib">
        <img src="https://img.shields.io/powershellgallery/dt/Jib" alt="Total Downloads">
    </a>
    <a href="www.powershellgallery.com/packages/Jib">
        <img src="https://img.shields.io/powershellgallery/v/Jib" alt="Latest Stable Version">
    </a>
    <a href="www.powershellgallery.com/packages/Jib">
        <img src="https://img.shields.io/github/license/kinoritech/jib" alt="License">
    </a>
</p>

## Introduction

Jib provides a Docker powered local development experience for Laravel that is compatible with Windows using PowerShell. Other than Docker, no software or libraries are required to be installed on your local computer before using Jib. Jibs's simple CLI means you can start building your Laravel application without any previous Docker experience.

**NOTE:** When passing 'dash' paramters, e.g. -d, you need to scape the dash with a backtick: `-d.

#### Inspiration

Jib is a drop-in repplacement for [Laravel Sail](https://github.com/laravel/sail).

## Installation

Install the script from a Powershell terminal:
```PowerShell
PS> Install-Script -Name Jib
```
If it is the first time you are installing scripts from the PowerShell Gallery, it is possible that you get a warning about configuring your PATH so installed scripts are available globally.

If you want to use Jib, you would need to run the installed script every time you open a PowerShell terminal. In order for Jib to be available in all your sessions, you add the script to your PowerShell profile. Windows creates the $PROFILE environment variable to point to the current user profile. You can open it with Notepad++ to edit it (if it does not exist, Notepad++ will ask you if you want to create the file):

```PowerShell
PS C:\git\laravel-app\dev>Start notepad++ $profile
```
Edit the profile PS file to load the Jib script. You can add this line to the end of the profile:

```
...
$Path = Split-Path $Profile
. $Path\Scripts\Jib.ps1
```
After saving the changes, go back to the PowerShell terminal and reload your profile:

```PowerShell
PS C:\git\laravel-app\dev>. $profile
```

It is possible that you get an error message while reloading the profile: `Management_Install.ps1 cannot be loaded because the execution of scripts is disabled on this system.`
This [stackoverflow post](https://stackoverflow.com/a/26955050/3837873) provides a great summary of why and how to fix it. After your profile has been reloaded, you should be able to check if Jib is correctly loaded:

```PowerShell
PS C:\git\laravel-app\dev> Get-Help Invoke-Jib
 
NAME
    Invoke-Jib
 
SYNOPSIS
    Jib is PowerShell replacement for the Laravel Sail bash/shell command.
 ...
```
No you can use any of the supported Sail commands, for example, you can start your application:

```PowerShell
PS C:\git\laravel-app\dev> Invoke-Jib up
Setting the ENVIRONMENT from the '.env' file
Deciding what docker compose to use.
Ensure that Docker is running...
Determine if Sail is currently up...
Pass thru to docker-compose up
Executing command in container: docker compose up
[+] Building 0.0s (0/0)
[+] Running 4/0
 ✔ Container laravel-app-mailhog-1       Created                                                                    0.0s
 ✔ Container laravel-app-mariadb-1       Created                                                                    0.0s
 ✔ Container laravel-app-redis-1         Created                                                                    0.0s
 ✔ Container laravel-app-laravel.test-1  Created                                                                    0.0s
...
laravel-app-laravel.test-1  |    INFO  Server running on [http://0.0.0.0:80].
laravel-app-laravel.test-1  |
laravel-app-laravel.test-1  |   Press Ctrl+C to stop the server
laravel-app-laravel.test-1  |
laravel-app-mailhog-1       | [APIv1] KEEPALIVE /api/v1/events
```

## Official Documentation

Jib supports all the Sail CLI commands, so you can refer to the offical Documentation found on the [Laravel website](https://laravel.com/docs/sail).

## Tutorial

I have writen a tutorial on [developing Laravel in Windows](https://kinori.tech/blog/en/2023/10/23/laravel-sail-in-windows-with-docker-and-powershell/?mtm_campaign=github) with Docker and PowerShell that shows how Invoke-Jib can be used.

## License

Jib is open-sourced software licensed under the [MIT license](LICENSE.md).

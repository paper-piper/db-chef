function Resolve-NewServerRepositoryRoot {
    param (
        [string]$StartPath
    )

    $current = Get-Item -LiteralPath $StartPath

    if (-not $current.PSIsContainer) {
        $current = $current.Directory
    }

    while ($current) {
        if (Test-Path -LiteralPath (Join-Path $current.FullName "migrations")) {
            return $current.FullName
        }

        $current = $current.Parent
    }

    throw "Could not find a repository root containing a migrations folder above:$([Environment]::NewLine)$StartPath"
}

function New-NewServerConfig {
    param (
        [string]$LauncherRoot
    )

    $repositoryRoot = Resolve-NewServerRepositoryRoot -StartPath $LauncherRoot
    $localAppData = $env:LOCALAPPDATA

    if ([string]::IsNullOrWhiteSpace($localAppData)) {
        $localAppData = [Environment]::GetFolderPath("LocalApplicationData")
    }

    [pscustomobject]@{
        LauncherRoot = $LauncherRoot
        RepositoryRoot = $repositoryRoot
        MigrationsDir = Join-Path $repositoryRoot "migrations"
        ServersRoot = Join-Path $localAppData "MapaPostgres\servers"
        DatabaseName = "mapa_db"
        PgAdminGroupName = "Servers"
        PgAdminDatabasePath = $null
        PgAdminPythonPath = $null
        ReadinessTimeoutSeconds = 30
    }
}

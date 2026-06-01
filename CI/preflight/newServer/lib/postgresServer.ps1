function Get-ServerName {
    param (
        [string]$Name,
        [int]$Port
    )

    $serverName = if ($null -eq $Name) { "" } else { $Name.Trim() }

    if ([string]::IsNullOrWhiteSpace($serverName)) {
        $serverName = "mapa_$Port"
    }

    $invalidChars = [System.IO.Path]::GetInvalidFileNameChars()

    if ($serverName.IndexOfAny($invalidChars) -ge 0) {
        throw "Server name contains characters that cannot be used in a folder name."
    }

    return $serverName
}

function Initialize-DataDirectory {
    param (
        [string]$DataDir,
        [string]$Name,
        [int]$Port,
        [string]$InitDbPath
    )

    if (Test-Path -LiteralPath $DataDir) {
        $existingItem = Get-ChildItem -LiteralPath $DataDir -Force | Select-Object -First 1

        if ($existingItem) {
            throw "A server named '$Name' already exists at:$([Environment]::NewLine)$DataDir$([Environment]::NewLine)$([Environment]::NewLine)Choose a new name to create a fresh server."
        }
    }
    else {
        New-Item -ItemType Directory -Path $DataDir -Force | Out-Null
    }

    Invoke-PostgresTool `
        -FilePath $InitDbPath `
        -Arguments @("-D", $DataDir, "-U", "postgres", "-A", "trust", "-E", "UTF8") `
        -FailureMessage "Could not initialize a fresh PostgreSQL data directory." | Out-Null

    $configPath = Join-Path $DataDir "postgresql.conf"
    $clusterName = $Name

    if ($clusterName.Length -gt 63) {
        $clusterName = $clusterName.Substring(0, 63)
    }

    Add-Content -LiteralPath $configPath -Value @(
        "",
        "# Added by newServer.ps1",
        "port = $Port",
        "listen_addresses = 'localhost'",
        "cluster_name = $(ConvertTo-PostgresConfigString -Value $clusterName)"
    )
}

function Start-PostgresServer {
    param (
        [int]$Port,
        [string]$Name,
        [pscustomobject]$Config
    )

    $initDbPath = Resolve-PostgresTool -ToolName "initdb"
    $pgCtlPath = Resolve-PostgresTool -ToolName "pg_ctl"
    $psqlPath = Resolve-PostgresTool -ToolName "psql"
    $dataDir = Join-Path $Config.ServersRoot $Name
    $logPath = Join-Path $dataDir "postgres.log"

    Initialize-DataDirectory `
        -DataDir $dataDir `
        -Name $Name `
        -Port $Port `
        -InitDbPath $initDbPath

    if (-not (Test-PortAvailable -Port $Port)) {
        throw "Port $Port became unavailable before PostgreSQL could start."
    }

    $pgCtlProcess = Start-Process `
        -FilePath $pgCtlPath `
        -ArgumentList @("start", "-D", "`"$dataDir`"", "-l", "`"$logPath`"") `
        -WindowStyle Hidden `
        -PassThru

    try {
        Wait-PostgresReady `
            -Port $Port `
            -PsqlPath $psqlPath `
            -TimeoutSeconds $Config.ReadinessTimeoutSeconds
    }
    catch {
        if ($pgCtlProcess -and -not $pgCtlProcess.HasExited) {
            Stop-Process -Id $pgCtlProcess.Id -Force -ErrorAction SilentlyContinue
        }

        try {
            & $pgCtlPath stop -D $dataDir -m fast -w -t 10 | Out-Null
        }
        catch {
            # The startup error below is more useful than a best-effort stop failure.
        }

        throw
    }

    if ($pgCtlProcess -and -not $pgCtlProcess.HasExited) {
        Stop-Process -Id $pgCtlProcess.Id -Force -ErrorAction SilentlyContinue
    }

    return [pscustomobject]@{
        Name = $Name
        Port = $Port
        DataDir = $dataDir
        LogPath = $logPath
    }
}

function Test-PortAvailable {
    param (
        [int]$Port
    )

    if ($Port -lt 1 -or $Port -gt 65535) {
        return $false
    }

    $listeners = @()
    $addresses = @([System.Net.IPAddress]::Loopback)

    if ([System.Net.Sockets.Socket]::OSSupportsIPv6) {
        $addresses += [System.Net.IPAddress]::IPv6Loopback
    }

    try {
        foreach ($address in $addresses) {
            $listener = [System.Net.Sockets.TcpListener]::new($address, $Port)
            $listener.Server.ExclusiveAddressUse = $true
            $listener.Start()
            $listeners += $listener
        }

        return $true
    }
    catch {
        return $false
    }
    finally {
        foreach ($listener in $listeners) {
            $listener.Stop()
        }
    }
}

function Resolve-PostgresTool {
    param (
        [string]$ToolName
    )

    $toolExe = if ($ToolName.EndsWith(".exe")) { $ToolName } else { "$ToolName.exe" }
    $command = Get-Command $toolExe -ErrorAction SilentlyContinue | Select-Object -First 1

    if ($command) {
        return $command.Source
    }

    $roots = @(
        (Join-Path $env:ProgramFiles "PostgreSQL")
    )

    if (${env:ProgramFiles(x86)}) {
        $roots += (Join-Path ${env:ProgramFiles(x86)} "PostgreSQL")
    }

    $candidates = foreach ($root in $roots) {
        if (Test-Path -LiteralPath $root) {
            Get-ChildItem -LiteralPath $root -Recurse -Filter $toolExe -ErrorAction SilentlyContinue
        }
    }

    $tool = $candidates | Sort-Object FullName -Descending | Select-Object -First 1

    if (-not $tool) {
        throw "Could not find $toolExe. Make sure PostgreSQL is installed and its bin folder is on PATH."
    }

    return $tool.FullName
}

function Invoke-PostgresTool {
    param (
        [string]$FilePath,
        [string[]]$Arguments,
        [string]$FailureMessage
    )

    $previousErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"

    try {
        $output = & $FilePath @Arguments 2>&1
        $exitCode = $LASTEXITCODE
    }
    finally {
        $ErrorActionPreference = $previousErrorActionPreference
    }

    if ($exitCode -ne 0) {
        $details = ($output | ForEach-Object { $_.ToString() }) -join [Environment]::NewLine

        if ([string]::IsNullOrWhiteSpace($details)) {
            $details = "Exit code: $exitCode"
        }

        throw "$FailureMessage$([Environment]::NewLine)$details"
    }

    return ($output | ForEach-Object { $_.ToString() }) -join [Environment]::NewLine
}

function Wait-PostgresReady {
    param (
        [int]$Port,
        [string]$PsqlPath,
        [int]$TimeoutSeconds = 30
    )

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    $lastOutput = ""
    $previousConnectTimeout = $env:PGCONNECT_TIMEOUT
    $hadConnectTimeout = Test-Path Env:\PGCONNECT_TIMEOUT

    $env:PGCONNECT_TIMEOUT = "2"

    try {
        while ((Get-Date) -lt $deadline) {
            $previousErrorActionPreference = $ErrorActionPreference
            $ErrorActionPreference = "Continue"

            try {
                $output = & $PsqlPath `
                    "-h" "127.0.0.1" `
                    "-p" "$Port" `
                    "-U" "postgres" `
                    "-d" "postgres" `
                    "-t" `
                    "-A" `
                    "-c" "SELECT 1;" 2>&1

                $exitCode = $LASTEXITCODE
            }
            finally {
                $ErrorActionPreference = $previousErrorActionPreference
            }

            $lastOutput = ($output | ForEach-Object { $_.ToString() }) -join [Environment]::NewLine

            if ($exitCode -eq 0 -and $lastOutput.Trim() -eq "1") {
                return
            }

            Start-Sleep -Milliseconds 500
        }
    }
    finally {
        if ($hadConnectTimeout) {
            $env:PGCONNECT_TIMEOUT = $previousConnectTimeout
        }
        else {
            Remove-Item Env:\PGCONNECT_TIMEOUT -ErrorAction SilentlyContinue
        }
    }

    throw "PostgreSQL started, but did not accept connections on port $Port within $TimeoutSeconds seconds.$([Environment]::NewLine)$lastOutput"
}

function ConvertTo-PostgresConfigString {
    param (
        [string]$Value
    )

    return "'" + $Value.Replace("'", "''") + "'"
}

function ConvertTo-PostgresIdentifier {
    param (
        [string]$Value
    )

    return '"' + $Value.Replace('"', '""') + '"'
}

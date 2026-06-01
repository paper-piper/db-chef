function Ensure-Database {
    param (
        [int]$Port,
        [string]$PsqlPath,
        [string]$DatabaseName
    )

    $databaseNameLiteral = ConvertTo-PostgresConfigString -Value $DatabaseName
    $databaseNameIdentifier = ConvertTo-PostgresIdentifier -Value $DatabaseName
    $existsSql = "SELECT 1 FROM pg_database WHERE datname = $databaseNameLiteral;"

    $exists = Invoke-PostgresTool `
        -FilePath $PsqlPath `
        -Arguments @("-h", "127.0.0.1", "-p", "$Port", "-U", "postgres", "-d", "postgres", "-t", "-A", "-v", "ON_ERROR_STOP=1", "-c", $existsSql) `
        -FailureMessage "Could not check whether database '$DatabaseName' exists."

    if ($exists.Trim() -eq "1") {
        return
    }

    Invoke-PostgresTool `
        -FilePath $PsqlPath `
        -Arguments @("-h", "127.0.0.1", "-p", "$Port", "-U", "postgres", "-d", "postgres", "-v", "ON_ERROR_STOP=1", "-c", "CREATE DATABASE $databaseNameIdentifier;") `
        -FailureMessage "Could not create database '$DatabaseName'." | Out-Null
}

function Get-MigrationFiles {
    param (
        [string]$MigrationsDir
    )

    if (-not (Test-Path -LiteralPath $MigrationsDir)) {
        throw "Migrations folder was not found:$([Environment]::NewLine)$MigrationsDir"
    }

    $migrationFiles = Get-ChildItem -LiteralPath $MigrationsDir -Filter "*.sql" |
        Sort-Object `
            @{ Expression = {
                if ($_.BaseName -match "^\d+") {
                    [int]$Matches[0]
                }
                else {
                    [int]::MaxValue
                }
            } },
            Name

    if (-not $migrationFiles) {
        throw "No .sql files were found in:$([Environment]::NewLine)$MigrationsDir"
    }

    return $migrationFiles
}

function Run-Migrations {
    param (
        [int]$Port,
        [pscustomobject]$Config
    )

    $psqlPath = Resolve-PostgresTool -ToolName "psql"
    $migrationFiles = Get-MigrationFiles -MigrationsDir $Config.MigrationsDir

    Ensure-Database `
        -Port $Port `
        -PsqlPath $psqlPath `
        -DatabaseName $Config.DatabaseName

    foreach ($file in $migrationFiles) {
        Invoke-PostgresTool `
            -FilePath $psqlPath `
            -Arguments @("-h", "127.0.0.1", "-p", "$Port", "-U", "postgres", "-d", $Config.DatabaseName, "-v", "ON_ERROR_STOP=1", "-f", $file.FullName) `
            -FailureMessage "Migration failed: $($file.Name)" | Out-Null
    }
}

function Resolve-PgAdminDatabasePath {
    param (
        [string]$ConfiguredPath
    )

    if (-not [string]::IsNullOrWhiteSpace($ConfiguredPath)) {
        if (Test-Path -LiteralPath $ConfiguredPath) {
            return (Resolve-Path -LiteralPath $ConfiguredPath).Path
        }

        throw "Configured pgAdmin database was not found:$([Environment]::NewLine)$ConfiguredPath"
    }

    $appData = $env:APPDATA

    if ([string]::IsNullOrWhiteSpace($appData)) {
        $appData = [Environment]::GetFolderPath("ApplicationData")
    }

    $candidates = @(
        (Join-Path $appData "pgAdmin\pgadmin4.db"),
        (Join-Path $appData "pgadmin4\pgadmin4.db")
    )

    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate) {
            return (Resolve-Path -LiteralPath $candidate).Path
        }
    }

    throw "Could not find pgAdmin's pgadmin4.db. Open pgAdmin 4 once, then run this script again."
}

function Resolve-PgAdminPython {
    param (
        [string]$ConfiguredPath
    )

    if (-not [string]::IsNullOrWhiteSpace($ConfiguredPath)) {
        if (Test-Path -LiteralPath $ConfiguredPath) {
            return (Resolve-Path -LiteralPath $ConfiguredPath).Path
        }

        throw "Configured pgAdmin Python was not found:$([Environment]::NewLine)$ConfiguredPath"
    }

    $candidates = @()
    $candidateRoots = @(
        (Join-Path $env:ProgramFiles "pgAdmin 4\python\python.exe"),
        (Join-Path $env:LOCALAPPDATA "Programs\pgAdmin 4\python\python.exe")
    )

    if (${env:ProgramFiles(x86)}) {
        $candidateRoots += (Join-Path ${env:ProgramFiles(x86)} "pgAdmin 4\python\python.exe")
    }

    $candidates += $candidateRoots

    foreach ($root in @($env:ProgramFiles, ${env:ProgramFiles(x86)})) {
        if ([string]::IsNullOrWhiteSpace($root)) {
            continue
        }

        $postgresRoot = Join-Path $root "PostgreSQL"

        if (Test-Path -LiteralPath $postgresRoot) {
            $candidates += Get-ChildItem `
                -LiteralPath $postgresRoot `
                -Recurse `
                -Filter "python.exe" `
                -ErrorAction SilentlyContinue |
                Where-Object { $_.FullName -like "*pgAdmin 4*python*" } |
                Sort-Object FullName -Descending |
                Select-Object -ExpandProperty FullName
        }
    }

    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate) {
            return (Resolve-Path -LiteralPath $candidate).Path
        }
    }

    $pathPython = Get-Command python.exe -ErrorAction SilentlyContinue | Select-Object -First 1

    if ($pathPython) {
        return $pathPython.Source
    }

    throw "Could not find Python for updating pgAdmin's SQLite database."
}

function Register-PgAdminServer {
    param (
        [string]$Name,
        [int]$Port,
        [pscustomobject]$Config
    )

    $databasePath = Resolve-PgAdminDatabasePath -ConfiguredPath $Config.PgAdminDatabasePath
    $pythonPath = Resolve-PgAdminPython -ConfiguredPath $Config.PgAdminPythonPath
    $payload = @{
        db_path = $databasePath
        group_name = $Config.PgAdminGroupName
        name = $Name
        host = "127.0.0.1"
        port = $Port
        maintenance_db = "postgres"
        username = "postgres"
    }
    $payloadJson = $payload | ConvertTo-Json -Compress
    $payloadBase64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($payloadJson))
    $scriptBase64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes((Get-PgAdminRegistrationPython)))
    $runner = "import base64; exec(base64.b64decode('$scriptBase64').decode('utf-8'))"

    Invoke-PostgresTool `
        -FilePath $pythonPath `
        -Arguments @("-c", $runner, $payloadBase64) `
        -FailureMessage "Could not register '$Name' in pgAdmin 4." | Out-Null
}

function Get-PgAdminRegistrationPython {
    @'
import base64
import json
import sqlite3
import sys

payload = json.loads(base64.b64decode(sys.argv[1]).decode("utf-8"))

try:
    con = sqlite3.connect(payload["db_path"], timeout=10)
    cur = con.cursor()

    user_row = cur.execute(
        'select id from "user" where active = 1 order by id limit 1'
    ).fetchone()

    if user_row is None:
        user_row = cur.execute('select id from "user" order by id limit 1').fetchone()

    if user_row is None:
        raise RuntimeError("pgAdmin has no user row. Open pgAdmin 4 once, then run this script again.")

    user_id = user_row[0]
    group_name = payload["group_name"]
    group_row = cur.execute(
        "select id from servergroup where user_id = ? and name = ?",
        (user_id, group_name),
    ).fetchone()

    if group_row is None:
        next_group_id = cur.execute("select coalesce(max(id), 0) + 1 from servergroup").fetchone()[0]
        cur.execute(
            "insert into servergroup (id, user_id, name) values (?, ?, ?)",
            (next_group_id, user_id, group_name),
        )
        group_id = next_group_id
    else:
        group_id = group_row[0]

    server_name = payload["name"]
    server_row = cur.execute(
        "select id from server where user_id = ? and servergroup_id = ? and name = ?",
        (user_id, group_id, server_name),
    ).fetchone()

    server_values = {
        "user_id": user_id,
        "servergroup_id": group_id,
        "name": server_name,
        "host": payload["host"],
        "port": payload["port"],
        "maintenance_db": payload["maintenance_db"],
        "username": payload["username"],
        "comment": "Created by DB CI preflight newServer.ps1",
        "password": None,
        "save_password": 0,
        "use_ssh_tunnel": 0,
        "tunnel_authentication": 0,
        "kerberos_conn": 0,
        "cloud_status": 0,
        "connection_params": json.dumps({
            "sslmode": "prefer",
            "connect_timeout": 10,
        }),
        "tunnel_keep_alive": 0,
        "is_adhoc": 0,
        "db_res_type": "databases",
    }
    server_columns = {
        row[1]
        for row in cur.execute("pragma table_info(server)")
    }

    if server_row is None:
        insert_values = {
            key: value
            for key, value in server_values.items()
            if key in server_columns
        }
        columns = list(insert_values.keys())
        placeholders = ", ".join("?" for _ in columns)
        sql = f"insert into server ({', '.join(columns)}) values ({placeholders})"
        cur.execute(sql, [insert_values[column] for column in columns])
    else:
        update_values = {
            key: value
            for key, value in server_values.items()
            if key in server_columns and key not in {"user_id", "servergroup_id", "name"}
        }
        assignments = ", ".join(f"{column} = ?" for column in update_values)
        sql = f"update server set {assignments} where id = ?"
        cur.execute(sql, [*update_values.values(), server_row[0]])

    con.commit()
except sqlite3.OperationalError as exc:
    if "locked" in str(exc).lower():
        raise RuntimeError("pgAdmin's database is locked. Close pgAdmin 4 and run this script again.") from exc
    raise
finally:
    try:
        con.close()
    except NameError:
        pass
'@
}

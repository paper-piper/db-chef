Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = "Stop"

$moduleRoot = if ($PSScriptRoot) {
    $PSScriptRoot
}
elseif ($MyInvocation.MyCommand.Path) {
    Split-Path -Parent $MyInvocation.MyCommand.Path
}
else {
    (Get-Location).Path
}

foreach ($scriptName in @(
    "config.ps1",
    "postgresTools.ps1",
    "postgresServer.ps1",
    "migrations.ps1",
    "pgAdmin.ps1",
    "ui.ps1",
    "events.ps1"
)) {
    . (Join-Path $moduleRoot "lib\$scriptName")
}

function Invoke-NewServerLauncher {
    param (
        [string]$LauncherRoot = $moduleRoot
    )

    $config = New-NewServerConfig -LauncherRoot $LauncherRoot
    $view = New-PostgresLauncherView

    Register-PostgresLauncherEvents -View $view -Config $config

    [void]$view.Form.ShowDialog()
}

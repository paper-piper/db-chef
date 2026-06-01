$launcherRoot = if ($PSScriptRoot) {
    $PSScriptRoot
}
elseif ($MyInvocation.MyCommand.Path) {
    Split-Path -Parent $MyInvocation.MyCommand.Path
}
else {
    (Get-Location).Path
}

. (Join-Path $launcherRoot "main.ps1")

Invoke-NewServerLauncher -LauncherRoot $launcherRoot

function Register-PostgresLauncherEvents {
    param (
        [pscustomobject]$View,
        [pscustomobject]$Config
    )

    $View.StartButton.Add_Click({
        $View.PortInput.BackColor = [System.Drawing.Color]::White
        $View.NameInput.BackColor = [System.Drawing.Color]::White
        $View.StatusLabel.Text = ""

        $port = 0

        if (-not [int]::TryParse($View.PortInput.Text.Trim(), [ref]$port) -or $port -lt 1 -or $port -gt 65535) {
            $View.PortInput.BackColor = [System.Drawing.Color]::LightCoral
            Show-LauncherMessage -Message "Port must be a valid number from 1 to 65535." -Title "Invalid Port" -Icon Error
            return
        }

        if (-not (Test-PortAvailable -Port $port)) {
            $View.PortInput.BackColor = [System.Drawing.Color]::LightCoral
            Show-LauncherMessage -Message "Port $port is already in use." -Title "Port Unavailable" -Icon Error
            return
        }

        $View.StartButton.Enabled = $false
        $View.Form.Cursor = [System.Windows.Forms.Cursors]::WaitCursor

        try {
            $serverName = Get-ServerName -Name $View.NameInput.Text -Port $port

            $View.StatusLabel.Text = "Starting..."
            $View.Form.Refresh()

            $server = Start-PostgresServer -Port $port -Name $serverName -Config $Config

            $View.StatusLabel.Text = "Registering..."
            $View.Form.Refresh()
            Register-PgAdminServer -Name $serverName -Port $port -Config $Config

            if ($View.MigrationsCheckbox.Checked) {
                $View.StatusLabel.Text = "Migrating..."
                $View.Form.Refresh()
                Run-Migrations -Port $port -Config $Config
            }

            Show-LauncherMessage `
                -Message "PostgreSQL '$($server.Name)' is running on port $($server.Port) and registered in pgAdmin under '$($Config.PgAdminGroupName)'.$([Environment]::NewLine)$([Environment]::NewLine)Data:$([Environment]::NewLine)$($server.DataDir)" `
                -Title "Success" `
                -Icon Information

            $View.Form.Close()
        }
        catch {
            if ($_.Exception.Message -like "Server name*" -or $_.Exception.Message -like "A server named*") {
                $View.NameInput.BackColor = [System.Drawing.Color]::LightCoral
            }

            Show-LauncherMessage -Message $_.Exception.Message -Title "Could Not Start PostgreSQL" -Icon Error
        }
        finally {
            $View.Form.Cursor = [System.Windows.Forms.Cursors]::Default
            $View.StartButton.Enabled = $true
            $View.StatusLabel.Text = ""
        }
    })
}

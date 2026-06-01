function Show-LauncherMessage {
    param (
        [string]$Message,
        [string]$Title,
        [System.Windows.Forms.MessageBoxIcon]$Icon
    )

    [System.Windows.Forms.MessageBox]::Show(
        $Message,
        $Title,
        [System.Windows.Forms.MessageBoxButtons]::OK,
        $Icon
    ) | Out-Null
}

function New-PostgresLauncherView {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Postgres Launcher"
    $form.Size = New-Object System.Drawing.Size(320, 245)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false

    $portLabel = New-Object System.Windows.Forms.Label
    $portLabel.Text = "Port"
    $portLabel.Location = New-Object System.Drawing.Point(20, 20)
    $portLabel.AutoSize = $true
    $form.Controls.Add($portLabel)

    $portInput = New-Object System.Windows.Forms.TextBox
    $portInput.Location = New-Object System.Drawing.Point(20, 45)
    $portInput.Size = New-Object System.Drawing.Size(250, 20)
    $portInput.Text = "5432"
    $form.Controls.Add($portInput)

    $nameLabel = New-Object System.Windows.Forms.Label
    $nameLabel.Text = "Name (optional)"
    $nameLabel.Location = New-Object System.Drawing.Point(20, 75)
    $nameLabel.AutoSize = $true
    $form.Controls.Add($nameLabel)

    $nameInput = New-Object System.Windows.Forms.TextBox
    $nameInput.Location = New-Object System.Drawing.Point(20, 100)
    $nameInput.Size = New-Object System.Drawing.Size(250, 20)
    $form.Controls.Add($nameInput)

    $migrationsCheckbox = New-Object System.Windows.Forms.CheckBox
    $migrationsCheckbox.Text = "Run migrations?"
    $migrationsCheckbox.Location = New-Object System.Drawing.Point(20, 130)
    $migrationsCheckbox.AutoSize = $true
    $form.Controls.Add($migrationsCheckbox)

    $statusLabel = New-Object System.Windows.Forms.Label
    $statusLabel.Text = ""
    $statusLabel.Location = New-Object System.Drawing.Point(110, 166)
    $statusLabel.Size = New-Object System.Drawing.Size(160, 30)
    $statusLabel.ForeColor = [System.Drawing.SystemColors]::GrayText
    $form.Controls.Add($statusLabel)

    $startButton = New-Object System.Windows.Forms.Button
    $startButton.Text = "Start"
    $startButton.Location = New-Object System.Drawing.Point(20, 160)
    $startButton.Size = New-Object System.Drawing.Size(80, 30)
    $form.Controls.Add($startButton)

    [pscustomobject]@{
        Form = $form
        PortInput = $portInput
        NameInput = $nameInput
        MigrationsCheckbox = $migrationsCheckbox
        StatusLabel = $statusLabel
        StartButton = $startButton
    }
}

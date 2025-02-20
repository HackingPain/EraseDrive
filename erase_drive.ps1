# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    [System.Windows.Forms.MessageBox]::Show("Please run this script as an Administrator.", "Insufficient Privileges", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    exit
}

# Load required assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Retrieve non-system disks
$disks = Get-Disk | Where-Object { -not $_.IsSystem }

# Create a DataTable to hold disk information
$table = New-Object System.Data.DataTable
$table.Columns.Add("Number", [int])
$table.Columns.Add("FriendlyName", [string])
$table.Columns.Add("OperationalStatus", [string])
$table.Columns.Add("Size (GB)", [string])

foreach ($disk in $disks) {
    $sizeGB = [math]::Round($disk.Size / 1GB, 2)
    $row = $table.NewRow()
    $row["Number"] = $disk.Number
    $row["FriendlyName"] = $disk.FriendlyName
    $row["OperationalStatus"] = $disk.OperationalStatus
    $row["Size (GB)"] = $sizeGB
    $table.Rows.Add($row)
}

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Disk Eraser GUI"
$form.Size = New-Object System.Drawing.Size(600, 400)
$form.StartPosition = "CenterScreen"

# Create a DataGridView to display disks
$grid = New-Object System.Windows.Forms.DataGridView
$grid.Location = New-Object System.Drawing.Point(10, 10)
$grid.Size = New-Object System.Drawing.Size(560, 280)
$grid.AutoSizeColumnsMode = [System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::Fill
$grid.ReadOnly = $true
$grid.SelectionMode = [System.Windows.Forms.DataGridViewSelectionMode]::FullRowSelect
$grid.DataSource = $table
$form.Controls.Add($grid)

# Create the "Erase Disk" button
$btnErase = New-Object System.Windows.Forms.Button
$btnErase.Location = New-Object System.Drawing.Point(10, 300)
$btnErase.Size = New-Object System.Drawing.Size(100, 30)
$btnErase.Text = "Erase Disk"
$form.Controls.Add($btnErase)

# Create the "Exit" button
$btnExit = New-Object System.Windows.Forms.Button
$btnExit.Location = New-Object System.Drawing.Point(480, 300)
$btnExit.Size = New-Object System.Drawing.Size(100, 30)
$btnExit.Text = "Exit"
$form.Controls.Add($btnExit)

# Define the Erase button click event
$btnErase.Add_Click({
    if ($grid.SelectedRows.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Please select a disk to erase.", "No Disk Selected", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }
    
    # Get the selected disk's details
    $selectedRow = $grid.SelectedRows[0]
    $diskNumber = $selectedRow.Cells["Number"].Value
    $friendlyName = $selectedRow.Cells["FriendlyName"].Value
    
    $msg = "WARNING: This will completely erase all data on Disk $diskNumber ($friendlyName)." + "`nAre you sure you want to continue?"
    $confirm = [System.Windows.Forms.MessageBox]::Show($msg, "Confirm Erase", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Warning)
    
    if ($confirm -eq [System.Windows.Forms.DialogResult]::Yes) {
        try {
            # Erase the disk without further confirmation
            Clear-Disk -Number $diskNumber -RemoveData -Confirm:$false
            [System.Windows.Forms.MessageBox]::Show("Erase operation completed on Disk $diskNumber.", "Operation Completed", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
            
            # Refresh disk list in the grid after erase
            $table.Rows.Clear()
            $disks = Get-Disk | Where-Object { -not $_.IsSystem }
            foreach ($disk in $disks) {
                $sizeGB = [math]::Round($disk.Size / 1GB, 2)
                $row = $table.NewRow()
                $row["Number"] = $disk.Number
                $row["FriendlyName"] = $disk.FriendlyName
                $row["OperationalStatus"] = $disk.OperationalStatus
                $row["Size (GB)"] = $sizeGB
                $table.Rows.Add($row)
            }
        }
        catch {
            [System.Windows.Forms.MessageBox]::Show("Error erasing disk: $_", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    }
})

# Define the Exit button click event
$btnExit.Add_Click({
    $form.Close()
})

# Run the form
[System.Windows.Forms.Application]::Run($form)

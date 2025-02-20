# Disk Eraser GUI

This PowerShell script provides a graphical interface for safely erasing a selected disk on a Windows machine. It lists non-system disks, lets you select one from a grid, and then, after confirmation, erases the disk using the built-in Clear-Disk cmdlet.

---

## Features

- **Administrator Check:**  
  Ensures the script is run with administrative privileges.

- **Disk Listing:**  
  Retrieves all non-system disks using `Get-Disk` and displays details such as disk number, friendly name, operational status, and size in GB.

- **Graphical User Interface:**  
  Uses Windows Forms to present a DataGridView for selecting a disk and includes buttons for erasing or exiting.

- **User Confirmation:**  
  Provides a warning and confirmation prompt before performing the erase operation.

- **Automatic Refresh:**  
  After a disk is erased, the script refreshes the disk list to show the updated state.

---

## Requirements

- **Operating System:** Windows  
- **Software:** PowerShell (version 5.1 or later recommended)  
- **Permissions:** Must be run as an Administrator

---

## Usage

1. **Run as Administrator:**  
   - Right-click the script file and select **"Run with PowerShell"**.  
   - Alternatively, open a PowerShell window with administrative rights and execute the script.

2. **Select Disk:**  
   - The GUI will display a list of non-system disks.
   - Click on a disk row to select the disk you want to erase.

3. **Erase Disk:**  
   - Click the **"Erase Disk"** button.
   - Confirm the warning prompt to proceed with erasing the selected disk.

4. **Exit:**  
   - Click the **"Exit"** button to close the GUI once you're finished.

---

## Warning

- **Irreversible Operation:**  
  This script will permanently erase all data on the selected disk. Double-check your selection and be sure you want to proceed.

- **Use with Caution:**  
  Make sure that the disk you choose is not needed for system operations or data storage.

---

## How It Works

- **Administrator Check:**  
  The script verifies that it is running with administrative rights before proceeding.

- **Data Retrieval:**  
  It uses `Get-Disk` to retrieve available disks (excluding the system disk) and populates a DataTable, which is bound to a DataGridView for display.

- **Disk Erasure:**  
  Once a disk is selected and the operation is confirmed, the script calls `Clear-Disk` with the `-RemoveData` flag to erase the disk without further confirmation.

- **User Interface:**  
  The GUI is built with Windows Forms, providing a simple and clear interface for disk selection and operation control.

---

## Troubleshooting

- **No Disks Listed:**  
  - Ensure you have non-system disks connected.
  - Verify that the disks are not hidden by any system policy.

- **Script Not Running:**  
  - Confirm that you are running the script as an Administrator.
  - Check your PowerShell execution policy if the script is blocked:
    ```powershell
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    ```

- **Error Messages:**  
  - Read the error messages displayed in the GUI for guidance.
  - Consult the PowerShell documentation for cmdlet details if needed.

---

## Disclaimer

**Warning:** This script performs an irreversible operation that permanently erases all data on the selected disk. Use it at your own risk. Ensure you have backed up any important data before proceeding. The author is not responsible for any data loss or damage.

---

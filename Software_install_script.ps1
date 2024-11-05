# Directory containing installers
$installerPath = "\\path\to\file\location"

# Function to list all files
function Get-AllFiles {
    Get-ChildItem -Path $installerPath -File -ErrorAction Stop
}

# Function to display the menu
function Show-Menu {
    cls
    Write-Host "Software Installation Menu" -ForegroundColor Cyan
    Write-Host "----------------------------" -ForegroundColor Green

    # Show all files for debugging
    try {
        $allFiles = Get-AllFiles
        if ($allFiles.Count -eq 0) {
            Write-Host "No files found in the specified directory." -ForegroundColor Red
            return
        }
    } catch {
        Write-Host "Error accessing the directory: $_" -ForegroundColor Red
        return
    }

    # Filter installer files
    $installerFiles = $allFiles | Where-Object { $_.Extension -eq ".exe" -or $_.Extension -eq ".msi" -or $_.Extension -eq ".bat" }
    
    if ($installerFiles.Count -eq 0) {
        Write-Host "No installer files (*.exe, *.msi, *.bat) found." -ForegroundColor Red
    } else {
        $index = 1
        foreach ($installer in $installerFiles) {
            Write-Host "$index. $($installer.Name)"
            $index++
        }
    }

    Write-Host "0. Exit"
}

# Main loop
do {
    Show-Menu
    $choice = Read-Host "Select a number"

    switch ($choice) {
		
        {$_ -gt 0} { 
            $installerFiles = Get-AllFiles | Where-Object { $_.Extension -eq ".exe" -or $_.Extension -eq ".msi"  -or $_.Extension -eq ".bat"}
			
            if ($installerFiles.Count -ge $choice) {
				
                $selectedInstaller = $installerFiles[$choice - 1]
				
                $confirm = Read-Host "Are you sure you want to install $($selectedInstaller.Name)? (Y/N)"
				
                if ($confirm -eq 'Y' -or $confirm -eq 'y') {
					
                    Write-Host "Installing: $($selectedInstaller.Name)" -ForegroundColor Yellow
                    
                    # Start the installer with elevated privileges
                    try {
						
                        Start-Process -FilePath $selectedInstaller.FullName -Verb RunAs -Wait -ErrorAction Stop
                        Write-Host "$($selectedInstaller.Name) installed." -ForegroundColor Green
						
                    } catch {
						
                        Write-Host "Failed to install $($selectedInstaller.Name): $_" -ForegroundColor Red
                    }
                    Pause
					
                } else {
					
                    Write-Host "Installation canceled." -ForegroundColor Red
                }
				
            } else {
				
                Write-Host "Invalid selection. Please try again." -ForegroundColor Red
            }
        }
		
        0 {
			
            Write-Host "Thank you for using the installation menu. Goodbye!" -ForegroundColor Green
            Start-Sleep -Seconds 2  # Optional: pause before exiting
        }
		
        default { Write-Host "Invalid selection. Please try again." -ForegroundColor Red }
    }
	
} while ($choice -ne '0')

<#
.SYNOPSIS
    Enter synopsis here

.DESCRIPTION
    This script provides a menu-driven interface for installing software from a specified directory.
    It allows users to select and confirm installations of executable, MSI, and batch files.

.PARAMETER installerPath
    Specifies the path to the directory containing the installer files.

.EXAMPLE
    Run the script to view available installers and select one to install.

.VERSION 1.0.0
.AUTHOR Corey A. Howarth
.CREATED 2024-10-14
.LASTUPDATED 2024-10-15
#>

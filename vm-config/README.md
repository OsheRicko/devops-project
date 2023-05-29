
# Setting the VM Environment

## Task 1: Connect to the VM

- Search for "Virtual machine."
- Click on "client-vm" and connect using RDP.
- Download the RDP file.
- Enter the credentials to connect to the VM.

## Task 2: Setup az cli, Docker, and WSL

- Open PowerShell and enter the following commands:

  - To install az cli:
    ```powershell
    $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; Remove-Item .\AzureCLI.msi
    ```

  - To download WSL:
    ```powershell
    wsl --install
    ```

-- Reboot the VM.

- After the reboot, it will automatically open the Ubuntu download.
- Install and launch Ubuntu.
- Create a username and password (sudo user).
- Close the Ubuntu window.

- Open a web browser and search for Docker Desktop for Windows.
- Download Docker Desktop for Windows.
- Open the downloaded file (an installer) and install Docker.

--Reboot the VM once again.

- You are ready to go!

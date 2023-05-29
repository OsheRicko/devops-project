
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

- Reboot the VM.

- After the reboot, it will automatically open the Ubuntu download.
- Install and launch Ubuntu.
- Create a username and password (sudo-user).
- Close the Ubuntu window.

- Open a web browser and search for Docker Desktop for Windows.
- Download Docker Desktop for Windows.
- Open the downloaded file (an installer) and install Docker.

- Reboot the VM once again.


## task 3:Create the jenkins container

  ### note: if you don't manage to run docker build/run command add sudo before the command.
   - Open WSL.
   - Start Docker: `sudo service docker start`.
   - Clone the joska repo, which contains the Jenkins container you are going to modify with your own Dockerfile:
     ```bash
     git clone https://github.com/Joska99/joska.git
     ```
   - Move to the desired directory:
     ```bash
     cd joska/docker/stateful-jenkins
     ```
   - Remove the existing Dockerfile:
     ```bash
     rm Dockerfile
     ```
   - Go to GitHub and copy the content of the Dockerfile from `devops-project/pipeline-config`.

   - Create a new Dockerfile in WSL:
     ```bash
     vim Dockerfile
     ```

   - Paste the content into the file, then press `i` for insert mode, right-click to paste, and save with `Esc` followed by `:wq`.
   
   - Make a directory to host jenkins 
     ```bash
      mkdir jenkins_home
      ```

   - Build the Docker image:
     ```bash
     docker build -t stateful-jenkins .
     ```

   - Run the container and access Jenkins at `127.0.0.1:8000` or `localhost:8000`:
     ```bash
     docker run -p 8000:8080 -p 50000:50000 -v /var/run/docker.sock:/var/run/docker.sock -d --name stf-jenkins --restart=on-failure -t stateful-jenkins
     ```

   - Wait a few minutes for the Jenkins server to start.
  
  # Done
  # Continue to Pipeline-Config
  

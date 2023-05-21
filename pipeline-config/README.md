#WALKTHROUGH
------------

VM CONFIGURATION FOR THE JENKINS CONTAINER TO RUN ON.
-----------------------------------------------------

1. Connect to the TestVM (note: it's not the best practice, but it will serve as a container for the Jenkins pipeline due to quota limits).

2. Download Docker Desktop, WSL, and Azure CLI.

3. Perform the following steps in WSL:
   - Open WSL.
   - If it's your first time using WSL, configure the user and password.
   - Start Docker: `sudo service docker start`.
   - Clone the joska repo, which contains the Jenkins container you are going to modify with your own Dockerfile:
     ```bash
     git clone https://github.com/Joska99/joska.git
     ```
   - Move to the desired directory:
     ```bash
     cd /joska/docker/stateful-jenkins
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

   - Build the Docker image:
     ```bash
     docker build -t stateful-jenkins .
     ```

   - Run the container and access Jenkins at `127.0.0.1:8000` or `localhost:8000`:
     ```bash
     docker run -p 8000:8080 -p 50000:50000 -v /var/run/docker.sock:/var/run/docker.sock -d --name stf-jenkins --restart=on-failure -t stateful-jenkins
     ```

   - Wait a few minutes for the Jenkins server to start.

4. Connect to the Jenkins container:
   ```bash
   docker exec -it --user root stf-jenkins bash
   
5. Connect to the Jenkins container: 
   ```bash 
   docker exec -it --user root stf-jenkins bash
   
 6. Connect to the Jenkins container:
    ```bash
    docker exec -it --user root stf-jenkins bash
7. Use the output as the password in Jenkins and create your credentials for future container connections.

8. Install the following plugins in Jenkins: "Azure CLI," "Docker pipeline," "Azure credentials," and "Kubernetes CLI."

9. Create a new pipeline:
   - From the top left pane, click "+New Item."
   - Enter a name for the pipeline, select the type, and click "OK."

10. Configure the pipeline:
    - Copy the content from `devops-project/pipeline-config/pipeline-code`.
    - Paste the code into the script area.

11. Add a trigger to the pipeline:
    - Scroll up and locate "Build periodically."
    - Add the following syntax:
        ```makefile
        TZ=Asia/Jerusalem
        H 10 * * 0,2,4,6
        ```

12. Save the pipeline and create another pipeline using the same syntax but with a different build trigger:
    - In the build trigger section, add the following syntax:
        ```makefile
        TZ=Asia/Jerusalem
        H 10 * * 1,3,5,7
        ```

13. Modify the code to retrieve the second key and rotate the first one:
    - Change line 41 to: `'script: "az storage account keys list -n ${env.AZURE_STORAGE_ACCOUNT} --query '[1].value' -o tsv"'`.
    - Change line 56 to: `'sh "az storage account keys renew -n ${env.AZURE_STORAGE_ACCOUNT} --resource-group ${env.AZURE_RESOURCE_GROUP} --key key1"'`.
      Note: If you used the value of 0 in line 41, you would have retrieved key 1. In line 56, we changed it to rotate key1 instead of key2.

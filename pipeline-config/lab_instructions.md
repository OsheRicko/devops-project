
Lab Setup Instructions
To create a lab out of your logs, follow these steps:

1. Connect to the TestVM (note: it's not a recommended practice, but it serves as a container for the Jenkins pipeline due to quota limits).

2. Download and install the following tools: Docker Desktop, WSL (Windows Subsystem for Linux), and Azure CLI.

3. Perform the following steps in WSL:

a. Open WSL.
b. If it's your first time using WSL, configure the user and password.
c. Start Docker: sudo service docker start.
d. Clone the joska repository, which contains the Jenkins container you will modify with your own Dockerfile:
bash
Copy code
git clone https://github.com/Joska99/joska.git
e. Move to the desired directory:
bash
Copy code
cd /joska/docker/stateful-jenkins
f. Remove the existing Dockerfile:
bash
Copy code
rm Dockerfile
g. Go to GitHub and copy the content of the Dockerfile from devops-project/pipeline-config.
h. Create a new Dockerfile in WSL:
Copy code
vim Dockerfile
i. Paste the content into the file, then press i for insert mode, right-click to paste, and save with Esc followed by :wq.
j. Build the Docker image:
Copy code
docker build -t stateful-jenkins .
k. Run the container and access Jenkins at 127.0.0.1:8000 or localhost:8000:
arduino
Copy code
docker run -p 8000:8080 -p 50000:50000 -v /var/run/docker.sock:/var/run/docker.sock -d --name stf-jenkins --restart=on-failure -t stateful-jenkins
l. Wait a few minutes for the Jenkins server to start.
4. Connect to the Jenkins container:

sql
Copy code
docker exec -it --user root stf-jenkins bash
5. Retrieve the Jenkins initial admin password using the following command:

bash
Copy code
cat /var/jenkins_home/secrets/initialAdminPassword
6. Use the output as the password in Jenkins and create your credentials for future container connections.

7. Install the following plugins in Jenkins: "Azure CLI," "Docker pipeline," "Azure credentials," and "Kubernetes CLI."

8. Create a new pipeline:

From the top left pane, click "+New Item."
Enter a name for the pipeline, select the type, and click "OK."
9. Configure the pipeline:

Copy the content from devops-project/pipeline-config/pipeline-code.
Paste the code into the script area.
10. Add a trigger to the pipeline:

Scroll up and locate "Build periodically."
Add the following syntax:
makefile
Copy code
TZ=Asia/Jerusalem
H 10 * * 0,2,4,6
11. Save the pipeline and create another pipeline using the same syntax but with a different build trigger:

In the build trigger section, add the following syntax:
makefile
Copy code
TZ=Asia/Jerusalem
H 10 * * 1,3,5,7
12. Modify the code to retrieve the second key and rotate the first one:

Change line 41 to: 'script: "az storage account keys list -n ${env.AZURE_STORAGE_ACCOUNT} --query '[1].value' -o tsv"'.
Change line 56 to: 'sh "az storage account keys renew -n ${env.AZURE_STORAGE_ACCOUNT} --resource-group ${env.AZURE_RESOURCE_GROUP} --key key1"'.
Note: If you used the value of 0 in line 41, you would have retrieved key 1. In line 56, we changed it to rotate key1 instead of key2.
13. Save the pipeline. That's it!
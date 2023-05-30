
# Setting the pipelines (CI)
## Task 1: Set the jenkins environment.
- Open web browser enter the container we created earlier:
  ```
  localhost:8000
    ```
 - You would be asked for a password to fill, In order to get the password:
   
	 - Connect to the Jenkins container:
	   ```bash
	   docker exec -it --user root stf-jenkins bash
	   ```
	  - Retrieve the password using 
		  ```bash
	    cat /var/jenkins_home/secrets/initialAdminPassword
	    ```
	- Use the output as the password in Jenkins
	
-  Create your credentials for future container connections.

- Go to manage jenkins --> plugins --> available

- Install the following plugins in Jenkins without restart: "Azure CLI", "Azure credentials", "Docker pipeline" and "Kubernetes CLI."

## Task 2: Create the pipelines
### First pipeline:
### Code:
- From the top left pane, click "+New Item."

- Enter a name for the pipeline, select the type, and click "OK."

- Copy the content from `devops-project/pipeline-config/pipeline-code`.
And paste the code into the script area.

### Trigger:
- Add a trigger to the pipeline:

- Scroll up and locate "Build periodically."

- Add the following syntax:
     ```makefile
     TZ=Asia/Jerusalem
     H 10 * * 0,2,4,6
     ```
- Save the pipeline.
## Second pipeline:
### Code:
   - For the code repeat the First pipeline Code steps, make these changes:
   
   - Modify the code to retrieve the second key and rotate the first one:

	    - Change line 42 to: 
	    ```
	    az storage account keys list -n ${env.AZURE_STORAGE_ACCOUNT} --query '[1].value' -o tsv
	    ```
	    
	    - Change line 121 to:
	    ```
	    az storage account keys renew -n ${env.AZURE_STORAGE_ACCOUNT} --resource-group ${env.AZURE_RESOURCE_GROUP} --key key1
	    ```
	    
   - Make sure you change the environment to use yours, for the ip use you vm ip.
	
### Trigger:    
- In the build trigger section, add the following syntax:
     ```makefile
     TZ=Asia/Jerusalem
     H 10 * * 1,3,5,7
     ```
- Save the pipeline.
# You've completed the lab.
### To test it: 
- Enter one of the pipelines and click "Build Now" make sure that you've deployed the updated app.

- Go to the aks in the portal connect using the cloud shell
- Retrive the ingress lb ip:
  ``` bash
  kubectl get ingress webapp-ingress -o=jsonpath='{.status.loadBalancer.ingress[0].ip}'
  ```
   Enter the ip to the URL, like that
   ```
   <The_ip_you_got>/635/osher/appdata
   ```
 Note: it failed because this is not the client vm.
 - Try again the same URL, using the client vm.
 
#  Clean up resources
- Open Cloudshell, use bash

- Run this command:
	```
	az group delete --name ot-app-rg --yes --no-wait && az group delete --name client-rg --yes --no-wait && az group delete --name NetworkWatcherRG --yes --no-wait && az group delete --name DefaultResourceGroup-WEU --yes --no-wait && az group delete --name MC_ot-app-rg_ot-app-aks_westeurope --yes --no-wait && az group delete --name cloud-shell-storage-westeurope --yes --no-wait
	```
# Done!

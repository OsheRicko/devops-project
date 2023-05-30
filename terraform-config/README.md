# Terraform
## Main Task: Setting the environment using terraform

- Open Powershell

- Connect to your azure account using: 
  ``` bash
  az login
  ```
Note: if you have multiple subscription in your account, use this:
   ``` bash
  az account set --subscription <your_subscription_id>
  ```
  - Clone my repo
    ``` bash
	  git clone https://github.com/OsheRicko/devops-project.git
	  ```
- Change the working directory to aks-config
   ``` bash
	  cd devops-project/aks-config
	 ```
- Run terraform init command to let terraform know that you are using this dir as the working dir.

- Run terraform plan command to see the resources planed to create.

- Run terraform apply command to create these resources.

# Done
# Continue to Portal-Config!

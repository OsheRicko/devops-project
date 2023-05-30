 # AKS/Ingress config
 
 ## Task 1: Assign role to rule the cluster.

### Choose one option:
#### 1. Using the cloud shell.
   - Create a role assignment for my user (isn't working with seamless AD RBAC):
      ```bash
      az role assignment create --assignee-object-id <object_id> --role "Azure Kubernetes Service RBAC Cluster Admin" --scope /subscriptions/<subscription_id>/resourcegroups/<rg_name>/providers/Microsoft.ContainerService/managedClusters/<aks_name>
      ```

   - Update the AKS with my account as an admin account:

      ```bash
      az aks update -g <rg_name> -n <aks_name> --aad-admin-group-object-ids <object_id>
      ```
#### 2. Using the portal.
- Click the IAM tab in the AKS we have created.

- Choose "Azure Kubernetes Service RBAC Cluster Admin" 

- Assign the role to your user and save.

 

## Task 2: Create the ingress itself.
- Search for "Kubernetes services"

- Click on "ot-app-aks" 
- Click "Connect" and click use "Cloudshell"

Note: Make sure the cloud autofill the commands, else do it manually from the connect tab we opened earlier.

- Create a namespace for the ingress

     ```bash
     kubectl create namespace ingress-nginx
     ```

 - Download the ingress type in order to let the system recognize the ingress as a "Kind":

      ```bash
      kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.1/deploy/static/provider/cloud/deploy.yaml
      ```

 - Check if the ingress is installed correctly (should see a load balancer with external IP):

      ```bash
      kubectl get svc ingress-nginx-controller -n ingress-nginx
      ```

# Done
# Continue to VM-Config!

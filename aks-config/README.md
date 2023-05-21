 # WALKTHROUGH
   -------------

 AKS CONFIGURATION FOR THE APP TO RUN ON IT.
   -------------------------------------------

   1. Create a role assignment for my user (isn't working with seamless AD RBAC):

      ```bash
      az role assignment create --assignee-object-id <object_id> --role "Azure Kubernetes Service RBAC Cluster Admin" --scope /subscriptions/<subscription_id>/resourcegroups/<rg_name>/providers/Microsoft.ContainerService/managedClusters/<aks_name>
      ```

   2. Update the AKS with my account as an admin account:

      ```bash
      az aks update -g <rg_name> -n <aks_name> --aad-admin-group-object-ids <object_id>
      ```

   3. Create a namespace for ingress:

      ```bash
      kubectl create namespace ingress-nginx
      ```

   4. Download the ingress type in order to let the system recognize the ingress as a "Kind":

      ```bash
      kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.1/deploy/static/provider/cloud/deploy.yaml
      ```

   5. Check if the ingress is installed correctly (should see a load balancer with external IP):

      ```bash
      kubectl get svc ingress-nginx-controller -n ingress-nginx
      ```

   6. Check for the ingress IP:

      ```bash
      kubectl get ingress webapp-ingress -o=jsonpath='{.status.loadBalancer.ingress[0].ip}'
      ```

   7. Keep the ingress IP, as we will use it to access the app through the browser.

	WALKTHOURGH
       -------------
AKS CONFING FOR THE APP TO RUN ON IT.
-------------------------------------

# create a role assignment for my user ( isnt working with seemles ad RBAC).
az role assignment create --assignee-object-id <object_id> --role "Azure Kubernetes Service RBAC Cluster Admin" --scope /subscriptions/<subscription_id>/resourcegroups/<rg_name>/providers/Microsoft.ContainerService/managedClusters/<aks_name>

# update the AKS with my account as an admin account.
az aks update -g <rg_name> -n <aks_name> --aad-admin-group-object-ids <object_id>

# create a namespace for ingress.
kubectl create namespace ingress-nginx

# download the ingress type in order to let the system recognize the ingress as a "Kind".
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.1/deploy/static/provider/cloud/deploy.yaml

# check if the ingress is installed correctlly (should see a load balancer with external ip)
kubectl get svc ingress-nginx-controller -n ingress-nginx

# check for the ingress ip
kubectl get ingress webapp-ingress -o=jsonpath='{.status.loadBalancer.ingress[0].ip}'

# keep the ingress ip we will use it to access the app through the browser

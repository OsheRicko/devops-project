
# Portal configuration

## Task 1: Create Service Principal

### 1.1 Azure Active Directory

- Search for "Azure Active Directory" in the left pane menu and click on "App registrations" under "Manage."

- Click on the "+" button to create a new registration.
- Enter a name for the principal, leave the default settings, and click "Register."

### 1.2 Create Client Secret

- In the left pane, click on "Certificates & secrets."

- Click on "+ New client secret" to create a new client secret with the default settings.
  - Note: Copy the generated value to a notepad as it won't be visible again. Also, make sure to copy the client, subscription, and tenant IDs for configuring the service principal in the pipeline later on.

## Task 2: Create an SQL Database

- Search for "SQL databases."

- Click on "Create."
- In the basics tab, select the server and resource group for the previously created app.
- Enter "ot-app-db" as a name for the database.
- Click on "Configure database."
- Change the service tier to "General Purpose" with "Serverless" compute tier and apply.
- Click "Next" and create a private endpoint between the database and the app subnet.
- Skip to additional settings and use existing data "Sample."
- Review the settings and create the database.

## Task 3: Create an AKS (Azure Kubernetes Service)

- Search for "Kubernetes services."

- Click on "Create" to create a Kubernetes cluster.
- In the basics tab:
  - Resource group: app-rg
  - Cluster preset configuration: Dev/Test
  - Kubernetes cluster name: [Enter a name]
  - Node size: Standard DS2 v2
  - Node count range: 1-1
- Skip to the Access tab and change authentication and authorization to "AAD and RBAC."
- Go to the Networking tab:
  - Network configuration: Azure CNI
  - Virtual network: [Your app vnet]
  - Cluster subnet: [Your app subnet]
  - Kubernetes service address range: 10.1.0.0/16
  - Kubernetes DNS service IP address: 10.1.0.10
  - Network policy: Azure
- Proceed to integrations and set up your Azure Container Registry (ACR).
- Click "Review and create" and create the AKS cluster.

## Task 4: Harden the Security in the Cloud

### 4.1 The Storage Account

- Search for "Storage accounts" --> otappsa.
- In the left pane, under "Security + networking," click on "Networking."
- Click on "Private endpoint connection" and then "+ Private endpoint."

- In the basics tab, enter "sa-2-app-pe" and click "Next."
- Choose "Blob" from the dropdown and click "Next."
- Ensure that the virtual network is the app vnet.
- Review the settings and create the private endpoint connection.
- In "Firewalls and virtual networks," change the "Public network access" to "Disabled" and save.
- Under "Containers" in "Data storage," right-click on the "appdata" container, select "Change access level" to "Private," and save.

### 4.2 The SQL Server

- Search for "SQL servers."

- Click on the SQL server you've created.
- Go to the networking tab.
- In "Public network access," select "Disable" and save.

## Task 5: Create the Client VM

- Search for "Virtual machines."

- Click on "Create."
- Basics:
  - Resource group: client rg
  - VM name: client-vm
  - Image: Windows (Windows Server 2022 Datacenter Azure Edition)
  - Size: D2s_v3
- Next, go to the Networking tab:
  - Select the client vnet/subnet.
  - NIC network security group: Advanced
  - NSG: client nsg
  - Check the box for "Delete NIC when VM is deleted."
- Review the settings and create the VM.

## Task 6: Assign the Appropriate Role to the Service Principal

- Reader: SQL Server, DB

- Contributor: Storage Account, AKS

- AcrPush: ACR

- Azure Kubernetes Service RBAC Cluster Admin: AKS

# Done
# Continue to AKS-config!

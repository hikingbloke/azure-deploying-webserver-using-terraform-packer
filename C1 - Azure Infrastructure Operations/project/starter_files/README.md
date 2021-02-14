# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, We will use Packer to create a server image, and Terraform to create a template for deploying a scalable cluster of servers—with a load balancer in Azure to manage the incoming traffic. We’ll also need to adhere to security practices and ensure that our infrastructure is secure.

### Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
1. Create an Azure policy - that ensures all indexed resources in your subscription have tags and deny deployment if they do not.
    Use below reference for guidance
    https://docs.microsoft.com/en-us/azure/governance/policy/tutorials/create-and-manage
    Azure policy overview : https://docs.microsoft.com/en-us/azure/governance/policy/overview

2. Create a resource group in Azure where Packer image will be stored.
    Using Portal - https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal
    USing Azure CLI - https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-cli

3. Create Azure Credentials
    Packer authenticates with Azure using a service principal. 
    Refer : https://docs.microsoft.com/en-us/azure/virtual-machines/linux/build-image-with-packer

    We will create service principal using Azure CLI
    `az ad sp create-for-rbac --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"`

    `Note the ouput of above command`
    {
        "client_id": "xxxx",
        "client_secret": "yyyy",
        "tenant_id": "zzzz"
    }

    Obtain subscription Id for your Azure account
    `az account show --query "{ subscription_id: id }"`

4. Create server image using Packer.
    In order to support application deployment, we'll need to create an image that different organizations can take advantage of to deploy their own apps! To do this, we'll create a packer image that anyone can use.

    You can feel free to write your own from scratch or use the server.json starter code from the Github repository.
    https://github.com/udacity/nd082-Azure-Cloud-DevOps-Starter-Code/blob/master/C1%20-%20Azure%20Infrastructure%20Operations/project/starter_files/server.json
    Refere below link for implementation as well
    https://github.com/hikingbloke/azure-deploying-webserver-using-terraform-packer/blob/master/C1%20-%20Azure%20Infrastructure%20Operations/project/starter_files/server.json

    USe Packer command to create a server 
    `packer build server.json`

5. Ensure that the resource group you specify in Packer for the image is the same image that should be specified in Terraform,

6. Our Terraform template will allow us to reliably create, update, and destroy our infrastructure. 
    To create Terraform scripts below scripts an be used a reference
    Refer: 
    - https://github.com/terraform-providers/terraform-provider-azurerm/blob/master/examples/virtual-machines/linux/basic-password/main.tf
    - https://github.com/terraform-providers/terraform-provider-azurerm/blob/master/examples/virtual-machines/linux/basic-password/variables.tf

    Terraform documentation : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

7. In order to avoid hard-coding a lot of things we use variables to make sure our code stays DRY (Don't repeat yourself).
    This allows user configuration without modifying the source code.
    We create `variables.tf` to hold all such variables that we can reuse.

    In this project following variables are configurable and should be changed for your needs.
    `prefix`: This is used to prefix for all resource names.
    `username`: username to associate with the machine.
    `password`: password to use to access the machine.
    `num_of_virtual_machines`: number of Virtual Machines.
    `location`: Azure region for all resources.
    `vm_image_id`: Image that will be used for creating the Virtual Machines.

8. With our Terraform script, below resources will be created in Azure
        1. Create Resource Group
        2. Create a Virtual network and subnet of that Virtual network
        3. Create Network Security Group. Ensure that you explicitly allow access to other VMs on that subnet and 
           deny direct access from the ineternet
        4. Create a Network Interface
        5. Create a Load Balancer. Your Load Balancer will need a backend address pool and address pool association 
           for that network interface and the load balancer.
        6. Create a Virtual machine availability set.
        7. Create Virtual machines. Use the image we deployed using Packer
        8. Create Managed disk for your machines        9. 

    Make sure to run terraform plan with the -out flag, and save the plan file with the name solution.plan.
    Command: `terraform plan -out solution.plan`

    To destroy the infrastructure created by Terraform use the below
    Command: `terraform destroy`
    
    Useful terraform commands:
    - `terraform init`: to get started.
    - `terraform plan`: to view the resources that will be created.
    - `terraform apply`: to apply your plan and deploy your infrastructure.
    - `terraform show`: to see your new infrastructure.

### Output

- Azure Policy for Tag creation
![screenshot - Azure policy Tag creation](./output_images/tag-policy-screenshot?raw=true)

- Command line output - output after executing Packer to create an image
![screenshot - packer command line](./output_images/packer_cmd_output.png?raw=true)

- Packer - output after executing Packer to create an image
![screenshot - packer azure](./output_images/packer_image_created_in_azure.png?raw=true)

- VM Image - reference path
![screenshot - image reference](./output_images/packer_image_reference.png?raw=true)

- Resource created using Terraform
![screenshot - resource using terraform](./output_images/resources-created-using-terraform.png?raw=true)
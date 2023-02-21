Terraform is a tool that helps to provision infrastructure through code.
You will define a template using hashicorp language which will provision all the infrastructure. terraform is idempotent i.e. it only provisions infrastructure if needed.

## Basic Steps

You will create a file ending with `.tf` and define all the resources. When you run that file using terraform, terraform compares the resources you have defined and the resources you already have. If a resource doesnot exist yet, terraform will create it. If a resource is updated, terraform destroys the existing resource and creates a new resource from the updated configuration. If a resource exists in the infrastructure but doesnot exist in the configuration file, terraform will delete it.

## Providers

Terraform has a concept of `provider`. A provider is a module that acts as a abstraction to underlying services. Commands

Example: there is a provider called `aws`. When you use this provider, you can communicate with aws and perform actions such ass creating a instance, S3 bucket etc. Under the hood, this provider talks with aws api.

A `provider` has multiple `resources`. Each `resource` has multiple `parameters`. In case of `aws` provider, `ec2 instance` , `s3`, `eks` etc can be resources. Each resource will then have patameters to configure the behaviour of resources. In case of ec2 instance resource, paramters might be image id, volume size, permissions file etc.

These providers can be official (maintained by terraform) or community maintained.

## Working with Terraform

In order to work with terraform, you will define a configuration file that ends with `.tf`. You will then define all your resources inside the file. As discussed above, a resource is part of provider.

If you define ec2 resource using aws provider, terraform first needs to download aws provider in order to understand what does e2 resource means and how to deal with it.

Once terraform downloads the provider, it will use the provider to understand the resources defined in the resource defination template. It will then provision the resources in idempotent fashion.

## Init

In order to use terraform, the first thing you should do is to perform a command `terraform init`. This command will do following things:

- create a directory called `.terraform`
- create a file called `.terraform.lock.hcl`

`.terraform` directory will contain all the `providers` defined in the configuration file. The above command will download all the providers and keep it in the .terraform directory.

`.terraform.lock.hcl` will store the hash of all the providers.

## plan

In order to see the changes terraform perform, we can use `terraform plan` command. This command will show all the effects terraform will perform when we run the resource defination file. It does so by comaring resource defination file to the `terraform.tfstate` metadata file.

When you first run the resource defination file, a file called `terraform.tfstate` is created. The file stores all the information about the current infrastructure provisioned through terrraform. Next time when we changes the resource and run the resource defination file again, terraform will compare the resource defination file with the metadata in terraform.tfstate file.

This way terraform knows :

- Resource definations that are newly added in the file
- Resource definations that are deleted from the file
- Resource definations that are updated.

This allows terraform to create new infrstaructure resources, delete existing infrastructure resources and replace a existing infrastructure with a updated one.

This file only exist after you have created infrastrucutre atleast once.

## apply

You can use `terraform apply` command to apply the changes from the resource defination file to the infrastructure.

```shell
	resource "local_file" "pet_defination" {
		filename: "./pet_info.txt"
		content: "this file contains information about a pet."
	}
```

This is a resource that uses a provider called `local`. The resource used is `file`. This resource has a lot of `properties` that can be used to cofigure its behaviour. The compulsory properties are `filename` and `content`.

# Infrastructure

## Intro
We use **Terraform** to provision our infrastructure. As we are adopting this technology, we'll be migrating pieces of our current infrastructure into this solution.

## Useful links

You will find the [Terraform docs](https://www.terraform.io/docs/index.html) very useful too.

Terraform basic commands can be found at the bottom of this ReadMe

# TODO
- Use parameters to populate last hardcoded value in environments (implies: tf state mv)
- Create guide for adding new resources
- Create import resource guide
- Create and store topology diagram
- Fail build on errors
- Explore exporting plan to artifact
- Azure locks

# Solution
This solution contains three folders: 
- **Modules** - Contains reusable templates to create resources from topics to storage accounts.
- **Blueprints** - Use these to combine modules to define wider plans/blueprints for infrastructure. These can be shared across environments to easily reproduce infrastructre.
- **Environments** - Define the `path to live` with system specific variables which are then used to call blueprints or modules (for environemnt specific resources)

# Usage
- init
- explain how the tfstate file works
- explain blueprint and why we used them vs modules repeated in env files/folders
- you can still call individual modules for specific changes
- import exisitng resources
- adding new resources
- pipeline
- go script

# Terraform basics
The easiest way to start using **Terraform** is by installing it with choco using this command:
```
choco install terraform
```
Navigate to your desired environment in the project to setup your local terraform solution. This will pull the latest tfstate from the bakend storage to ensure your enviornment is up to date
```
terraform init
```
Build an execution plan to compare any changes you make to the current infrasture. 
```
terraform plan
```
Build and deploy infrastructure as outlined in the plan:
```
terraform apply
```
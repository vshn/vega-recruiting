# tf-recruiting-task

## Prerequisites

* `terraform` installed

## Instructions

1. Fix the existing terraform code so you can successfully run `terraform test -var-file="variables/$(terraform workspace show).tfvars" -verbose`
    1. Save a diff of your changes
    2. Save the terraform plan from the output
2. Format the existing terraform code in the standard style
    1. Save a diff of your changes
    2. Write down the command(s) you used
3. Enhance module "vpc" so the MTU of the VPC is configurable through a variable
    1. Ensure the default value is `1460`
    2. Set the variable so the MTU of the created VPC is set to `1500`
    3. Save a diff of your changes
    4. Save the terraform plan
4. Present your changes
    1. Explain the changes you made in the first task and why they were necessary
    2. Show the terraform plan and explain what resources are being created
    3. Explain what you did in the second task
    4. Explain the changes you made in the third task
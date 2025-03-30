# Terraform Remote Backend Example

This repository demonstrates how to configure a remote backend in Terraform using an S3 bucket for state file storage. By using a remote backend, you can ensure that your Terraform state file is securely stored, shared across teams, and is not lost if your local machine is wiped or inaccessible.

## Prerequisites

Before using this configuration, make sure you have the following:

- An AWS account with appropriate permissions to create resources such as S3 buckets and EC2 instances.
- Terraform installed (version 1.0 or later).
- AWS CLI configured with valid credentials for your AWS account.

## Architecture

The example consists of:

- An S3 bucket (`dhanikaa-remote-backend`) used to store Terraform's state file.
- An EC2 instance resource (`remote_backend_example`) provisioned using Terraform.
  
The configuration is designed to store the Terraform state in an S3 bucket, ensuring remote state management, and also creating an EC2 instance as part of the Terraform deployment.

## How to Use

### 1. Configure your AWS Provider
In `main.tf`, you configure the AWS provider and set the region for resource creation.

```hcl
provider "aws" {
  region = "eu-north-1"
}
```

### 2. Define Resources

In the same file, you’ll define an EC2 instance resource, which will be provisioned when you apply the Terraform configuration.

```hcl
resource "aws_instance" "remote_backend_example" {
  ami           = "ami-02db68a01488594c5"
  instance_type = "t3.micro"
  tags = {
    Name = "remote-backend-example"
  }
}
```

### 3. Configure Remote Backend

The remote backend is configured in `backend.tf`. This configuration will instruct Terraform to store the state file in an S3 bucket (`dhanikaa-remote-backend`) and to use the `eu-north-1` region.

```hcl
terraform {
  backend "s3" {
    bucket = "dhanikaa-remote-backend"
    region = "eu-north-1"
    key     = "terraform.tfstate"
  }
}
```

### 4. Initialize the Configuration

Run the following command to initialize the configuration. This will download the required provider plugins and initialize the backend.

```sh
terraform init
```

### 5. Apply the Configuration

To apply the Terraform configuration and provision the resources, use the following command:

```sh
terraform apply
```

Terraform will prompt you to confirm the action. Type `yes` to proceed with provisioning the EC2 instance.

### 6. Verify the State

Once the resources are provisioned, you can check the S3 bucket (`dhanikaa-remote-backend`) to verify that the state file (`terraform.tfstate`) is stored there.

## Why Use a Remote Backend?

1. **State Management**: Storing Terraform’s state file remotely helps in centralizing state management and sharing state among team members working on the same project.
2. **Locking and Consistency**: When you use S3 as a backend with DynamoDB for state locking, it helps in preventing concurrent changes to the state file, reducing the chances of conflicts.
3. **Security**: Using an S3 bucket ensures that the state file is stored in a secure and scalable location in AWS, and you can apply fine-grained access controls using IAM policies.

## Terraform State File

The state file is stored in the specified S3 bucket (`dhanikaa-remote-backend`), and it keeps track of the resources created and managed by Terraform. The `terraform.tfstate` file will be automatically updated and stored in the remote backend.

## Clean Up

To delete the resources created by Terraform, you can run:

```sh
terraform destroy
```

This will tear down the EC2 instance and any other resources you may have created.

## Additional Information

- For more information on using remote backends with Terraform, see the official Terraform documentation.
- If you wish to use a different backend or make changes to the configuration, you can modify the `backend.tf` file accordingly.

---

**Note:** Be cautious with the state file. If the file contains sensitive information, make sure you configure the S3 bucket with appropriate access controls and encryption.
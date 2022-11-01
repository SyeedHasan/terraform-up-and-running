provider "aws" {
    region = "us-east-1"
}

# Though the default backend,
#   Changing backends require explciit redefinition
#   Or perhaps reconfiguring while `init` using `terraform init -reconfigure`
# terraform {
#     backend "local" {
#         path = "/Users/syedhassanakhtar/Learning/Terraform/terraform-up-and-running-code/Code/remote-backends/terraform.tfstate"
#     }
# }

# Setting up remote backends
# terraform {
#     backend "s3" {
#         # Specify the backend configuration variables here
#         # OR,
#         # Read them from a configuration while during the init command
#         #   terraform init -backend-config=backend-config.hcl 
#         key = "defaultworkspace/terraform.tfstate"
#     }
# }

resource "aws_s3_bucket" "backendBucket" {
    bucket = "abuckettostoretheterraformstatein"
    lifecycle {
        prevent_destroy = true
    }
}

resource "aws_s3_bucket_versioning" "versioning" {

    bucket = aws_s3_bucket.backendBucket.id
    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.backendBucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
    bucket                  = aws_s3_bucket.backendBucket.id
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

resource "aws_dynamodb_table" "lockingDynamoTable" {
    name = "LockingTableforTerraform"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
      name = "LockID"
      type = "S"
    }
}

resource "aws_instance" "sampleEc2" {
    ami = "ami-09d3b3274b6c5d4aa"
    instance_type = terraform.workspace == "default" ? "t2.micro" : "t3a.medium"
}

output "bucket_arn" {
    value = aws_s3_bucket.backendBucket.arn
}

output "dynamo_table_arn" {
    value = aws_dynamodb_table.lockingDynamoTable.arn
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-alvaronl"
    key            = "lambda-api-gw/terraform.tfstate"
    region         = "eu-south-2"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-south-2"
}

##Template to file creations
# Define the template file and generate the JavaScript file
data "template_file" "js_template" {
  template = file("templates/api.js.tmpl")
  vars = {
    api_invoke_url = module.api_gateway.api_full
  }
}

resource "local_file" "script_js" {
  content  = data.template_file.js_template.rendered
  filename = "../html/api.js"
}

#Define .py
data "template_file" "py_template" {
  template = file("templates/lambda_function.py.tmpl")
  vars = {
    s3bucket_url = module.s3site-create.bucket_url
  }
}

resource "local_file" "script_py" {
  content  = data.template_file.py_template.rendered
  filename = "../lambda_function.py"
}


## MODULES

module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = "VisitCounter-lambda-test"
  main_key   = "visitor_id"
  tags       = { Environment = "test" }
}
module "s3site-create" {
  source = "./modules/storage-create"

  html_path = "../html/"
  bucket_name = "basiccountertest9324"
}

output "bucket_url" {
  description = "The public URL of the S3 bucket"
  value       = module.s3site-create.bucket_url
}

module "lambda" {
  source             = "./modules/lambda"
  lambda_name        = "visit_counter_lambda"
  runtime            = "python3.13"
  handler            = "lambda_function.lambda_handler"
  filename           = "../lambda_function.zip"
  role_name          = "lambda_exec_role"
  policy_name        = "DynamoDB_AccessPolicy"
  dynamodb_table_arn = module.dynamodb.table_arn
  environment_variables = {
    TABLE_NAME = module.dynamodb.table_name
  }
  
  depends_on = [local_file.script_py]
}

module "api_gateway" {
  source     = "./modules/api_gateway"
  api_name   = "visit-counter-api"
  path_part  = "visit"
  lambda_arn = module.lambda.lambda_arn
  stage_name = "default"
}

module "s3site-upload" {
  source = "./modules/storage-upload"
  upload_bucket_id = module.s3site-create.bucket_id
  html_path = "../html/"

  script_js_name = "api.js"
  script_jscontent = data.template_file.js_template.rendered
}

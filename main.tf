provider "aws" {
  region = "ap-southeast-2"
}

module "ecs" {
  source = "./ecs"

}


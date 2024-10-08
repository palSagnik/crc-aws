# Cloud Resume

This is my iteration of Forrest Brazeal's cloud resume challenge.
This project really tested my knowledge of AWS Services and integrating them. The manual point and click form was ready within a day. Infrastructure as code was the real challenge.

This is built using AWS as well as Terraform for Infrastructure as Code. This repo can also be used with any type of nextjs project, I have plans to make this into a template repository.      

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

* Clone the repository and move into the frontend directory

  ```
  git clone https://github.com/palSagnik/crc-aws.git
  ```
  ```
  cd frontend/
  ```

* Install all the dependencies using yarn

  ```
  yarn install
  ```

 * If you dont have terraform install it after reading the instructions below

   [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Setting up Terraform with AWS



* Set up a hosted-zone using a domain bought from a Domain Registrar like (Namecheap, Hostinger) and replace their nameservers with the ones in Route 53. Then create a certificate for the same records.

  In a `config.tf` file, write down the details which must not be made public.
  ```
  terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  }
  
  provider "aws" {
    region = "us-east-1"
  }
  
  locals {
    s3_bucket_name      = "some unique name"
    domain              = "domain you bought"
    hosted_zone_id      = "ID of the Route53 hosted zone"
    cert_arn            = "arn:aws:acm:XXXXXXXXXXXXXXXX"
    cloudfront_oac_name = "some name"
  }
  ```

And you are good to go.


## Development and Deployment

* Run a development server in `frontend/` and make changes as you like.
  ```
  yarn dev
  ```
* After that run `./init.sh` and your ci/cd pipeline would start. If everything works out, voila now you have your own cloud resume.
* If there is any changes to the infrastructure, just run `terraform apply` to the new file and terraform would handle it.


## Built With

* [Terraform](https://www.terraform.io/) - Infrastructure As Code
* [NextJS](https://nextjs.org/) - FrontEnd
* [AWS](https://aws.amazon.com/) - Cloud Provider

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Bartosz Jarocki - I suck at frontend, I used his template and made my own changes to it.

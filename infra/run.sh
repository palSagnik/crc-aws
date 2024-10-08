#!/bin/bash

terraform fmt
terraform init
terraform validate
terraform apply
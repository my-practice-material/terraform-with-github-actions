# Terraform AWS VPC Module

This module creates a **custom VPC** in AWS with the following subnet layout across two Availability Zones:

- **2 Application Subnets** (private)
- **2 Database Subnets** (private)
- **2 Public Subnets** (for ALBs / Ingress) 

It also creates the **required VPC Endpoints for EKS**, enabling secure private connectivity to AWS services.
  - `com.amazonaws.<region>.ecr.api`
  - `com.amazonaws.<region>.ecr.dkr`
  - `com.amazonaws.<region>.logs`
  - `com.amazonaws.<region>.sts`
  - `com.amazonaws.<region>.ec2`
  - `com.amazonaws.<region>.s3`
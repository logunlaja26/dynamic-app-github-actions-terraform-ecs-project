# Dynamic Web App Deployment on AWS using CI/CD Pipelines with GitHub Actions

This project showcases a fully automated deployment pipeline for a dynamic web application hosted on AWS, using Terraform, Docker, Amazon ECS Fargate, and GitHub Actions. The infrastructure is built and managed via CI/CD workflows triggered on code changes, enabling scalable and efficient deployment processes with infrastructure-as-code principles.

## Technologies Used

- AWS (VPC, ECS Fargate, RDS, ECR, S3, IAM)
- Terraform
- Docker
- Flyway
- GitHub Actions (CI/CD)
- Ubuntu Self-Hosted EC2 Runner

## Project Architecture & Workflow Overview

- GitHub Actions pipelines automate both infrastructure provisioning and application deployment.
- Uses a self-hosted EC2 GitHub runner to interact securely with AWS private subnets (e.g., RDS).
- Application is containerized and deployed to ECS Fargate with images stored in Amazon ECR.

## CI/CD Pipeline Highlights

- IAM Credential Setup  
  Configured AWS IAM credentials in GitHub Actions to authorize CI/CD workflows and validate secure AWS access.

- Infrastructure Provisioning with Terraform  
  A pipeline job uses Terraform and a self-hosted Ubuntu runner to create:

  - VPC
  - Public and private subnets
  - Internet gateway
  - Security groups

- Amazon ECR Repository Creation  
  Created and configured an ECR repository to store Docker images of the web application.

- Docker Build & Push  
  A job on the self-hosted runner:

  - Builds the Docker image
  - Pushes the image to ECR

- Flyway Database Migration  
  Utilized Flyway to apply SQL schema migrations directly to the Amazon RDS instance in the private subnet, executed from the self-hosted runner (since GitHub-hosted runners can't access private subnets).

- Store Build Variables in S3  
  Docker build arguments are saved to a file, which is then uploaded to an S3 bucket. ECS containers later reference this file for runtime configuration.

- ECS Task Definition Update  
  Updates the ECS task definition with the new Docker image. Registers the new revision and deploys it to ECS Fargate.

- ECS Service Restart  
  Restarts the ECS service and forces the use of the updated task definition to ensure the new version of the app is live.

- Self-Hosted Runner Termination  
  Automatically shuts down the EC2 runner instance after jobs complete to minimize cost and maintain stateless execution.

## Architecture Diagram

GitHub Actions ──────────┐
▼
[Self-Hosted Runner EC2]
│
┌──────────────────┼───────────────────────────┐
▼ ▼ ▼
[Terraform: VPC, Subnet, SG] [Docker Build & Push to ECR] [Flyway → RDS]
│
▼
[ECS Fargate + Task Definition Update]
│
▼
[App Live with DB + Image Config]

## Key Benefits

- Complete infrastructure automation via Terraform
- Secure pipeline using self-hosted runners in a private subnet
- Zero-downtime deployment through ECS service updates
- Versioned and traceable CI/CD using GitHub Actions
- Environment-specific runtime config managed through S3

Project Deployment Workflow – README
====================================

This project uses Terraform, Jenkins, Docker, GitHub, and AWS EKS to fully automate the application deployment process. Below is a simple explanation of how everything works.

1. Infrastructure Setup (Terraform)
   ================================

Terraform is used to create all the AWS resources needed for this project:

VPC (network for all services)

IAM roles and permissions

EC2 instance for Jenkins

EKS Kubernetes cluster

Terraform automatically provisions the entire environment so everything is ready for deployment.

2. Developer Pushes Code to GitHub
   ===============================

Developers write code and push their changes to the GitHub repository.
This is the starting point of the CI/CD process.

3. GitHub Webhook Triggers Jenkins
   ===============================

A GitHub webhook is configured to notify Jenkins every time a commit or push happens.

Jenkins receives the webhook

Jenkins automatically starts the pipeline

This gives a fully automated build and deployment system.

4. Jenkins Builds and Pushes Docker Image
   ======================================
Inside the Jenkins pipeline:

Jenkins pulls the latest code

Builds a Docker image

Tags it with the commit ID and “latest”

Pushes the image to DockerHub

This ensures every version is stored and can be re-deployed anytime.

5. Jenkins Deploys to AWS EKS
  ===========================
After the Docker image is ready:

Jenkins connects to the EKS cluster using kubectl

Updates the deployment.yaml with the new image

Applies deployment and service files

Kubernetes creates or updates the pods running the application

This gives automated deployment into the Kubernetes cluster.

6. Monitoring the Application & Cluster
   ====================================
Monitoring tools like Prometheus and Grafana are used to check:

EKS cluster health

Node health

Pod status

CPU, memory, and network usage


Application performance

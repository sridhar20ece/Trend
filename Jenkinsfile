pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = 'dockerhub-creds'
        AWS_CREDENTIALS = 'aws-creds'        // If your Jenkins uses IAM role, remove this
        IMAGE_NAME = "sipserver/my-custom-nginx"
        AWS_REGION = "ap-south-1"
        EKS_CLUSTER = "my-eks-cluster"
        K8S_NAMESPACE = "default"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "Pulling code from GitHub..."
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    COMMIT_ID = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    IMAGE_TAG = "${COMMIT_ID}"
                }
                sh """
                    echo "Building Docker image..."
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
                """
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}",
                    usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh "echo \$PASSWORD | docker login -u \$USERNAME --password-stdin"
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                sh """
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    docker push ${IMAGE_NAME}:latest
                """
            }
        }

        stage('Configure kubectl for EKS') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                                      credentialsId: "${AWS_CREDENTIALS}"]]) {

                        sh """
                            aws eks update-kubeconfig --region ${AWS_REGION} --name ${EKS_CLUSTER}
                        """
                    }
                }
            }
        }

        stage('Update Deployment YAML Image') {
            steps {
                sh """
                    echo "Updating deployment.yaml with new image tag..."
                    sed -i 's|image: .*|image: ${IMAGE_NAME}:${IMAGE_TAG}|g' k8s/deployment.yaml
                """
            }
        }

        stage('Deploy to AWS EKS') {
            steps {
                sh """
                    echo "Applying deployment and service..."
                    kubectl apply -f k8s/deployment.yaml -n ${K8S_NAMESPACE}
                    kubectl apply -f k8s/service.yaml -n ${K8S_NAMESPACE}

                    echo "Checking rollout status..."
                    kubectl rollout status deployment/my-nginx-deployment -n ${K8S_NAMESPACE}
                """
            }
        }
    }

    post {
        always {
            sh "docker logout"
            echo "Pipeline completed."
        }
    }
}

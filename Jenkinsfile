pipeline {
    environment {
        registry = "ptsantar/udacity_cloud_devops_capstone"
        registryCredential = 'dockerhub'
        dockerImage = ''
        containerId = ''
    }

    agent any

    stages {
        stage('Linting') {
            steps {
                echo 'Lint Dockerfile'
                sh 'hadolint Dockerfile'
                echo 'Lint HTML files'
                sh 'tidy -q -e my_site/*.html'
            }
        }
    
    
        stage('Building Docker Image') {
            steps{
                script {
                    dockerImage = docker.build registry + ":latest"
                }
            }
        }

        stage('Push Docker Image') {
            steps{
                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Deploy Docker Container') {
            steps {
                sh 'docker run --name udacitycapstone -d -p 3080:80 ' + registry + ":latest"
            }
        }

        stage('Stop and Remove Docker Image') {
            steps{
                sh 'docker stop \$(docker ps -a | grep ' + registry + ":latest | cut -d \' \' -f 1)"
                sh 'docker rm \$(docker ps -a | grep ' + registry + ":latest | cut -d \' \' -f 1)"
                sh "docker rmi $registry:latest"
            }
        }

        stage('Deploy to AWS EKS Cluster'){
            steps{
                dir('aws_files') {
                    withAWS(region:'us-west-2', credentials:'udacity1') {
                        sh 'aws --region us-west-2 eks update-kubeconfig --name mycluster'
                        sh 'kubectl apply -f controller.json'
                        sh 'kubectl get pods'
                        input "Ready to deploy the loadbalancer?"
                        sh 'kubectl apply -f service.json'
                        sh 'kubectl get services'
                    }
                }
            }
        }
    }

}
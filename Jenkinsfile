pipeline {
    environment {
        registry = "ptsantar/udacity_cloud_devops_capstone"
        registryCredential = 'dockerhub'
        dockerImage = ''
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
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
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
                sh 'docker run --name udacity_capstone -d -p 8080:80 ' + dockerImage
            }
        }
    }

}
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
                sh 'docker run --name udacitycapstone -d -p 3080:80 ' + registry + ":$BUILD_NUMBER"
            }
        }

        stage('Stop and Remove Docker Image') {
            steps{
                containerId = sh(returnStdout: true, script: 'cont_id=docker ps -a | grep \"" + registry + ":$BUILD_NUMBER\" | cut -d \' \' -f 1').trim()
                sh "docker stop " + containerId
                sh "docker rm " + containerId
                sh "docker rmi $registry:$BUILD_NUMBER"
            }
        }
    }

}
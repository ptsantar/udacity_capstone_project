pipeline {
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

  }
}
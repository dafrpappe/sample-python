pipeline {
  agent {
    docker { image 'node:16-alpine' }
    label 'docker-agent'
  }
  stages {
    stage('Test') {
      steps {
        sh 'node --version'
      }
    }
  }
}
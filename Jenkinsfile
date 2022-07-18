pipeline {
  agent {
    any { image 'node:16-alpine' 
    }

  }
  stages {
    stage('Test') {
      steps {
        sh 'node --version'
      }
    }
  }
}
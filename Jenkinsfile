pipeline {
  agent {
    docker { image 'node:16-alpine' 
             label 'myDocker'
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
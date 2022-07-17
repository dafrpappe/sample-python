pipeline {
    agent {
        docker { image '3.10.0-alpine' }
    }
    stages {
        stage('Test') {
            steps {
                sh 'python --version'
            }
        }
    }
}
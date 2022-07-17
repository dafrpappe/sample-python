pipeline {
    agent any 
    stages {
        stage('Initialize'){
               def dockerHome = tool 'alpinePythonDocker'
               env.PATH = "${dockerHome}/bin:${env.PATH}"
           }           
        stage('Build') {
            agent {
                docker {
                    image '3.10.0-alpine'
                    // Run the container on the node specified at the
                    // top-level of the Pipeline, in the same workspace,
                    // rather than on a new node entirely:
                    reuseNode true
                }
            }
            steps {
                sh 'python --version'
            }
        }
    }
}

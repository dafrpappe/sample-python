pipeline{
    agent {
        docker {
            image 'python:alpine'
            args '-u root'
            label 'docker1'
        }
    }
    stages{
        stage('Prepare environment'){
            steps{
                sh 'apk add git'
            }
        }
        stage('Clone code from Git repository and setup python env'){
            steps{
                sh 'https://github.com/dafrpappe/sampleapp.git'

            }
        }
        stage('test code'){
            steps{
                sh 'python sampleapp/helloWorld.py'
            }
        }
    }
    post{
        always{
            echo "Job execution complete."
        }
        success{
            archiveArtifacts artifacts : '*.jpg'
        }
        unsuccessful{
            echo "Job execution status is failed, please check error logs"
        }
        cleanup{
                echo 'Cleaning up environment'
                sh 'rm -rf sampleapp *.jpg'
        }
    }
}
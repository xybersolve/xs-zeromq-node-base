pipeline {
    agent any
    stages {
        stage('Pre-Clean') {
            steps {
                cleanWs()
                sh 'make clean || true'
            }
        }

        stage('Checkout') {
            steps {
              checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'make build'
            }
        }

        stage('Test') {
            steps {
                sh 'echo "Run Tests"'
            }
        }

        stage('Tag') {
            steps {
                sh 'make tag'
            }
        }

        stage('DockerHub Push') {
          steps {
            // Jenkins withCredentials and make
            withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
              sh "make login user=${env.dockerHubUser} pass=${env.dockerHubPassword}"
              sh 'make push'
            }
          }
        }

        stage('Info') {
            steps {
                echo "JOB_NAME: ${env.JOB_NAME}"
                echo "BUILD_ID: ${env.BUILD_ID}"
                echo "BUILD_NAME: ${env.BUILD_NAME}"
                echo "BUILD_TAG: ${env.BUILD_TAG}"
                echo "BUILD_NUMBER: ${env.BUILD_NUMBER}"
                echo "BUILD_URL: ${env.BUILD_URL}"
                echo "JOB_URL: ${env.JOB_URL}"
                echo "WORKSPACE: ${env.WORKSPACE}"
                echo "JENKINS_URL: ${env.JENKINS_URL}"
                echo "JENKINS_HOME: ${env.JENKINS_HOME}"
                echo "NODE_NAME: ${env.NODE_NAME}"
            }
        }
    }
    post {
      always {
      echo 'Build ran'
    }
    success {
      echo 'Build was successful'
      /*
        mail to: 'xybersolve@gmail.com',
             subject: "Successful Pipeline: ${currentBuild.fullDisplayName}",
             body: "Pipeline executed with ${env.BUILD_URL}"
      */
    }
    failure {
      echo 'Build failed to run'
    }
    unstable {
      echo 'Build was unstable'
    }
    changed {
      echo 'Something changed from the last build'
    }
  }
}

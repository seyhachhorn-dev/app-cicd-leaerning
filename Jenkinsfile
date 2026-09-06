pipeline {
    // Jenkins can run this pipeline on any available executor
    agent any

    stages {

        stage('Checkout') {
            steps {
                // Download the source code from GitHub
                checkout scm
            }
        }

        stage('Build') {
            steps {
                // Build the JAR file and skip tests for now
                sh './mvnw clean package -DskipTests'

                // Show the generated JAR
                sh 'ls -lh target/'
            }
        }

        stage('Test') {
            steps {
                sh './mvnw test'
            }
        }

  stage('Dependency Check') {
              steps {
                  // withCredentials securely injects the secret into an environment variable
                  withCredentials([string(credentialsId: 'nvd-api-key', variable: 'NVD_API_KEY')]) {
                      // We use $NVD_API_KEY to pass it to the Maven plugin
                      sh './mvnw dependency-check:check -DnvdApiKey=$NVD_API_KEY'
                  }
              }
          }
    }
}
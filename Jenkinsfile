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
                // Check dependencies for known CVEs
                sh './mvnw dependency-check:check'
            }
        }
    }
}
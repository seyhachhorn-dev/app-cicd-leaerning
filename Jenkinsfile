pipeline {
    // 'agent any' means Jenkins can run this on any available executor.
    agent any

    stages {
        // A stage is a logical block of work (like Checkout, Build, Test)
        stage('Checkout') {
            steps {
                // 'checkout scm' tells Jenkins to download the code from GitHub
                checkout scm
            }
        }

             stage('Build') {
                    steps {
                    // 'sh' tells Jenkins to run a Linux shell command
                   // This builds the .jar file but skips testing for now

                        sh './mvnw clean package -DskipTests'

                        // Let's print the contents of the target folder so you can see the JAR!
                         sh 'ls -lh target/'
                    }
                }
        stage('Test') {

        steps {
        sh './mvnw test'
        }
        }
    }
}
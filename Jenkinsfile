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
    }
}
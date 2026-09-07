pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh './mvnw clean package -DskipTests'
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
                withCredentials([
                    string(
                        credentialsId: 'nvd-api-key',
                        variable: 'NVD_API_KEY'
                    )
                ]) {
                    sh '''
                        ./mvnw dependency-check:check \
                            -DnvdApiKey="$NVD_API_KEY" \
                            -DnvdApiDelay=16000
                    '''
                }

        stage('SonarQube Analysis & Quality Gate') {
                    steps {
                        withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                            // We pass the token, project key, and SonarQube URL
                            // The 'qualitygate.wait=true' flag tells Jenkins to wait and fail if the code is bad
                            sh '''
                                ./mvnw sonar:sonar \
                                -Dsonar.projectKey=cicd-demo \
                                -Dsonar.host.url=http://localhost:9002 \
                                -Dsonar.token=$SONAR_TOKEN \
                                -Dsonar.qualitygate.wait=true
                            '''
                        }
                    }
                }
            }
        }
    }
}
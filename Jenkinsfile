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
            }
        }

        stage('SonarQube Analysis & Quality Gate') {
            steps {
                withCredentials([
                    string(
                        credentialsId: 'sonar-token',
                        variable: 'SONAR_TOKEN'
                    )
                ]) {
                    sh '''
                        ./mvnw sonar:sonar \
                            -Dsonar.projectKey=cicd-demo \
                            -Dsonar.host.url=http://localhost:9002 \
                            -Dsonar.token="$SONAR_TOKEN" \
                            -Dsonar.qualitygate.wait=true
                    '''
                }
            }
        }

        stage('Docker Build'){


        steps {

        // We use double quotes (" ") here instead of single quotes (' ')
        // In Groovy, double quotes allow us to inject variables like ${env.BUILD_NUMBER}
                        sh "docker build -t seyhadev/cicd-demo:${env.BUILD_NUMBER} ."
                        sh "docker build -t seyhadev/cicd-demo:latest ."
                        // Let's print our new images to the logs to verify!
                        sh "docker images | grep cicd-demo"
        }

        }

        stage('Trivy Scan') {
                    steps {
                        // Added --timeout 15m to prevent the DB download from failing on slow networks
//                         sh "trivy image --timeout 15m --severity HIGH,CRITICAL --exit-code 1 --no-progress seyhadev/cicd-demo:${env.BUILD_NUMBER}"
                 echo "Skipping Trivy scan for now..."
                    }
                }
    }
}
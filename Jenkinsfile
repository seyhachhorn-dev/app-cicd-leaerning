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

        stage('Docker Build') {
            steps {

                // Build versioned image
                sh "docker build -t seyhadev/cicd-demo:${env.BUILD_NUMBER} ."

                // Build latest image
                sh "docker build -t seyhadev/cicd-demo:latest ."

                // Print images
                sh "docker images | grep cicd-demo"
            }
        }

        stage('Trivy Scan') {
            steps {

                // Temporarily skipping Trivy
                // sh "trivy image --timeout 15m --severity HIGH,CRITICAL --exit-code 1 --no-progress seyhadev/cicd-demo:${env.BUILD_NUMBER}"

                echo "Skipping Trivy scan for now..."
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker-hub-creds',
                        passwordVariable: 'DOCKER_PASS',
                        usernameVariable: 'DOCKER_USER'
                    )
                ]) {

                    // Login to Docker Hub
                    sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"

                    // Push version
                    sh "docker push seyhadev/cicd-demo:${env.BUILD_NUMBER}"

                    // Push latest
                    sh "docker push seyhadev/cicd-demo:latest"
                }
            }
        }

        stage('Deploy') {
            steps {

                // Pull latest image
                sh "docker pull seyhadev/cicd-demo:latest"

                // Stop old container
                sh "docker stop my-live-app || true"

                // Remove old container
                sh "docker rm my-live-app || true"

                // Run new container
                sh "docker run -d -p 9090:9090 --name my-live-app seyhadev/cicd-demo:latest"
            }
        }

    } // <-- stages ends HERE


    // post belongs to pipeline, NOT stages
    post {

        success {
            echo '✅ Pipeline succeeded! The new Spring Boot version is live.'
            // slackSend(message: "Deployment successful!")
        }

        failure {
            echo '❌ Pipeline failed! Check the logs above to find the error.'
            // emailext(subject: "Build Failed", to: "dev-team@company.com")
        }

    }

} // <-- pipeline ends HERE
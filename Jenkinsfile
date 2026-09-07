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

                    // 1. Log in to Docker Hub securely
                    // We use echo and --password-stdin because it is a DevOps best practice.
                    // It hides the password from the Linux process history.
                    sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"

                    // 2. Push the versioned tag
                    sh "docker push seyhadev/cicd-demo:${env.BUILD_NUMBER}"

                    // 3. Push the latest tag
                    sh "docker push seyhadev/cicd-demo:latest"
                }
            }
        }

        stage('Deploy') {
            steps {

                // 1. Pull the latest image
                sh "docker pull seyhadev/cicd-demo:latest"

                // 2. Stop and remove the old container
                // We use '|| true' at the end. This is a Linux trick!
                // It means: "Try to stop the container, but if it doesn't exist yet, don't fail the pipeline, just keep going."
                sh "docker stop my-live-app || true"
                sh "docker rm my-live-app || true"

                // 3. Run the new container in the background
                sh "docker run -d -p 9090:9090 --name my-live-app seyhadev/cicd-demo:latest"
            }
        }
    }
}
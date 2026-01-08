// Declarative Jenkins Pipeline for CI/CD of Django + React application
pipeline {

    // Run this pipeline on any available Jenkins agent
    agent any

    // Global environment variables used across all stages
    environment {
        // Docker Hub username where the image will be pushed
        DOCKERHUB_USERNAME = "mrsharma151"

        // Docker image name for the application
        IMAGE_NAME = "django-react-notes-app"

        // Image tag (using 'latest' for learning; versioning can be added later)
        IMAGE_TAG = "latest"

        // Full Docker image name (username/image:tag)
        DOCKER_IMAGE = "${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
    }

    stages {

        // --------------------------------------------------------
        // Stage 1: Clone source code from GitHub repository
        // --------------------------------------------------------
        stage('Clone Repository') {
            steps {
                echo "Cloning GitHub repository"
                // Checkout code from the branch configured in Jenkins job
                checkout scm
            }
        }

        // --------------------------------------------------------
        // Stage 2: Build Docker image using Dockerfile
        // --------------------------------------------------------
        stage('Build Docker Image') {
            steps {
                echo "Building Docker image from Dockerfile"
                sh '''
                  docker build -t $DOCKER_IMAGE .
                '''
            }
        }

        // --------------------------------------------------------
        // Stage 3: Authenticate with Docker Hub using Jenkins credentials
        // --------------------------------------------------------
        stage('Docker Hub Login') {
            steps {
                echo "Logging in to Docker Hub securely using Jenkins credentials"
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                      echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                    '''
                }
            }
        }

        // --------------------------------------------------------
        // Stage 4: Push the built Docker image to Docker Hub
        // --------------------------------------------------------
        stage('Push Image to Docker Hub') {
            steps {
                echo "Pushing Docker image to Docker Hub"
                sh '''
                  docker push $DOCKER_IMAGE
                '''
            }
        }

        // --------------------------------------------------------
        // Stage 5: Deploy application using Docker Compose
        // --------------------------------------------------------
        stage('Deploy using Docker Compose') {
            steps {
                echo "Deploying application using Docker Compose"
                sh '''
                  docker-compose down
                  docker-compose pull
                  docker-compose up -d
                '''
            }
        }

        // --------------------------------------------------------
        // Stage 6: Verify running containers after deployment
        // --------------------------------------------------------
        stage('Verify Deployment') {
            steps {
                echo "Verifying running Docker containers"
                sh 'docker ps'
            }
        }
    }

    // ------------------------------------------------------------
    // Post-build actions (executed based on pipeline result)
    // ------------------------------------------------------------
    post {

        // Always clean up unused Docker images to save disk space
        always {
            echo "Cleaning up unused Docker images"
            sh 'docker image prune -f'
        }

        // Executed when pipeline succeeds
        success {
            echo "CI/CD Pipeline executed successfully 🚀"
        }

        // Executed when pipeline fails
        failure {
            echo "CI/CD Pipeline failed ❌"
        }
    }
}

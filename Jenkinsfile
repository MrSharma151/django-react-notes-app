pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = "mrsharma151"
        IMAGE_NAME = "django-react-notes-app"
        IMAGE_TAG = "latest"
        DOCKER_IMAGE = "${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
    }

    stages {

        stage('Clone Repository') {
            steps {
                echo "Cloning GitHub repository"
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                  docker build -t $DOCKER_IMAGE .
                '''
            }
        }

        stage('Docker Hub Login') {
            steps {
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

        stage('Push Image to Docker Hub') {
            steps {
                sh '''
                  docker push $DOCKER_IMAGE
                '''
            }
        }

        stage('Deploy using Docker Compose') {
            steps {
                sh '''
                  docker-compose down
                  docker-compose pull
                  docker-compose up -d
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh 'docker ps'
            }
        }
    }

    post {
        always {
            echo "Cleaning up unused Docker images"
            sh 'docker image prune -f'
        }
        success {
            echo "CI/CD Pipeline executed successfully 🚀"
        }
        failure {
            echo "CI/CD Pipeline failed ❌"
        }
    }
}

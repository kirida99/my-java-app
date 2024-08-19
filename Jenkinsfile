pipeline {
    agent any
    environment {
        DOCKER_REGISTRY = 'your.docker.registry.com'
        IMAGE_NAME = 'my-java-app'
        IMAGE_TAG = 'latest'
        KUBE_CONTEXT = 'kubernetes-context-name'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'git-credentials', url: 'https://github.com/yourusername/my-java-app.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    def imageTag = "${env.DOCKER_REGISTRY}/${env.IMAGE_NAME}:${env.IMAGE_TAG}"
                    sh "docker build -t ${imageTag} ."
                    sh "docker login -u \$DOCKER_USERNAME -p \$DOCKER_PASSWORD \$DOCKER_REGISTRY"
                    sh "docker push ${imageTag}"
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                withKubeContext(context: env.KUBE_CONTEXT) {
                    sh "kubectl apply -f deployment.yaml"
                    sh "kubectl apply -f service.yaml"
                }
            }
        }
    }
}

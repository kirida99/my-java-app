pipeline {
    agent any
    environment {
        DOCKER_REGISTRY = 'harbor.ocp-prod.example.com'
        IMAGE_NAME = 'my-java-app'
        IMAGE_TAG = 'latest'
        KUBE_CONTEXT = '100-pipeline-jenkins/api-ocp-prod-example-com:6443/system:admin'
        HARBOR_CREDENTIALS_ID = 'harbor-credentials-id' // 使用你在 Jenkins 中创建的凭证 ID
        GIT_CREDENTIALS_ID = 'git-credentials-id' // 使用你在 Jenkins 中创建的 Git 凭证 ID
    }
    stages {
        stage('Checkout') {
            steps {
                withCredentials([usernamePassword(credentialsId: env.GIT_CREDENTIALS_ID, usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')]) {
                    git branch: 'master', credentialsId: env.GIT_CREDENTIALS_ID, url: 'https://github.com/kirida99/my-java-app.git'
                }
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
                    withCredentials([usernamePassword(credentialsId: env.HARBOR_CREDENTIALS_ID, usernameVariable: 'HARBOR_USERNAME', passwordVariable: 'HARBOR_PASSWORD')]) {
                        sh "docker login -u \$HARBOR_USERNAME -p \$HARBOR_PASSWORD \$DOCKER_REGISTRY"
                        sh "docker push ${imageTag}"
                    }
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

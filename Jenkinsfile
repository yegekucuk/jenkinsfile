pipeline {
    agent any

    environment {
        GIT_CREDENTIALS_ID = 'github-credentials'
        DOCKER_CREDENTIALS_ID = 'docker-credentials'
        DOCKER_IMAGE = 'yegekucuk2/yegejava'
        SSH_CREDENTIALS_ID = 'debian10'
        SSH_TARGET = 'debian2@10.0.2.4'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', 
                    url: 'https://github.com/yegekucuk/jenkinsfile.git',
                    credentialsId: "${GIT_CREDENTIALS_ID}"
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    def buildId = env.BUILD_ID
                    dockerImage = docker.build("${DOCKER_IMAGE}:${buildId}")
                }
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    def buildId = env.BUILD_ID
                    docker.withRegistry('', "${DOCKER_CREDENTIALS_ID}") {
                        dockerImage.push(buildId)
                    }
                }
            }
        }

        stage('Deploy to Remote Machine') {
		steps {
                sshagent(credentials: [SSH_CREDENTIALS_ID]) {
                    sh """
                        ssh ${SSH_TARGET} '
                            docker pull ${DOCKER_IMAGE}:${env.BUILD_ID} &&
                            docker run --name my-container ${DOCKER_IMAGE}:${env.BUILD_ID} || docker rm -f my-container && docker run --name my-container ${DOCKER_IMAGE}:${env.BUILD_ID}
                        '
                    """
                }
            }
        }
    }
}

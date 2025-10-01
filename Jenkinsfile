pipeline {
    agent any

    environment {
        EC2_USER = "ec2-user"
        EC2_IP = "3.145.147.27"
        APP_DIR = "/var/www/presentation"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'git@github.com:sarthak078/presentation.git'
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['033f1540-20ad-4fb8-80b3-275e8fa2bbe0']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_IP} '
                        cd ${APP_DIR} || exit 1
                        git reset --hard HEAD
                        git pull origin main
                        chmod +x deploy.sh
                        ./deploy.sh
                    '
                    """
                }
            }
        }
    }
}

pipeline {
    agent any

    environment {
        EC2_USER = "ec2-user"
        EC2_IP = "3.145.147.27"
        APP_DIR = "/var/www/presentation"
        GIT_REPO = "https://github.com/sarthak078/presentation.git"
    }

    stages {
        stage('Deploy to EC2') {
            steps {
                sshagent(['033f1540-20ad-4fb8-80b3-275e8fa2bbe0']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_IP} '
                        # Create directory if needed
                        sudo mkdir -p ${APP_DIR}
                        sudo chown -R $(whoami):$(whoami) ${APP_DIR}
                        
                        cd ${APP_DIR}
                        
                        # Clone or pull
                        if [ ! -d .git ]; then
                            git clone ${GIT_REPO} .
                        else
                            git reset --hard HEAD
                            git pull origin main
                        fi
                        
                        # Run deployment
                        chmod +x deploy.sh
                        ./deploy.sh
                    '
                    '''
                }
            }
        }
    }
}
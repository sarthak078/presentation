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
                    ssh -o StrictHostKeyChecking=no ec2-user@3.145.147.27 << 'ENDSSH'
                        # Create directory if needed
                        sudo mkdir -p /var/www/presentation
                        sudo chown -R $(whoami):$(whoami) /var/www/presentation
                        
                        cd /var/www/presentation
                        
                        # Clone or pull
                        if [ ! -d .git ]; then
                            echo "Cloning repository..."
                            git clone https://github.com/sarthak078/presentation.git .
                        else
                            echo "Updating repository..."
                            git reset --hard HEAD
                            git pull origin main
                        fi
                        
                        # Run deployment
                        chmod +x deploy.sh
                        ./deploy.sh
ENDSSH
                    '''
                }
            }
        }
    }
}
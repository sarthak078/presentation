pipeline {
    agent any

    environment {
        EC2_USER = "ec2-user"
        EC2_IP = "3.145.147.27" // replace with your EC2 public IP
    }

    stages {
        stage('Deploy to EC2') {
            steps {
                sshagent(['033f1540-20ad-4fb8-80b3-275e8fa2bbe0']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_IP} '
                        bash -s' < deploy.sh
                    """
                }
            }
        }
    }
}

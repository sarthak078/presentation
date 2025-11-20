pipeline {
    agent any

    environment {
        EC2_USER = "ec2-user"
        EC2_IP = "3.95.66.4" // replace with your EC2 public IP
    }

    stages {
        stage('Deploy to EC2') {
            steps {
                sshagent(['3eab426f-5c36-405a-b494-259c1964c912']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${EC2_USER}@${EC2_IP} '
                        bash -s' < deploy.sh
                    """
                }
            }
        }
    }
}

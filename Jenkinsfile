pipeline {
    agent {
        label 'jenkins-line'
    }
    stages {
        stage('Build Artifact') {
            steps {
                sh 'mvn clean package -Dmaven.test.skip'
            }
        }
        stage('Docker-Build') {
            steps {
                sh 'docker build -t gooseline .'
                sh "docker tag gooseline eodgeorge/gooselive:v5"
                sh 'docker stop myapp'
                sh 'docker rm myapp'
            }
        }
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-id', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    sh 'docker push eodgeorge/gooselive:v4'
                }
            }
        }
        stage('Trigger Playbooks on Ansible') {
            steps {
                sshagent (['ssh-key']) {
                    sh 'ssh ubuntu@18.171.211.88 -o strictHostKeyChecking=no "ansible-playbook webserver.yaml"'
                }
            }
        }
    }                   
}

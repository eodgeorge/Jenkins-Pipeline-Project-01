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
            }
        }
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-id', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    sh 'docker push eodgeorge/gooselive:v5'
                }
            }
        }
        stage('Trigger Playbooks on Ansible') {
            steps {
                sshagent (['ssh-key']) {
                      sh 'ssh ubuntu@35.178.37.153 -o strictHostKeyChecking=no "sudo /etc/ansible/discovery.sh"' 
                  }
              }
        }
    }                   
}

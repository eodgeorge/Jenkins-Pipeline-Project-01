pipeline {
    agent {
        label 'jenkins-line'
    }
    stages {
        stage('Code Checkout') {
            steps {
                git branch: 'main', 
                credentialsId: 'github', 
                url: 'https://github.com/eodgeorge/Jenkins-Pipeline-Project-01.git'
            }
        }
        stage("Quality Gate") {
            steps {
              timeout(time: 2, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: true
              }
            }
        }
        stage('Build Artifact') {
            steps {
                sh 'mvn clean package -Dmaven.test.skip'
            }
        }
        stage('Docker-Build') {
            steps {
                sh 'docker build -t gooseline .'
                sh "docker tag gooseline eodgeorge/gooselive:v1"
            }
        }
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-id', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    sh 'docker push eodgeorge/gooselive:v1'
                }
            }
        }
        stage('Trigger Playbooks on Ansible') {
            steps {
                sshagent (['ssh-key']) {
                      sh 'ssh ubuntu@3.8.171.5 -o strictHostKeyChecking=no "ansible-playbook webserver.yaml"'
                  }
              }
        }
    }                   
}

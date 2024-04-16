pipeline {
    agent {
        label 'jenkins-line'
    }
    stages {
        stage('Code Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                sh "mvn sonar:sonar -Dsonar.java.binaries=target/classes"
                }
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
                sh "docker tag gooseline eodgeorge/gooselive:v4"
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
                      sh 'ssh ubuntu@35.178.37.153 -o strictHostKeyChecking=no "sudo /etc/ansible/discovery.sh"' 
                  }
              }
        }
    }                   
}

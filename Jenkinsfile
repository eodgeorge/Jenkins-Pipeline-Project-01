pipeline {
    agent agent_IP

    stages {
        stage('checkout') {
            steps {
                script {
                    git branch: 'feature/eod', 
                        url: 'https://eodgeorge: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@github.com/eodgeorge/Jenkins-Pipeline-Project-01.git'
                }
            }
        }
        stage('$buildArtifact-Code Analysis') {
            steps {
                // Run code analysis using SonarQube
                script {
                    withSonarQubeEnv('sonar') {
                        sh '''
                            mvn clean package verify sonar-scanner \
                            -Dsonar.projectKey=sonar \
                            -Dsonar.sources=src/main/java \
                            -Dsonar.java.binaries=target/classes,target/test-classes \
                            -Dsonar.host.url=${SONAR_HOST_URL} \
                            -Dsonar.login=${SONAR_LOGIN}
                        '''
                    }
                }
            }
        }
        stage("Quality Gate") {
            steps {
                // Wait for the quality gate to pass
                script {
                    timeout(time: 2, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
        }

        stage('Docker-Build') {
            environment {
                // DOCKER_IMAGE = "eodgeorge/gooselive:${BUILD_NUMBER}-${GIT_COMMIT.substring(0, 7)}" // Versioning with BUILD_NUMBER and short commit SHA
                DOCKER_IMAGE = "eodgeorge/gooselive:${BUILD_NUMBER}"
            }            
            steps {
                script {
                    echo "Building Docker image: ${DOCKER_IMAGE}"
                    try {
                        sh 'docker build -t ${DOCKER_IMAGE} .'
                    } catch (Exception e) {
                        echo "Error during Docker build: ${e.message}"
                        currentBuild.result = 'FAILURE'
                        error "Aborting build due to Docker build failure"
                    }
                }
            }
        }

        stage('Trivy Security Scan') {
            steps {
                script {
                    // "Scanning Docker image for vulnerabilities..."
                    def dockerImageTag = '${DOCKER_IMAGE}'
                    def scanOutput = sh(script: "sudo trivy image --severity HIGH,CRITICAL '${dockerImageTag}'", returnStdout: true).trim()
                    echo scanOutput
                    if (scanOutput.contains('CRITICAL') || scanOutput.contains('HIGH')) {
                        error "Vulnerabilities found, failing build"
                    }
                }
            }
        }           

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-id', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    sh 'docker push ${DOCKER_IMAGE}'
                }
            }
        }
        
        stage('Update Deployment repository') {
            environment {
                GIT_REPO_NAME = "terraform-script-nfs-pv-pvc-dev"
                GIT_USER_NAME = "eodgeorge"
                GIT_EMAIL = "eodinvsltd@gmail.com"
                GITHUB_URL = "https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME}"
            }
            steps {
                withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
                    sh '''
                        git config --global user.email "${GIT_EMAIL}"
                        git config --global user.name "${GIT_USER_NAME}"                        
                        BUILD_NUMBER=${BUILD_NUMBER}
                        sed -i "s/image_tag/${BUILD_NUMBER}/g" ansible/playbooks/webserver.yml
                        git add ansible/playbooks/webserver.yml
                        git commit -m "Update image_deployment version ${BUILD_NUMBER}"
                        git push ${GITHUB_URL} HEAD:feature/eod
                    '''
                }
            }
        }
    }
    post {
        {echo "Pipeline finished. Current build status: ${currentBuild.result}"}
        success {echo "Pipeline success"}
        failure {echo "Pipeline failed"}
    }
}
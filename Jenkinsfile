pipeline {
    agent any

    tools {
        maven 'maven'
    }

    options {
        skipDefaultCheckout true
    }

    // START OF THE STAGES
    stages {

        stage('Cleaning Workspace') {
            steps{
                cleanWs() // jenkins inbuilt function to clean the workspace
            }
        }


        stage('Checkout') {
            steps {
                git credentialsId: 'git', branch: main , poll: false, url: 'https://github.com/aditya-tanwar/boardgame.git'
                sh 'mkdir Test-Results'
            }
        }



        stage('Trivy Filesystem Scan') {
            steps {
                sh 'ls && pwd'
                sh 'trivy fs --format table -o fs-trivy-report.html .'
            }
        }



        stage('compile') {
            steps {
                sh 'mvn compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test -DskipTests=true'
            }
        }

        // stage('SonarQube Code Analysis') {
        //     environment {
        //         scannerHome = tool 'sonar'
        //     }
        //     steps {
        //         scritp {
        //             withSonarQubeEnv('sonar') {
        //                 sh '''
        //                     ${scannerHome}/bin/sonar-scanner \
        //                     -Dsonar.projectKey=boardgame \
        //                     -Ssonar.projectName=boardgame \
        //                     -Dsonar.java.binaries=.
        //                 '''
        //             }
        //         }

        //     }

        // }


        // stage('Quality Gate'){
        //     steps {
        //         waitForQualityGate abortPipeline: false, credentialsId: 'sonarqube'
        //     }
        // }


        stage('OWASP Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'owasp'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
               }
        }


        stage('Docker Build') {
            steps {
                sh 'docker build -t boardgame:v1 .'
            }
        }

        stage('Scanning Docker image') {
            steps {
                sh 'trivy image --scanners vuln,misconfig,secret boardgame:v1 --format json -o Test-Results/trivy-image-results.json'
                sh 'dockle -f json boardgame:v1 > Test-Results/dockle-image-results.json'
            }
        }


        stage('Docker Push') {
            steps {
                sh 'docker tag boardgame:v1 aditya-tanwar/boardgame:v1'
                sh 'docker push aditya-tanwar/boardgame:v1'
            }
        }


    } // END OF  THE STAGES
    
}
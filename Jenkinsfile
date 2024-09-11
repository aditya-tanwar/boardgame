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
                git branch: 'main', credentialsId: 'github-token', poll: false, url: 'https://github.com/aditya-tanwar/boardgame.git'
            }
        }



        stage('Trivy Filesystem Scan') {
            steps {
                sh 'ls && pwd && mkdir Test-Results'
                sh 'trivy fs --format json -o Test-Results/fs-trivy-report.json .'
            }
        }


        stage('Maven Validation & Compilation') {
            steps {
                sh "mvn validate" //-------- validate the project is correct and all necessary information is available 
                sh "mvn clean compile -DskipTests=true" //------ compiles the source code of the project ,  -DskipTests=true compiles the tests but doesn't runs them
            }
        } // End of Maven Compilation stage
        
        stage('Maven Unit Testing') { // This is a good practice , helps in early issue detection
            steps {
                sh "mvn clean test" // testing the compiled code 
            }
        } // End of Maven Unit Testing stage


        stage('Maven Build & Verification') { 
            steps {
                //sh "cd Petclinic-main && mvn clean package -DskipTests=true" // build the maven project and create JAR & WAR file.
                sh "mvn clean verify" // This is considered a good practice ( validate > complile > test > package > verify )
            }
        } // End of the Maven Build & Verification stage



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
                sh 'trivy image --scanners vuln,misconfig,secret boardgame:v1 --format json -o Test-Results/trivy-image-scan-results.json'
                sh 'dockle -f json boardgame:v1 > Test-Results/dockle-image-scan-results.json'
            }
        }


        stage('Docker Push') {
            steps {
                sh 'docker tag boardgame:v1 adityatanwar03/boardgame:v1'
                sh 'docker push adityatanwar03/boardgame:v1'
            }
        }


    } // END OF  THE STAGES
    
}

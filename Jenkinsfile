pipeline {
    
    agent any

    tools {
       maven "Maven3"
       jdk "OracleJDK8"
    }

    stages {
         stage('git checkout') {
              steps {
                  checkout([$class: 'GitSCM', branches: [[name: '*/vp-rem']], extensions: [], userRemoteConfigs: [[credentialsId: 'GitHub', url: 'https://github.com/amitmeshram12/vprofile-project.git']]])
              }

           }
          stage('Build') {
               steps {
                   sh 'mvn install -DskipTests' 
               }
               
               post {
                   success {
                       echo 'Now Archiving it....'
                       archiveArtifacts artifacts: '**/target/*.war'
                   }
               }             
     
            }
            stage('Unit Test') {
                 steps {
                     sh 'mvn test'
                 }
            }
            stage('Integration Test') {
                 steps {
                     sh 'mvn checkstyle:checkstyle'
                    }
                post {
                    success {
                          echo 'Generated Analysis Result' 
                    }   
                }
            }
          stage('CODE ANALYSIS with SONARQUBE') {

                environment {
                    scannerHome = tool 'Sonar-Srv'
                
            }
            steps {
            withSonarQubeEnv('Sonar-SRV') {
               sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
                   -Dsonar.projectName=vprofile \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                   -Dsonar.junit.reportsPath=target/surefire-reports/ \
                   -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                   -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml'''
                    }
             timeout(time: 10, unit: 'MINUTES') {
               waitForQualityGate abortPipeline: true
               
                }    
            }
        }   
    }
}
    
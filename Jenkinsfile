pipeline {
    agent any

	tools {
		maven 'Maven3.6'
		jdk 'JDK1/8'
	}
//
//	environment {
//		M2_INSTALL = "/home/gamut/Distros/apache-maven-3.6.0/bin/mvn"
//	}

    
    stages {
		stage('Clone-Repo') {
			steps {
				//checkout scm
				//git 'https://github.com/devendrakumar1007/TestJenkinsProject.git'
				git 'https://github.com/devendrakumar1007/jenkins_test.git'
			}
		}
		stage('Build') {
	    	steps {
				sh 'mvn install -DskipTests'
			}
	    }
		stage('Unit Tests') {
			steps {
				sh 'mvn surefire:test'
			}
		}
		stage('Deployment') {
	    	steps {
				print "Deployment is done!"
				sh 'sshpass -p "gamut" scp target/gamutkart.war gamut@172.17.0.3:/home/gamut/apache-tomcat-7.0.104/webapps/'
				//sh 'sshpass -p "gamut" ssh -o StrictHostKeyChecking=no gamut@172.17.0.3 "JAVA_HOME=/usr/bin/java" "/home/gamut/apache-tomcat-7.0.104/bin/startup.sh"'	
				sh 'sshpass -p "gamut" ssh  gamut@172.17.0.3 "JAVA_HOME=/usr/bin/java" "/home/gamut/apache-tomcat-7.0.104/bin/startup.sh"'	


	    	}
		}
		stage('sonar analysis'){
			steps{
			
			withSonarQubeEnv(installationName: 'sonar',credentialsId: 'e6eb3b85-7f7c-457c-a27e-c7b8020255f1') {
            sh 'mvn sonar:sonar'
}
			
			}
		
		}
		
		
		
		stage('publish HTML REPORT'){
			steps{	
			sh 'mvn clean verify'
publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'target/site/jacoco/', reportFiles: 'index.html', reportName: 'ProjectReport', reportTitles: ''])			
			}
		
		}
		
		stage('publish JUNIT REPORTT'){
			steps{	
                   junit 'target/surefire-reports/*.xml'				
			}
		
		}
	
		
    }

	post {
		success {
			notify("succes")
		}
		failure {
		notify("failure")
				}
	}

}

	def notify(status){
    emailext (
      to: "you@gmail.com",
      subject: "${status}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
      body: """<p>${status}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
        <p>Check console output at <a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a></p>""",
    )
}

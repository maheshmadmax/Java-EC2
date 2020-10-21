node {
	//stage("Install TerraForm if absent") {
		// If ~/terraform doesn't exist, download and unzip it
	//	sh("if [ -f ~/terraform ]; then echo 'TerraForm is already installed.'; exit 0; fi; echo 'installing TerraForm...'; wget https://releases.hashicorp.com/terraform/0.13.4/terraform_0.13.4_linux_amd64.zip -P /tmp; unzip /tmp/terraform_0.13.4_linux_amd64.zip -d ~; rm /tmp/terraform_0.13.4_linux_amd64.zip")
	//}

	stage("Retrieve code and vars") {
		// Clones git repo containing the code
		git url: 'https://github.com/maheshmadmax/Java-EC2.git'
	}

	stage("Create EC2 instance with TerraForm") {
		// Creates EC2 T2.micro instance with Tomcat installed on it
		sh("~/terraform init; ~/terraform apply -input=false -auto-approve")
		env.public_ip = sh(returnStdout: true, script: "~/terraform output public_ip").trim()
	}

	//stage("Deploy to Tomcat remotely") {
		// Enable remote access and add user to Tomcat
	//	sh("./setup_tomcat.sh ${env.public_ip}")
		// Load Tomcat user credentials to env vars
	//	load "/home/tomcat/.tomcat_creds.groovy"
		// Deploy sample.war to Tomcat
	//	sh("curl -v -u ${env.tomcat_user}:${env.tomcat_passwd} -T sample.war 'http://${env.public_ip}/manager/text/deploy?path=/hello-world&update=true'")
//	}

	stage("Clean up with TerraForm") {
		// Destroys the earlier created EC2 T2.micro instance
		sh("~/terraform destroy -input=false -auto-approve")
	}
}

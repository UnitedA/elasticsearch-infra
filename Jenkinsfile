pipeline {
    agent any
    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Select action: apply or destroy')
    }
    environment {
        TERRAFORM_WORKSPACE = "/var/lib/jenkins/workspace/tool_deploy/pipeline-infra/"
        INSTALL_WORKSPACE = "/var/lib/jenkins/workspace/tool_deploy/elasticsearch/"
        TERRAFORM_BIN = "/var/lib/jenkins/bin/terraform"  // Explicit path to Terraform binary
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/UnitedA/elasticsearch-infra.git'
            }
        }
        stage('Terraform Init') {
            steps {
                // Initialize Terraform
                sh "cd ${env.TERRAFORM_WORKSPACE} && ${env.TERRAFORM_BIN} init"
            }
        }
        stage('Terraform Plan') {
            steps {
                // Run Terraform plan
                sh "cd ${env.TERRAFORM_WORKSPACE} && ${env.TERRAFORM_BIN} plan"
            }
        }
        stage('Approval For Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                // Prompt for approval before applying changes
                input "Do you want to apply Terraform changes?"
            }
        }
        stage('Terraform Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                // Run Terraform apply
                sh """
                cd ${env.TERRAFORM_WORKSPACE}
                ${env.TERRAFORM_BIN} apply -auto-approve
                mkdir -p ${env.INSTALL_WORKSPACE} 
                sudo cp ${env.TERRAFORM_WORKSPACE}/all_key.pem ${env.INSTALL_WORKSPACE}/
                sudo chown jenkins:jenkins ${env.INSTALL_WORKSPACE}/all_key.pem
                sudo chmod 400 ${env.INSTALL_WORKSPACE}/all_key.pem
                """
            }
        }
        stage('Approval for Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                // Prompt for approval before destroying resources
                input "Do you want to Terraform Destroy?"
            }
        }
        stage('Terraform Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                // Destroy Infra
                sh "cd ${env.TERRAFORM_WORKSPACE} && ${env.TERRAFORM_BIN} destroy -auto-approve"
            }
        }
    }
    post {
        success {
            echo 'Succeeded!'
        }
        failure {
            echo 'Failed!'
        }
    }
}

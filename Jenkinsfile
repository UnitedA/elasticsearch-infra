pipeline {
    agent any
    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Select action: apply or destroy')
    }
    environment {
        TERRAFORM_WORKSPACE = "/var/lib/jenkins/workspace/tool_deploy/pipeline-infra/"
        INSTALL_WORKSPACE = "/var/lib/jenkins/workspace/tool_deploy/elasticsearch/"
        TERRAFORM_BIN = "/usr/local/bin/terraform"  // Explicit path to Terraform binary
    }
    stages {
        stage('Clone Repository') {
            steps {
                echo 'Cloning repository...'
                git branch: 'main', url: 'https://github.com/UnitedA/elasticsearch-infra.git'
            }
        }
        stage('Check Terraform') {
            steps {
                script {
                    if (!fileExists("${env.TERRAFORM_BIN}")) {
                        error "Terraform binary not found at ${env.TERRAFORM_BIN}"
                    }
                }
            }
        }
        stage('Terraform Init') {
            steps {
                echo 'Initializing Terraform...'
                script {
                    def result = sh(script: "cd ${env.TERRAFORM_WORKSPACE} && ${env.TERRAFORM_BIN} init", returnStatus: true)
                    if (result != 0) {
                        error "Terraform Init failed with status: ${result}"
                    }
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                echo 'Running Terraform plan...'
                script {
                    def result = sh(script: "cd ${env.TERRAFORM_WORKSPACE} && ${env.TERRAFORM_BIN} plan", returnStatus: true)
                    if (result != 0) {
                        error "Terraform Plan failed with status: ${result}"
                    }
                }
            }
        }
        stage('Approval For Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                input "Do you want to apply Terraform changes?"
            }
        }
        stage('Terraform Apply') {
            when {
                expression { params.ACTION == 'apply' }
            }
            steps {
                echo 'Applying Terraform changes...'
                script {
                    def result = sh(script: """
                        cd ${env.TERRAFORM_WORKSPACE}
                        ${env.TERRAFORM_BIN} apply -auto-approve
                        mkdir -p ${env.INSTALL_WORKSPACE} 
                        sudo cp ${env.TERRAFORM_WORKSPACE}/all_key.pem ${env.INSTALL_WORKSPACE}/
                        sudo chown jenkins:jenkins ${env.INSTALL_WORKSPACE}/all_key.pem
                        sudo chmod 400 ${env.INSTALL_WORKSPACE}/all_key.pem
                    """, returnStatus: true)
                    if (result != 0) {
                        error "Terraform Apply failed with status: ${result}"
                    }
                }
            }
        }
        stage('Approval for Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                input "Do you want to Terraform Destroy?"
            }
        }
        stage('Terraform Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                echo 'Destroying infrastructure...'
                script {
                    def result = sh(script: "cd ${env.TERRAFORM_WORKSPACE} && ${env.TERRAFORM_BIN} destroy -auto-approve", returnStatus: true)
                    if (result != 0) {
                        error "Terraform Destroy failed with status: ${result}"
                    }
                }
            }
        }
    }
    post {
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}

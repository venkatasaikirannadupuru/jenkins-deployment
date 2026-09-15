pipeline {

    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        FUNCTION_NAME = 'employee-management-lambda'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Test') {
            steps {
                sh 'python3 -m py_compile lambda_function.py'
            }
        }

        stage('Package Lambda') {
            steps {
                sh 'rm -f lambda_function.zip'
                sh 'zip lambda_function.zip lambda_function.py'
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Verify Lambda') {
            steps {
                sh '''
                    aws lambda get-function \
                    --function-name $FUNCTION_NAME \
                    --region $AWS_REGION \
                    --query 'Configuration.[FunctionName,Runtime,Handler]' \
                    --output table
                '''
            }
        }
    }

    post {
        success {
            echo 'Employee Management Lambda deployment successful!'
        }

        failure {
            echo 'Lambda deployment failed. Check Jenkins console output.'
        }
    }
}
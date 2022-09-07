//To spinup EKS_cluster in AWS, we write up the stages with the steps in pipeline method:-
  
 pipeline{
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('jenkins-aws-access-key-id')
        AWS_SECRET_ACCESS_KEY_ID = credentials('jenkins-aws-secret-access-key-id')
    }
    stages{
        stage('CHECKING AWS CREDS'){
            steps{
                sh 'aws sts get-caller-identity'
            }
        }
        stage('TERRAFORM INIT'){
            steps{
                echo "Initializing Terraform init to download the required AWS plugins from provider registry"
                sh 'terraform init'
            }
        }
        stage('TERRAFORM FMT'){
          steps{
            echo "Fomrating the terraform code w.r.t to Hashicopr Language"
            sh 'terraform fmt'
          }
        }
        stage('TERRAFORM VALIDATE'){
          steps{
            echo "Validating the code written by an user"
            sh 'terraform fmt'
          }
        }
        stage('TERRAFORM PLAN'){
          steps{
            echo "Going to show us, what are the services will be created in AWS Cloud"
            sh 'terraform plan'
          }
        }
        stage('TERRAFORM APPLY'){
          steps{
            echo "Going to creat the services in AWS Cloud"
            sh 'terraform apply --auto-approve'
          }
        }
    }
}

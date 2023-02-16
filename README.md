# tf-aws-cloudwatch

 Created cloudwatch Dashboard  
 TO see  CPU Utilization

step.1 ->  clone the module vpc
step.2 ->  lauch ec2-instance in that VPC
step.3 ->   store the statefile in s3
step.4 ->   now configure the cloudwatch dashboard(AWS/cpu utilization)
terraform init
 terraform plan -var-file=ec2.tfvars
 terraform  apply -var-file=ec2.tfvars
 

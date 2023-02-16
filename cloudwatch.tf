module "vpc" {
  source = "git::https://github.com/SShaheeda/aws_tf_vpc.git"
  vpc_cidr = var.ec2_vpc_cidr
  igw_cidr_block = var.ec2_igw_cidr_block
  public_subnet_cidr = var.ec2_public_subnet_cidr
  private_subnet_cidr = var.ec2_private_subnet_cidr
  nat_gateway_instance_id = aws_instance.instance_nat.primary_network_interface_id

}

resource "aws_instance" "instance_public" {
  ami           = "ami-05fa00d4c63e32376"
  instance_type = "t2.micro"
  subnet_id    =  module.vpc.public_subnet_id
  key_name = "shaik"
  security_groups=[aws_security_group.mysgp.id]
  associate_public_ip_address=true
 lifecycle {
    ignore_changes = [
      disable_api_termination,ebs_optimized,hibernation,security_groups,
      credit_specification,network_interface,ephemeral_block_device]
  }

  tags = {
    Name = "publicEC2"
  }
}
resource "aws_instance" "instance_nat" {
  ami           = "ami-05fa00d4c63e32376"
  instance_type = "t2.micro"
  subnet_id    =  module.vpc.public_subnet_id
  key_name = "shaik"
  security_groups=[aws_security_group.mysgp_nat.id]
  associate_public_ip_address=true
  source_dest_check = false
  lifecycle {
    ignore_changes = [
      disable_api_termination,ebs_optimized,hibernation,security_groups,
      credit_specification,network_interface,ephemeral_block_device]
  }

  tags = {
    Name = "NATEC2"
  }
}
resource "aws_cloudwatch_dashboard" "cw_main" {
  dashboard_name = "ec2_dashboard"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/EC2",
            "CPUUtilization",
            "InstanceId",
            "$(var.aws_instance.instance_public.id)"
          ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "us-east-1",
        "title": "EC2 Instance CPU"
      }
    },
    {
      "type": "text",
      "x": 0,
      "y": 7,
      "width": 3,
      "height": 3,
      "properties": {
        "markdown": "Hello world"
      }
    }
  ]
}
EOF
}

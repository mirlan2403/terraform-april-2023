resource "aws_instance" "jenkins_ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.allow_tls.id]
  subnet_id                   = aws_subnet.group4_public1.id
  
  tags = {
    Name = "Jenkins20"
  }

  user_data = <<-EOF
    #!/bin/bash
    yum update -y 
    wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
    rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    yum upgrade
    dnf install java-11-amazon-corretto -y
    yum install jenkins -y
    systemctl enable jenkins
    systemctl start jenkins
    EOF
}

resource "aws_key_pair" "deployer" {
  key_name   = var.key_pair
  public_key = file("~/.ssh/id_rsa.pub")
}
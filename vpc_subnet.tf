#create vpc

resource "aws_vpc" "web_vpc" {
  cidr_block =  var.var_vpc_cidr #"10.0.0.0/16" fetching from terraform cloud
  tags = {
    Name = "web_vpc"
  }
}
# 2. Create internet gateway
resource "aws_internet_gateway" "web_gw" {
  vpc_id = aws_vpc.web_vpc.id
  tags = {
    Name = "main"
  }
}
# 3.creating subnet
resource "aws_subnet" "web_subnet" {
  vpc_id     = aws_vpc.web_vpc.id
  cidr_block = var.var_subnet_cidr #"10.0.1.0/24"
  availability_zone = var.var_available_zone #"us-west-2a"

  tags = {
    Name = "web_subnet"
  }
#4.creatingroute table
resource "aws_route_table" "web_route_table" {
  vpc_id = aws_vpc.web_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web_gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.web_gw.id
  }

  tags = {
    Name = "web_route_table"
  }
}
# 5.creating route table association
resource "aws_route_table_association" "web_subnet_association" {
  subnet_id      = aws_subnet.web_subnet.id
  route_table_id = aws_route_table.web_route_table.id
}

# 6. create security group to allow port 22, 80, 443  
resource "aws_security_group" "web_allow_http_ssh" {
  name        = "allow_web_ssh"
  description = "Allow wen and ssh inbound traffic"
  vpc_id      = aws_vpc.web_vpc.id

  ingress {
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "ssh from VPC"
    from_port        = 20
    to_port          = 20
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web_ssh"
  }
}  
  

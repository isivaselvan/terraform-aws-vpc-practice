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


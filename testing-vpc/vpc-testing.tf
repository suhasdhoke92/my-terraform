provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "mysubnet1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "mysubnet2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
}


resource "aws_internet_gateway" "myig" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "myroute" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myig.id
  }
}

resource "aws_route_table_association" "myroute-as1" {
  subnet_id      = aws_subnet.mysubnet1.id
  route_table_id = aws_route_table.myroute.id
}

resource "aws_route_table_association" "myroute-as2" {
  subnet_id      = aws_subnet.mysubnet2.id
  route_table_id = aws_route_table.myroute.id
}
#for secrutiy group 
resource "aws_security_group" "my-sg" {
  name        = "my-sg"
  description = "for 80 port only"
  vpc_id      = aws_vpc.myvpc.id

  tags = {
    Name = "my-sg1"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.my-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.my-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.my-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
# ec2 instance 

resource "aws_instance" "my-ec2-1" {
    ami = "ami-03f4878755434977f"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.mysubnet1.id
    vpc_security_group_ids = [aws_security_group.my-sg.id]
    user_data = base64encode(file("userdata.sh"))
}

resource "aws_instance" "my-ec2-2" {
    ami = "ami-03f4878755434977f"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.mysubnet2.id
    vpc_security_group_ids = [aws_security_group.my-sg.id]
    user_data = base64encode(file("userdata.sh"))
}

  ## load balancing is pending

resource "aws_s3_bucket" "my-s3" {
  bucket = "suhasdhoke1234567890123"
}

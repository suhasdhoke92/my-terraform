1 provider aws {
	region= ap-south-1
}

2 resoure aws_vpn {
cidr
}

3 resrouce aws_sbunet {
vpc id 
avaibility zone
CIDR
map_public_ip = true
}

subnet 2 {
}

4 resource aws_internet_gw {
 vpc_id = 
}

5 resource aws_route_table {
 vpc_id =
	
route {	
	CIDR_block = 0/0
	gateway_id = 
	}
}

6 aws_route_table_association {
- we will mention , which need to defin as public
	subnet_id =
	route_table_id
}

aws_route_table_association
subnet association for anather subnet.

======================================== 
7 

security group for subnet
{
name_prefix = web
	ingress {
	}
	egress {
	}
}

8 S3 buckets{
	bucket name =

}

9 aws_instance EC2 {
	ami 
	instance type
	subnet id = 
	security_group =
	user_data = bash64encode[file]
}
 



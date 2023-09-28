resource "aws_vpc" "main" {
  for_each         = var.vpcs
  cidr_block       = each.value["cidr"]
  instance_tenancy = each.value["tenancy"]
  tags             = each.value["tags"]
}

# output "test" {
#   value = aws_vpc.main
# }
# locals {
#   test = aws_vpc.main
# }
resource "aws_internet_gateway" "igw" {
  for_each = var.IGWs1
  # vpc_id   = local.test
  vpc_id = aws_vpc.main[each.key].id
  tags = {
    Name = each.value.tags.Name
  }
}

# subnets creation
# data "aws_availability_zones" "available_zones" {}

resource "aws_subnet" "vpc_subnets" {
  for_each = var.subnets
  vpc_id = aws_vpc.main[each.key].id
  cidr_block       = each.value["cidr"]
  availability_zone = each.value["availability_zone"]
  map_public_ip_on_launch = each.value["map_public_ip_on_launch"]
  tags = {
    Name = each.value.tags.Name
  } 
}

# create route table and add public route for vpc1
resource "aws_route_table" "vpc1_pub_rt" {
  for_each = var.aws_rt 
  vpc_id = aws_vpc.main[each.key].id 
  tags = {
    Name = each.value.tags.Name
  }
  route {
    cidr_block = each.value["cidr"]
    gateway_id = aws_internet_gateway.igw[each.key].id
  }
}

 # vpc1 associate public subnet az1 to "public route table"

resource "aws_route_table_association" "vpc_rt_association" {
  for_each = var.vpc_rt_1
  subnet_id = aws_subnet.vpc_subnets[each.key].id 
  route_table_id = aws_route_table.vpc1_pub_rt[each.key].id 
}

# create ec2

resource "aws_security_group" "my_security_group" {
  for_each = var.my_security_group
  vpc_id = aws_vpc.main[each.key].id
  ingress {
    description = "http access"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "https access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  tags = {
    Name = each.value.tags.Name
  }
}

# S3 flow logs

resource "aws_iam_role" "cross_account_logs_role" {
  provider = aws.akhil
  name     = "CrossAccountLogsRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::301167228985:root" ## you need to put AWSLogging aaccount ID s
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "cross_account_logs_policy_attachment" {
  provider   = aws.akhil
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.cross_account_logs_role.name
}

# Create VPC flow Logs

resource "aws_flow_log" "example" {
#   provider = aws.akhil
for_each = var.my_s3
  log_destination      = "arn:aws:s3:::demo-centralized-logging"
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main[each.key].id
  destination_options {
    file_format        = "plain-text"
    per_hour_partition = true
  }
#   depends_on = [ 
#     aws_s3_bucket.log_bucket,
#     aws_s3_bucket_policy.log_bucket_policy,
#   ]
}


# create ec2
resource "aws_instance" "my-instance" {
  # for_each = var.my_ec2
  ami = "ami-0d406e26e5ad4de53"
  instance_type = "t2.micro"
  key_name = "my-sta"
  # vpc_id = "vpc-0296f0dc87f9fd5fe"
  # subnet_id = "subnet-02439d63c21c56c0f"
  # security_groups = [aws_security_group.my_security_group[each.key].id]
  # tags = {
  #   Name = each.value.tags.Name
  # }
}


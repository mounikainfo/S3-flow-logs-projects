provider "aws" {
  region  = var.region
  profile = "akhil"
  alias = "akhil"

  default_tags {
    tags = {
      "Automation"  = "terraform"
      "Project"     = var.project_name
      "Environment" = var.environment
    }
  }
}
#vpcs creation

variable "vpcs" {
  type = map(object({
    cidr    = string
    tags    = map(string)
    tenancy = string
  }))
  default = {
    "one" = {
      cidr = "10.0.0.0/16"
      tags = {
        "Name" = "vpc-one"
      }
      tenancy = "default"
    }
    "two" = {
      cidr = "10.20.0.0/16"
      tags = {
        "Name" = "vpc-two"
      }
      tenancy = "default"
    }
  }
}

# Internet Gateway Creation

variable "IGWs1" {
  type = map(object({
    cidr    = string
    vpc_id  = string
    tags    = object({
      Name = string
    })
  }))
  default = {
    "one" = {
      vpc_id = "vpc-0296f0dc87f9fd5fe"
      cidr = "10.0.0.0/16"
      tags = {
        "Name" = "igw-one"
      } 
    }
    "two" = {
      vpc_id = "vpc-0796dac6ea671f05e"
      cidr = "10.20.0.0/16"
      tags = {
        "Name" = "igw-two"
      } 
    }
  }
}

# subnets Creation

variable "subnets" {
  type = map(object({
    cidr    = string
    vpc_id  = string
    availability_zone = string
    map_public_ip_on_launch = bool
    tags    = object({
      Name = string
    })
  }))
  default = {
    "one" = {
      vpc_id = "vpc-0296f0dc87f9fd5fe"
      cidr = "10.0.1.0/24"
      map_public_ip_on_launch = true
      availability_zone = "us-east-2a"
      tags = {
        "Name" = "vpc1_az1_public"
      } 
    }
    "two" = {
      vpc_id = "vpc-0796dac6ea671f05e"
      cidr = "10.20.1.0/24"
      map_public_ip_on_launch = true
      availability_zone = "us-east-2a"
      tags = {
        "Name" = "vpc2_az1_public"
      } 
    }
  }
}


variable "subnets1" {
  type = map(object({
    cidr    = string
    vpc_id  = string
    availability_zone = string
    map_public_ip_on_launch = bool
    tags    = object({
      Name = string
    })
  }))
  default = {
    "one" = {
      vpc_id = "vpc-0296f0dc87f9fd5fe"
      cidr = "10.0.2.0/24"
      map_public_ip_on_launch = false
      availability_zone = "us-east-2b"
      tags = {
        "Name" = "vpc1_az2_private"
      } 
    }
    "two" = {
      vpc_id = "vpc-0796dac6ea671f05e"
      cidr = "10.20.2.0/24"
      map_public_ip_on_launch = false
      availability_zone = "us-east-2b"
      tags = {
        "Name" = "vpc2_az2_private"
      } 
    }
  }
}

# vpc1 route table 
variable "aws_rt" {
  type = map(object({
    cidr    = string
    vpc_id  = string
    # availability_zone = string
    gateway_id = string
    tags    = object({
      Name = string
    })
  }))
  default = {
    "one" = {
      vpc_id = "vpc-0296f0dc87f9fd5fe"
      cidr = "0.0.0.0/0"
      # availability_zone = "us-east-2a"
      gateway_id = "igw-084526da46689be1f"
      tags = {
        "Name" = "vpc1_rt"
      } 
    }
    "two" = {
      vpc_id = "vpc-0796dac6ea671f05e"
      cidr = "0.0.0.0/0"
      gateway_id = "igw-0e138f09c40480499"
      tags = {
        "Name" = "vpc2_rt"
      } 
    }
  }
}

# vpc1 association with route table
variable "vpc_rt_1" {
  type = map(object({
    subnet_id = string
    route_table_id = string
    tags    = object({
      Name = string
    })
  }))
  default = {
    "one" = {
      route_table_id = "rtb-0c961d6a7d8723522"
      subnet_id = "subnet-02439d63c21c56c0f"
      tags = {
        "Name" = "vpc1_rt_asst"
      } 
    }
    "two" = {
      route_table_id = "rtb-04618f8ee191513cf"
      subnet_id = "subnet-035fa17aed68b665e"
      tags = {
        "Name" = "vpc2_rt_asst"
      } 
    }
  }
}


# security group

variable "my_security_group" {
  type = map(object({
    vpc_id = string
    tags    = object({
      Name = string
    })
  }))
  default = {
    "one" = {
      vpc_id = "vpc-0296f0dc87f9fd5fe"
      tags = {
        "Name" = "vpc1_sec_group"
      } 
    }
    "two" = {
      vpc_id = "vpc-0796dac6ea671f05e"
      tags = {
        "Name" = "vpc2_sec_group"
      } 
    }
  }
}

# s3
variable "my_s3" {
  type = map(object({
    vpc_id = string
    tags    = object({
      Name = string
    })
  }))
  default = {
    "one" = {
      vpc_id = "vpc-0296f0dc87f9fd5fe"
      tags = {
        "Name" = "my_s3_object"
      } 
    }
    "two" = {
      vpc_id = "vpc-0796dac6ea671f05e"
      tags = {
        "Name" = "my_s3_object2"
      } 
    }
  }
}

# # ec2
# variable "my_ec2" {
#   type = map(object({
#     security_group = string
#     tags = object({
#       Name = string
#     })
#   }))
#   default = {
#     "one" = {
#       security_group = "sg-031b37eefda3c3f71"
#       tags = {
#         "Name" = "vpc1_ec2"
#       }
#     }
#     "two" = {
#       security_group = "sg-07a9d6fde5f1a474f"
#       tags = {
#         "Name" = "vpc2_ec2"
#       }
#     }
#   }
# }

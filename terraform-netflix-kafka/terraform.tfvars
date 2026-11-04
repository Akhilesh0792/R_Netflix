aws_region   = "ap-south-1"
project_name = "netflix-kafka"
ami_id       = "ami-0dee22c13ea7a9a67"
instance_type= "t3.micro"
key_name     = "app-1"

vpc_cidr = "192.168.0.0/16"

public_subnets = {
  "pub-1" = { cidr = "192.168.1.0/24", az = "ap-south-1a" }
  "pub-2" = { cidr = "192.168.2.0/24", az = "ap-south-1b" }
}

private_subnets = {
  "priv-1" = { cidr = "192.168.10.0/24", az = "ap-south-1a" }
  "priv-2" = { cidr = "192.168.20.0/24", az = "ap-south-1b" }
}


zookeeper_nodes = {
  "zookeeper-1" = {
    subnet_key = "priv-1"
    disk_size  = 20
  }
}


kafka_nodes = {
  "kafka-broker-1" = {
    subnet_key = "priv-1"
    disk_size  = 30
  }
  "kafka-broker-2" = {
    subnet_key = "priv-2"
    disk_size  = 30
  }
}

app_nodes = {
  "netflix-app-1" = {
    subnet_key = "pub-1"
    disk_size  = 20
  }
}

control_vpc_id         = "vpc-0c90a1dd79c416e87"
control_route_table_id = "rtb-082cfa2797ed8a69d"
control_vpc_cidr       = "10.0.0.0/17"
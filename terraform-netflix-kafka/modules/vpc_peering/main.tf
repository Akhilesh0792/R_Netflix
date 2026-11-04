# 1. Create VPC Peering Connection & Auto-Accept (Same Account & Region)
resource "aws_vpc_peering_connection" "peer" {
  vpc_id      = var.target_vpc_id
  peer_vpc_id = var.peer_vpc_id
  auto_accept = true

  tags = {
    Name = "${var.project_name}-to-control-peering"
  }
}

# 2. Route in Existing Control Machine Route Table -> Target Kafka VPC (10.0.0.0/16)
resource "aws_route" "control_to_kafka" {
  route_table_id            = var.peer_route_table_id
  destination_cidr_block    = var.target_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

# 3. Route in Kafka Private Route Table -> Existing Control VPC CIDR
resource "aws_route" "kafka_to_control" {
  route_table_id            = var.target_private_route_table_id
  destination_cidr_block    = var.peer_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}
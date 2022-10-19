
resource "aws_elasticache_subnet_group" "redis_private_subnet_group" {
  name       = "${var.aws_app_identifier}-redis-subnet-group"
  subnet_ids = var.subnet_ids
  tags       = var.tags
}

resource "aws_security_group" "redis_sg" {
  name_prefix = "${var.aws_app_identifier}-redis-sg"
  vpc_id      = var.vpc_id
  description = "Digger Redis ${var.aws_app_identifier}"

  # Only redis in
  ingress {
    from_port       = var.redis_port
    to_port         = var.redis_port
    protocol        = "tcp"
    security_groups = var.security_group_ids
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_cluster" "dg_redis" {
  count                = var.redis_number_nodes > 1 ? 0 : 1
  cluster_id           = var.cluster_id
  engine               = "redis"
  node_type            = var.redis_node_type
  num_cache_nodes      = var.redis_number_nodes
  parameter_group_name = "default.redis6.x"
  engine_version       = var.engine_version
  port                 = var.redis_port
  security_group_ids   = [aws_security_group.redis_sg.id]
  subnet_group_name    = aws_elasticache_subnet_group.redis_private_subnet_group.name
  tags                 = var.tags
}

resource "aws_elasticache_replication_group" "dg_redis" {
  count                       = var.redis_number_nodes > 1 ? 1 : 0
  automatic_failover_enabled  = true
  replication_group_id        = var.cluster_id
  description                 = var.cluster_id
  node_type                   = var.redis_node_type
  num_cache_clusters          = var.redis_number_nodes
  parameter_group_name        = "default.redis6.x"
  security_group_ids          = [aws_security_group.redis_sg.id]
  subnet_group_name           = aws_elasticache_subnet_group.redis_private_subnet_group.name
  tags                        = var.tags
  port                        = 6379
}

output "redis_url" {
  value = var.redis_number_nodes > 1 ? "${aws_elasticache_replication_group.dg_redis[0].primary_endpoint_address}:${var.redis_port}" : "${aws_elasticache_cluster.dg_redis[0].cache_nodes[0].address}:${var.redis_port}"
}

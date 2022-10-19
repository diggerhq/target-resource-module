resource "aws_docdb_subnet_group" "docdb_subnet_group" {
  name        = "${var.aws_app_identifier}_docdb_subnet"
  description = "Allowed subnets for DB cluster instances"
  subnet_ids  = var.subnet_ids
}

resource "random_password" "docdb_password" {
  length  = 32
  special = false
}

resource "aws_security_group" "docdb_sg" {
  name_prefix = "${var.aws_app_identifier}-docdb-sg"
  vpc_id      = var.vpc_id
  description = "Digger docdb ${var.aws_app_identifier}"

  # Only postgres in
  ingress {
    from_port       = var.docdb_port
    to_port         = var.docdb_port
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

resource "aws_docdb_cluster" "docdb" {
  cluster_identifier      = var.cluster_identifier
  engine                  = "docdb"
  master_username         = var.docdb_username
  master_password         = random_password.docdb_password.result
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.docdb_sg.id]
  db_subnet_group_name    = aws_docdb_subnet_group.docdb_subnet_group.name
}

resource "aws_docdb_cluster_instance" "default" {
  count                      = var.instances_number
  identifier                 = "${var.cluster_identifier}-${count.index + 1}"
  cluster_identifier         = aws_docdb_cluster.docdb.id
  apply_immediately          = true
  instance_class             = var.instance_class
  engine                     = var.engine
  auto_minor_version_upgrade = true
}

resource "aws_ssm_parameter" "docdb_password" {
  name  = "${var.aws_app_identifier}.app_docdb.database_password"
  value = random_password.docdb_password.result
  type  = "SecureString"
}

output "endpoint" {
  value = aws_docdb_cluster.docdb.endpoint
}
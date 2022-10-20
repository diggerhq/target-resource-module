{% if (resource_type | lower) == "database" %}
module "app_rds" {
  source = "./rds"
  {%- if rds_instance_class is defined %}
  instance_class = "{{rds_instance_class}}"
  {% endif %}

  {%- if rds_engine is defined %}
  engine = "{{rds_engine}}"
  {%+ endif %}

  {%- if rds_engine == "postgres" %}
  ingress_port = 5432
  {%+ elif rds_engine == "mysql" %}
  ingress_port = 3306
  {%+ endif %}

  {%- if connection_schema is defined %}
  connection_schema = "{{connection_schema}}"
  {%+ endif %}
  
  {%- if rds_engine_version is defined %}
  engine_version = "{{rds_engine_version}}"
  {% endif %}

  {%- if storage_type is defined %}
  storage_type = "{{storage_type}}"
  {% endif %}

  {%- if rds_allocated_storage is defined %}
  allocated_storage = "{{rds_allocated_storage}}"
  {% endif %}

  {%- if database_snapshot_identifier is defined %}
  snapshot_identifier = "{{rds_snapshot_identifier}}"
  {% endif %}

  {%- if database_iops is defined %}
  iops = "{{rds_iops}}"
  {% endif %}

  {%- if aws_app_identifier %}
  identifier = "{{aws_app_identifier}}"
  {% endif %}

  {%- if db_name %}
  database_name = "{{db_name}}"
  {% endif %}

  publicly_accessible = false

  vpc_id = var.vpc_id
  private_subnets = var.private_subnets
  security_groups = var.security_groups
  aws_app_identifier = var.aws_app_identifier
}

output "database_url_ssm_arn" {
  value = module.app_rds.database_url_ssm_arn
}

output "database_address" {
  value = module.app_rds.database_address
}

output "database_endpoint" {
  value = module.app_rds.database_endpoint
}

output "database_name" {
  value = module.app_rds.database_name
}

output "database_username" {
  value = module.app_rds.database_username
}

output "database_password_ssm_arn" {
  value = module.app_rds.database_password_ssm_arn
}

output "database_port" {
  value = module.app_rds.database_port
}

{% elif (resource_type | lower) == "redis" %}
module "app_redis" {
  source = "./redis"
  cluster_id = "{{ aws_app_identifier }}"
  cluster_description = "{{ aws_app_identifier }}"

  {%- if redis_engine_version is defined %}
  engine_version = "{{redis_engine_version}}"
  {%+ endif %}

  {%- if redis_instance_class is defined %}
  redis_node_type = "{{redis_instance_class}}"
  {% endif %}

  {%- if redis_number_nodes is defined %}
  redis_number_nodes = "{{redis_number_nodes}}"
  {% endif %}

  aws_app_identifier = var.aws_app_identifier
  vpc_id = var.vpc_id
  private_subnets = var.private_subnets
  security_groups = var.security_groups
  tags = var.tags
}

output "redis_url" {
  value = module.app_redis.redis_url
}

{% elif (resource_type | lower) == "docdb" %}
module "app_docdb" {
  source = "./docdb"
  cluster_identifier = "{{ aws_app_identifier }}"
  vpc_id = var.vpc_id
  private_subnets = var.private_subnets
  security_groups = var.security_groups
  instance_class = "{{ docdb_instance_class }}"
  aws_app_identifier = var.aws_app_identifier
}

output "docdb_endpoint" {
  value = module.app_docdb.endpoint
}
{% endif %}


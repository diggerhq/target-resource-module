{% if (resource_type | lower) == "database" %}
module "app_rds_{{aws_app_identifier}}" {
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

output "DGVAR_DATABASE_{{ aws_app_identifier }}_URL" {
  value = module.app_rds_{{aws_app_identifier}}.database_url
}

output "DGVAR_DATABASE_{{ aws_app_identifier }}_ADDRESS" {
  value = module.app_rds_{{aws_app_identifier}}.database_address
}

output "DGVAR_DATABASE_{{ aws_app_identifier }}_NAME" {
  value = module.app_rds_{{aws_app_identifier}}.database_name
}

output "DGVAR_DATABASE_{{ aws_app_identifier }}_USERNAME" {
  value = module.app_rds_{{aws_app_identifier}}.database_username
}

output "DGVAR_DATABASE_{{ aws_app_identifier }}_PASSWORD" {
  value = module.app_rds_{{aws_app_identifier}}.database_password
}

output "DGVAR_DATABASE_{{ aws_app_identifier }}_PORT" {
  value = module.app_rds_{{aws_app_identifier}}.database_port
}

{% elif (resource_type | lower) == "redis" %}
module "app_redis_{{aws_app_identifier}}" {
  source = "./redis"
  cluster_id = "${var.aws_app_identifier}"
  cluster_description = "${var.aws_app_identifier}"

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

output "DGVAR_REDIS_{{ aws_app_identifier }}_URL" {
  value = module.app_redis_{{aws_app_identifier}}.redis_url
}

{% elif (resource_type | lower) == "docdb" %}
module "app_docdb_{{aws_app_identifier}}" {
  source = "./docdb"
  cluster_identifier = "${var.aws_app_identifier}"
  vpc_id = var.vpc_id
  private_subnets = var.private_subnets
  security_groups = var.security_groups
  instance_class = "{{ docdb_instance_class }}"
  aws_app_identifier = var.aws_app_identifier
}

output "DGVAR_DOCDB_{{ aws_app_identifier }}_URL" {
  value = module.app_docdb_{{aws_app_identifier}}.endpoint
}
{% endif %}


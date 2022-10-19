{% for resource in environment_config.resources %}
    {% if (resource.resource_type | lower) == "database" %}
        module "app_rds_{{aws_app_identifier}}" {
          source = "../rds"
          {%- if resource.rds_instance_class is defined %}
          instance_class = "{{resource.rds_instance_class}}"
          {% endif %}

          {%- if resource.rds_engine is defined %}
          engine = "{{resource.rds_engine}}"
          {%+ endif %}

          {%- if resource.rds_engine == "postgres" %}
          ingress_port = 5432
          {%+ elif resource.rds_engine == "mysql" %}
          ingress_port = 3306
          {%+ endif %}

          {%- if resource.connection_schema is defined %}
          connection_schema = "{{resource.connection_schema}}"
          {%+ endif %}
          
          {%- if resource.rds_engine_version is defined %}
          engine_version = "{{resource.rds_engine_version}}"
          {% endif %}

          {%- if resource.storage_type is defined %}
          storage_type = "{{resource.storage_type}}"
          {% endif %}

          {%- if resource.rds_allocated_storage is defined %}
          allocated_storage = "{{resource.rds_allocated_storage}}"
          {% endif %}

          {%- if resource.database_snapshot_identifier is defined %}
          snapshot_identifier = "{{resource.rds_snapshot_identifier}}"
          {% endif %}

          {%- if resource.database_iops is defined %}
          iops = "{{resource.rds_iops}}"
          {% endif %}

          {%- if aws_app_identifier %}
          identifier = "{{aws_app_identifier}}"
          {% endif %}

          {%- if resource.db_name %}
          database_name = "{{resource.db_name}}"
          {% endif %}

          publicly_accessible = false

          vpc_id = var.vpc_id
          subnet_ids = var.private_subnet_ids
          security_group_ids = var.security_group_ids
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

    {% elif (resource.resource_type | lower) == "redis" %}
        module "app_redis_{{aws_app_identifier}}" {
          source = "../redis"
          cluster_id = "${var.aws_app_identifier}"
          cluster_description = "${var.aws_app_identifier}"

          {%- if resource.redis_engine_version is defined %}
          engine_version = "{{resource.redis_engine_version}}"
          {%+ endif %}

          {%- if resource.redis_instance_class is defined %}
          redis_node_type = "{{resource.redis_instance_class}}"
          {% endif %}

          {%- if resource.redis_number_nodes is defined %}
          redis_number_nodes = "{{resource.redis_number_nodes}}"
          {% endif %}

          aws_app_identifier = var.aws_app_identifier
          vpc_id = var.vpc_id
          subnet_ids = var.private_subnet_ids
          security_group_ids = var.security_group_ids
          tags = var.tags
        }

        output "DGVAR_REDIS_{{ aws_app_identifier }}_URL" {
          value = module.app_redis_{{aws_app_identifier}}.redis_url
        }

    {% elif (resource.resource_type | lower) == "docdb" %}
        module "app_docdb_{{aws_app_identifier}}" {
          source = "../docdb"
          cluster_identifier = "${var.aws_app_identifier}"
          vpc_id = var.vpc_id
          subnet_ids = var.private_subnet_ids
          security_group_ids = var.security_group_ids
          instance_class = "{{ resource.docdb_instance_class }}"
          aws_app_identifier = var.aws_app_identifier
        }

        output "DGVAR_DOCDB_{{ aws_app_identifier }}_URL" {
          value = module.app_docdb_{{aws_app_identifier}}.endpoint
        }
    {% endif %}
{% endfor %}

contains terraform for resources attached to environments


RDS database is private by default.

Jinja parameters

for RDS

Parameter | Terraform                           | Description
--- |------------------------------------- | --- 
resource_type |                                     | 'database' or 'redis' or 'docdb'
aws_app_identifier | aws_db_instance.identifier          | used in terraform resources names and as rds 'identifier' parameter
rds_instance_class | aws_db_instance.engine_version      |(Required) The instance type of the RDS instance.
rds_engine | aws_db_instance.engine              |  The database engine to use: 'postgres' or 'mysql' 
connection_schema |                                     | Connection schems for database connection string, 'postgres' or 'mysql'
rds_engine_version | aws_db_instance.engine_version      | The engine version to use.
storage_type | aws_db_instance.storage_type        | One of "standard" (magnetic), "gp2" (general purpose SSD), or "io1" (provisioned IOPS SSD). 
rds_allocated_storage | aws_db_instance.allocated_storage   | The allocated storage in gibibytes. 
rds_snapshot_identifier | aws_db_instance.snapshot_identifier | (Optional) Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05.
rds_iops | aws_db_instance.iops                | (Optional) The amount of provisioned IOPS. Setting this implies a storage_type of "io1".
db_name | aws_db_instance.db_name | The database name.

outputs for rds database:

Output name | Description
---| ----
database_url_ssm_arn | ARN of SSM parameter storing rds database connection string (containing password)
database_address | The hostname of the RDS instance.
database_endpoint | The connection endpoint in address:port format.
database_name | The database name.
database_username | The master username for the database.
database_password_ssm_arn | ARN of SSM parameter storing database password
database_port | The database port.


For Redis

Parameter | Terraform                           | Description
--- |------------------------------------- | --- 
aws_app_identifier | aws_elasticache_cluster.cluster_id |
redis_engine_version | aws_elasticache_cluster.redis_engine_version | 
redis_number_nodes | | 
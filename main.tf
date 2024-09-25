provider "aws" {
  region = var.region
}

# PostgreSQL Subnet Group
resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = "postgres-subnet-group"
  subnet_ids = ["subnet-0f72be4624adad8ff", "subnet-062aedcd420fbf6f6"]
}

# PostgreSQL Instance
resource "aws_db_instance" "postgres" {
  identifier             = "postgres-instance"
  engine                 = "postgres"
  engine_version         = "15.7"
  instance_class         = "db.t3.micro"
  allocated_storage      = 10
  username               = var.rds_username
  password               = var.rds_password
  db_name                = var.rds_db_name
  db_subnet_group_name   = aws_db_subnet_group.postgres_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
}

# Security Group for PostgreSQL
resource "aws_security_group" "db_sg" {
  name        = "postgres-sg"
  description = "Allow internal VPC access to PostgreSQL"
  vpc_id      = "vpc-0cc3c139f96487cc0"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Redis instance
resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "redis-instance"
  engine               = "redis"
  engine_version       = "7.1"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids   = [aws_security_group.redis_sg.id]
}

# Subnet Group for Redis
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = ["subnet-0f72be4624adad8ff"]
}

# Security Group for Redis
resource "aws_security_group" "redis_sg" {
  name        = "redis-sg"
  description = "Allow internal VPC access to Redis"
  vpc_id      = "vpc-0cc3c139f96487cc0"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# this block is for creating Redis with user authentication and TLS enabled
#resource "aws_elasticache_user" "redis_user" {
#  user_id              = "poc-id"
#  user_name            = var.redis_username
#  passwords            = [var.redis_password]
#  engine               = "REDIS"
#  access_string        = "on ~* +@all"
#  no_password_required = false
#}
#
#resource "aws_elasticache_user_group" "redis_user_group" {
#  user_group_id = "poc-group"
#  engine        = "REDIS"
#  user_ids      = ["default", aws_elasticache_user.redis_user.user_id]
#}
#
#resource "aws_elasticache_replication_group" "redis" {
#  replication_group_id       = "poc-redis"
#  description                = "redis demo"
#  engine                     = "redis"
#  engine_version             = "7.1"
#  node_type                  = "cache.t3.micro"
#  replicas_per_node_group    = 0
#  automatic_failover_enabled = false
#  subnet_group_name          = aws_elasticache_subnet_group.redis_subnet_group.name
#  security_group_ids         = [aws_security_group.redis_sg.id]
#  transit_encryption_enabled = false
#  at_rest_encryption_enabled = false
#  user_group_ids             = [aws_elasticache_user_group.redis_user_group.id]
#}
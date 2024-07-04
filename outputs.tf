output "region" {
  description = "AWS region"
  value       = var.region
}

output "postgres_server_details" {
  description = "Postgres server details"
  value = {
    hostname      = aws_db_instance.postgres.address
    port          = aws_db_instance.postgres.port
    database_name = aws_db_instance.postgres.db_name
  }
  #  sensitive = true
}

output "redis_cache_details" {
  description = "Redis cache details"
  value = {
    hostname = aws_elasticache_cluster.redis.cache_nodes[0].address
    port     = aws_elasticache_cluster.redis.cache_nodes[0].port
  }
}
# Terraform AWS RDS and Redis Module
This private module is to quickly build the external services (RDS Postsgre DB and Redis instances) on AWS required deploying [Terraform Enterprise on Docker](https://developer.hashicorp.com/terraform/enterprise/flexible-deployments/install/docker/requirements). 

Once the provision is completed, it will print out the following outputs. For example:
```
postgres_server_details = {
  "database_name" = "tfedb"
  "hostname" = "postgres-instance.xxxxxxxx.ap-southeast-2.rds.amazonaws.com"
  "port" = 5432
}
redis_cache_details = {
  "hostname" = "redis-instance.xxxxxxx.0001.apse2.cache.amazonaws.com"
  "port" = 6379
}
region = "ap-southeast-2"
```

With these outputs, test the connectivity to the external services within the the same VPC. For example:

**Postgres**
```
$ PGPASSWORD=$PASSWORD psql -h postgres-instance.xxxxxx.ap-southeast-2.rds.amazonaws.com -U postgres -c "\l"
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
-----------+----------+----------+-------------+-------------+-----------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
...
(5 rows)
```

**Redis**
```
$ redis-cli -h redis-instance.ls32dv.0001.apse2.cache.amazonaws.com -p 6379 ping
PONG
```

Next, configure the [Docker Compose YAML file](https://developer.hashicorp.com/terraform/enterprise/flexible-deployments/install/docker/install#external-services) to specify the hostnames of the PostgreSQL and Redis instances. Then, deploy the Terraform Enterprise Docker setup on an EC2 instance within the same VPC.
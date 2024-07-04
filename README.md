# build-rds-redis
This repo is to quickly build the Postgre DB and Redis instances on AWS for Terraform Enterprise.
Before Terraform Apply, review the variables file and update the `rds_password`

Once Apply is completed, it will output some values. For example:
```
postgres_server_details = {
  "database_name" = "tfedb"
  "hostname" = "postgres-instance.ckgqyibxexph.ap-southeast-2.rds.amazonaws.com"
  "port" = 5432
}
redis_cache_details = {
  "hostname" = "redis-instance.ls32dv.0001.apse2.cache.amazonaws.com"
  "port" = 6379
}
region = "ap-southeast-2"
```

With these outputs, test the connectivitiy to the instances within the the same VPC. For example:

Postgres

```
$ PGPASSWORD=$PASSWORD psql -h postgres-instance.ckgqyibxexph.ap-southeast-2.rds.amazonaws.com -U postgres -c "\l"
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
-----------+----------+----------+-------------+-------------+-----------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 rdsadmin  | rdsadmin | UTF8     | en_US.UTF-8 | en_US.UTF-8 | rdsadmin=CTc/rdsadmin
 template0 | rdsadmin | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/rdsadmin          +
           |          |          |             |             | rdsadmin=CTc/rdsadmin
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 tfedb     | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
(5 rows)
```

Redis
```
$ redis-cli -h redis-instance.ls32dv.0001.apse2.cache.amazonaws.com -p 6379 ping
PONG
```

Next, bulid the Terraform Enterprise Docker deployment over an EC2 within the same VPC.
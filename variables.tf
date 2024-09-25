variable "region" {
  description = "The AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable "rds_username" {
  description = "RDS username"
  type        = string
  default     = "postgres"
}

variable "rds_db_name" {
  description = "RDS database name"
  type        = string
  default     = "tfedb"
}

variable "rds_password" {
  description = "RDS password"
  type        = string
  sensitive   = true
}

#variable "redis_username" {
#  description = "The Redis username"
#  type        = string
#}
#
#variable "redis_password" {
#  description = "The Redis password"
#  type        = string
#  sensitive   = true
#}
output "mongodb_instance_id" {
  value = module.mongodb_server.instance_id[0]
}

output "redis_instance_id" {
  value = module.redis_server.instance_id[0]
}

output "rabbitmq_instance_id" {
  value = module.rabbitmq_server.instance_id[0]
}

output "mysql_instance_id" {
  value = module.mysql_server.instance_id[0]
}
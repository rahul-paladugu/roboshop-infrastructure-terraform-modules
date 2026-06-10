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
output "mongodb_private_ip" {
  value = module.mongodb_server.private_ip[0]
}
output "redis_private_ip" {
  value = module.redis_server.private_ip[0]
}

output "rabbitmq_private_ip" {
  value = module.rabbitmq_server.private_ip[0]
}
output "mysql_private_ip" {
  value = module.mysql_server.private_ip[0]
}
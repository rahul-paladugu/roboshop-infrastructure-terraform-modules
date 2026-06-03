output "mongodb_instance_id" {
  value = module.mongodb_server.instance_id
}

output "redis_instance_id" {
  value = module.redis_server.instance_id
}

output "rabbitmq_instance_id" {
  value = module.rabbitmq_server.redis_instance_id
}
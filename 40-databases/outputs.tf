output "mongodb_instance_id" {
  value = module.mongodb_server.id
}

output "redis_instance_id" {
  value = module.redis_server.id
}

output "rabbitmq_instance_id" {
  value = module.rabbitmq_server.id
}
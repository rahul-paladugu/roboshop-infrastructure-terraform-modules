locals {
    ami_id = data.aws_ami.roboshop_ami.id
    db_subnet_id = split("," , data.aws_ssm_parameter.database_subnet_ids.value )[0]
    mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_id.value
    rabbitmq_sg_id = data.aws_ssm_parameter.rabbitmq_sg_id.value
    redis_sg_id = data.aws_ssm_parameter.redis_sg_id.value
    mysql_sg_id = data.aws_ssm_parameter.mysql_sg_id.value
    remote_user =  data.aws_ssm_parameter.remote_user.value
    remote_user_password = data.aws_ssm_parameter.remote_user_password.value
    zone_id = data.aws_route53_zone.roboshop_r53.zone_id
    r53_common_name = "rscloudservices.icu"
}
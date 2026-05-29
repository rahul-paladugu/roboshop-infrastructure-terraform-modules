locals {
    db_subnet_id = split("," , data.aws_ssm_parameter.database_subnet_ids.value )[0]
    mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_id.value
    remote_user =  data.aws_ssm_parameter.remote_user.value
    remote_user_password = data.aws_ssm_parameter.remote_user_password.value
}
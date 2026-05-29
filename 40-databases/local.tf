locals {
    db_subnet_id = split("," , data.aws_ssm_parameter.database_subnet_ids.value )[0]
    mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_id.value
}
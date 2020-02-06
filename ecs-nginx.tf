# NGINX Service
resource "aws_ecs_service" "nginx" {
  name            = "nginx"
  cluster         = aws_ecs_cluster.demo.id
  task_definition = aws_ecs_task_definition.nginx.arn
  desired_count   = var.min_size * 2
  iam_role        = aws_iam_role.ecs-service-role.arn
  depends_on      = [aws_iam_role_policy_attachment.ecs-service-attach]

  load_balancer {
    target_group_arn = aws_alb_target_group.nginx.id
    container_name   = "nginx"
    container_port   = "80"
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}

resource "aws_ecs_task_definition" "nginx" {
  family = "nginx"
  container_definitions = data.template_file.task_definition_template.rendered
}

data "template_file" "task_definition_template" {
    template = file("task_definition.json.tpl")
    vars = {
      IMAGE = "nginx"
    }
}

resource "aws_cloudwatch_log_group" "nginx" {
  name = "/ecs-demo/nginx"
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.max_size * 2
  min_capacity       = var.min_size * 2
  resource_id        = "service/demo/nginx"
  role_arn           = aws_iam_role.ecs-service-role.arn
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "cpu-auto-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

 target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = var.target_value
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }

}

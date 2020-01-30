# NGINX Service
resource "aws_ecs_service" "nginx" {
  name            = "nginx"
  cluster         = aws_ecs_cluster.demo.id
  task_definition = aws_ecs_task_definition.nginx.arn
  desired_count   = 4
  iam_role        = aws_iam_role.ecs-service-role.arn
  depends_on      = [aws_iam_role_policy_attachment.ecs-service-attach]

  load_balancer {
    target_group_arn = aws_alb_target_group.nginx.id
    container_name   = "nginx"
    container_port   = "80"
  }

  lifecycle {
    ignore_changes = [task_definition]
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


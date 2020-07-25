[
  {
    "name": "${service_name}-${stage}",
    "image": "${app_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/${service_name}-${stage}",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${app_port},
        "hostPort": ${app_port}
      }
    ],
    "environment": [
      {
        "name": "DB_HOST",
        "value": "${env_db_host}"
      },
      {
        "name": "DB_USERNAME",
        "value": "${env_db_user}"
      },
      {
        "name": "DB_PASSWORD",
        "value": "${env_db_password}"
      },
      {
        "name": "RAILS_ENV",
        "value": "${env_rails_env}"
      }
    ]
  }
]

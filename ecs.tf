# iam resources for ecs
resource "aws_iam_role" "ecs_instance_role" {
    name = "EcsInstanceRole"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

    tags = {
        Name = "EcsInstanceRole"
    }
}   

resource "aws_iam_role_policy_attachment" "ecs_instance_policy" {
    role = "${aws_iam_role.ecs_instance_role.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
    name = "EcsInstanceProfile"
    role = "${aws_iam_role.ecs_instance_role.name}"
}

# ecs cluster with auto scaling
resource "aws_ecs_cluster" "app_cluster" {
    name = "App-Cluster"
}

# launching the ecs cluster nodes with auto scaling
resource "aws_launch_configuration" "ecs_config" {
    name = "ECSLaunchConfig"
    image_id = "${var.image_id}"
    instance_type = "${var.instance_type}"

    iam_instance_profile = "${aws_iam_instance_profile.ecs_instance_profile.name}"
    key_name = "${var.keyname}"
    security_groups = ["${aws_security_group.app_sg.id}"]

    associate_public_ip_address = true
    user_data = <<EOF
#! /bin/bash
echo ECS_CLUSTER="App-Cluster" > /etc/ecs/ecs.config
echo "Stating ECS....."
/usr/libexec/amazon-ecs-init pre-start
/usr/libexec/amazon-ecs-init start
echo "Started ECS"
EOF
}

resource "aws_autoscaling_group" "ecs_asg" {
    name = "EcsASG"
    max_size = "${var.maximum_nodes}"
    min_size = "${var.minimum_nodes}"
    desired_capacity = "${var.desired_nodes}"

    health_check_type = "EC2"

    launch_configuration = "${aws_launch_configuration.ecs_config.name}"
    vpc_zone_identifier = ["${aws_subnet.private_a.id}", "${aws_subnet.private_b.id}", "${aws_subnet.private_c.id}"]

    tag {
        key = "Name"
        value = "EcsNode"
        propagate_at_launch = true
    }
}

# ecs cluster node scaling policies
resource "aws_autoscaling_policy" "ecs_scale_up" {
    name = "ScaleUpPolicy"
    autoscaling_group_name = "${aws_autoscaling_group.ecs_asg.name}"
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = "1"
    cooldown = "300"
    policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "ecs_scaleup_alarm" {
    alarm_name = "EcsScaleUpAlarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "75"
    dimensions = {
        "AutoScalingGroupName" = "${aws_autoscaling_group.ecs_asg.name}"
    }
    actions_enabled = true
    alarm_actions = ["${aws_autoscaling_policy.ecs_scale_up.arn}"]
}

resource "aws_autoscaling_policy" "ecs_scale_down" {
    name = "ScaleDownPolicy"
    autoscaling_group_name = "${aws_autoscaling_group.ecs_asg.name}"
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = "-1"
    cooldown = "300"
    policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "ecs_scaledown_alarm" {
    alarm_name = "EcsScaleDownAlarm"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = "120"
    statistic = "Average"
    threshold = "75"
    dimensions = {
        "AutoScalingGroupName" = "${aws_autoscaling_group.ecs_asg.name}"
    }
    actions_enabled = true
    alarm_actions = ["${aws_autoscaling_policy.ecs_scale_down.arn}"]
}

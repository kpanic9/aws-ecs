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

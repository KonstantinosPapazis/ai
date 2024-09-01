{
"Statement": [
{
"Action": "*",
"Effect": "Allow",
"Principal": {
"AWS": "arn:aws:iam::428858718180:role/SageMaker-test-Role"
},
"Resource": "arn:aws:execute-api:eu-west-1:428858718180:*"
}
]
}
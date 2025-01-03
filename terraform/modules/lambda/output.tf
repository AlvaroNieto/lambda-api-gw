output "lambda_arn" {
  value = aws_lambda_function.visit_counter_lmbd.arn
}

output "invoke_arn" {
  value = aws_lambda_function.visit_counter_lmbd.invoke_arn
}

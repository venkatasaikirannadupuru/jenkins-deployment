output "api_url" {
  description = "Employee Management API URL"
  value       = "${aws_apigatewayv2_api.employee_api.api_endpoint}/employees"
}

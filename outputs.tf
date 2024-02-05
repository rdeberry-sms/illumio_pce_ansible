output "admin_ui_passwd" {
  description = "Admin UI Password"
  value       = random_password.admin_ui.result
  sensitive   = true
}

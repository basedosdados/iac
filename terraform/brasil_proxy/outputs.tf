output "brasil_proxy_ip" {
  description = "IP externo estático da VM do proxy."
  value       = google_compute_address.brasil_proxy_static_ip.address
}

output "brasil_proxy_username" {
  description = "Usuário de autenticação do Squid."
  value       = var.proxy_username
}

output "brasil_proxy_password" {
  description = "Senha de autenticação do Squid (também em Secret Manager: brasil-proxy-password)."
  value       = random_password.brasil_proxy_password.result
  sensitive   = true
}

output "brasil_proxy_ip" {
  description = "IP externo estático da VM do proxy (iac#155)."
  value       = module.brasil_proxy.brasil_proxy_ip
}

output "brasil_proxy_username" {
  description = "Usuário de autenticação do Squid."
  value       = module.brasil_proxy.brasil_proxy_username
}

output "brasil_proxy_password" {
  description = "Senha de autenticação do Squid (também em Secret Manager: brasil-proxy-password)."
  value       = module.brasil_proxy.brasil_proxy_password
  sensitive   = true
}

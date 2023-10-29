variable "domain_name" {
  default = "*.ricardosantins.xyz"
}

variable "domain_alternative_names" {
  type = list(string)
  default = [
    "www.ricardosantins.xyz", 
    "www.rickys-data.today",
    "rickys-data.today"
  ]
}
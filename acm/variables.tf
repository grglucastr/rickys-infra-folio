variable "domain_name" {
  default = "*.rickys-data.today"
}

variable "domain_alternative_names" {
  type = list(string)
  default = ["www.rickys-data.today","rickys-data.today"]
}
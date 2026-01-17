variable "project_name" {
  type    = string
  default = "registration-website-git"
}

variable "env" {
  type    = string
  default = "uat"
}

locals {
  bucket_name              = "${var.project_name}-logs-${var.env}"
  bucket_versioning_status = "Enabled"
  index_file               = "index.html"
  error_file               = "error.html"
}

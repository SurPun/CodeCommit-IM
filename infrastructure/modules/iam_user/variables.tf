variable "name" {
  description = "The name of the IAM User."
  type        = string
}

variable "path" {
  type        = string
  description = "The path of the IAM user"
}

variable "force_destroy" {
  type        = bool
  description = "Whether to destroy the IAM user when the module is destroyed"
}

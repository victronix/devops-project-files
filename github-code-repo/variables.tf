variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}

variable "repository_name" {
  description = "Name of the GitHub repository"
  type        = string
  default     = "devops-project-files"
}

variable "github_owner" {
  description = "GitHub owner"
  type        = string
  default     = "victronix"
} 
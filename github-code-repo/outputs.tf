output "repository_url" {
  description = "URL of the created repository"
  value       = github_repository.frontend.html_url
}

output "clone_url" {
  description = "URL for cloning the repository"
  value       = github_repository.frontend.git_clone_url
} 
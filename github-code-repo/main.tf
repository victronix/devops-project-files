terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  token = var.github_token
}

# Create the repository
resource "github_repository" "frontend" {
  name        = var.repository_name
  description = "Static frontend application repository"

  visibility = "public"

  has_issues    = true
  has_wiki      = false
  has_projects  = false
  has_downloads = false

  allow_merge_commit = false
  allow_squash_merge = true
  allow_rebase_merge = false

  auto_init = true

  gitignore_template = "Node"
  license_template   = "mit"

  vulnerability_alerts = true
} 
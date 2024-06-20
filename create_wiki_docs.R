

# try to make wiki with help from ChatGPT

# Load necessary libraries
library(officer)
library(pandoc)
library(rmarkdown)
library(git2r)

# Set Pandoc path
options(rmarkdown.pandoc.path = 'C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools')

# Define paths
input_directory <- normalizePath("word_docs-lf/")
output_directory <- normalizePath("my-wiki/_posts")

# Ensure output directory exists
if (!dir.exists(output_directory)) {
  dir.create(output_directory, recursive = TRUE)
}

# Get list of Word documents in the input directory
input_files <- list.files(input_directory, pattern = "\\.docx$", full.names = TRUE)

# Convert all Word documents to Markdown
for (input_file in input_files) {
  output_file <- file.path(output_directory, gsub("\\.docx$", ".md", basename(input_file)))
  tryCatch({
    rmarkdown::pandoc_convert(input_file, to = "markdown", output = output_file)
  }, error = function(e) {
    message("Error converting ", input_file, " to Markdown: ", e)
  })
}

# Git operations
repo <- repository(normalizePath("my-wiki"))
add(repo, "*")
commit(repo, "Add converted markdown files")
# Use your personal access token for authentication
credentials <- cred_user_pass("your_github_username", "your_github_token")
push(repo, credentials = credentials)

# Note: Replace "your_github_username" with your actual GitHub username
# Replace "your_github_token" with a personal access token from GitHub

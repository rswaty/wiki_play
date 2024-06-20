

# try to make wiki with help from ChatGPT

# Load necessary libraries
library(officer)
library(rmarkdown)
library(git2r)

# Function to convert a Word document to Markdown
convert_docx_to_md <- function(input_file, output_file) {
  rmarkdown::pandoc_convert(input_file, to = "markdown", output = output_file)
}

# Define paths
input_directory <- "word_docs/" # Directory containing Word documents
output_directory <- "my-wiki/_posts" # Directory where Markdown files will be saved

# Ensure output directory exists
if (!dir.exists(output_directory)) {
  dir.create(output_directory, recursive = TRUE)
}

# Get list of Word documents in the input directory
input_files <- list.files(input_directory, pattern = "\\.docx$", full.names = TRUE)

# Convert all Word documents to Markdown
for (input_file in input_files) {
  output_file <- file.path(output_directory, gsub("\\.docx$", ".md", basename(input_file)))
  convert_docx_to_md(input_file, output_file)
}

# Git operations
repo <- repository("my-wiki")
add(repo, "*")
commit(repo, "Add converted markdown files")
# Use your personal access token for authentication
credentials <- cred_user_pass("your_github_username", "your_github_token")
push(repo, credentials = credentials)

# Note: Replace "your_github_username" with your actual GitHub username
# Replace "your_github_token" with a personal access token from GitHub

# Load packages
library(tidyverse)
library(rvest)
library(keyring)
library(httr)
library(jsonlite)

# Read in climbs data
top_100_climbs_df <- read_csv("https://raw.githubusercontent.com/martinctc/blog/refs/heads/master/datasets/top_100_climbs.csv")

# Preview first URL
top_100_climbs_df$url[[1]]

# Use rvest to extract content from URL
page_content <- read_html(top_100_climbs_df$url[[1]])

# Parse page_content to extract the text
page_text <- page_content %>% html_elements(".entry-content") %>% html_text()

# Set system prompt
sys_prompt <- "Please summarise the following article, identifying the top 3-5 takeaways."

# Set key - console opens for you to store API key
keyring::key_set("AZ_OPENAI")

# Note: using the chat endpoint instead of the legacy completions endpoint
# This allows us to use some of the newer models from Open AI, such as gpt-4o.
# 
# Use `keyring::key_set(service = "AZ_OPENAI")` to set the API key
# Go to Azure OpenAI Service > resource > Deployments to for model version

az_openai_endpoint <- "https://demo-r.openai.azure.com/"
azo_completions_ep <- paste0(
  az_openai_endpoint,
  "openai/deployments/",
  "gpt-4o-mini/chat/completions?api-version=2024-08-01-preview"
  )

# Get the API key from the keyring
az_key <- keyring::key_get("AZ_OPENAI")

# Function to generate chat completions ----------------------------------
generate_completion <- function(
    sys_prompt,
    user_prompt,
    api_endpoint = azo_completions_ep,
    api_key = az_key,
    max_retries = 5) {
  
  retries <- 0
  while (retries < max_retries) {
    response <- POST(
      url = api_endpoint,
      add_headers(
        "api-key" = api_key
      ),
      body = list(
        messages = list(
          list(role = "system", content = sys_prompt),
          list(role = "user", content = user_prompt)
        ),
        max_tokens = 1000,
        temperature = 0.7,
        top_p = 1
      ),
      encode = "json"
    )
    
    if (status_code(response) == 200) {
      response_content <- content(response, as = "parsed", type = "application/json")
      response_text <- response_content$choices[[1]]$message$content
      
      # Calculate token count
      token_count <- (nchar(sys_prompt) + nchar(user_prompt)) / 4  # Rough estimate of tokens
      
      return(tibble(
        prompt = user_prompt,
        response = response_text,
        token_count = token_count
      ))
      
    } else if (status_code(response) == 429) {
      # Handle 429 error by waiting and retrying
      retry_after <- as.numeric(headers(response)$`retry-after`)
      if (is.na(retry_after)) {
        retry_after <- 2 ^ retries  # Exponential backoff
      }
      Sys.sleep(retry_after)
      retries <- retries + 1
    } else {
      warning(paste("Error in API request:", status_code(response)))
      retries <- retries + 1
      Sys.sleep(2 ^ retries)  # Exponential backoff for other errors
    }
  }
  
  stop("Max retries exceeded")
}

# Run function - test
generate_completion(
  sys_prompt = "Describe the following animal in terms of its taxonomic rank, habitat, and diet.",
  user_prompt = "yellow spotted lizard",
  max_retries = 1
) %>%
.$response %>%
message()

# Run function for real
output_df <-
  generate_completion(
    sys_prompt = sys_prompt,
    user_prompt = page_text,
    max_retries = 1
  )

output_df
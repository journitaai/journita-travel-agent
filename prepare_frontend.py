# Copy the frontend HTML and update the API URL for production
import os
import re

# Read the local frontend file
with open('frontend_8002.html', 'r', encoding='utf-8') as f:
    content = f.read()

# Replace localhost API URL with production URL
# You'll need to update this with your actual GCP URL after deployment
production_content = content.replace(
    "const API_BASE = 'http://localhost:8002';",
    "const API_BASE = window.location.origin;"
)

# Write the production frontend
with open('frontend_production.html', 'w', encoding='utf-8') as f:
    f.write(production_content)

print("✅ Production frontend created: frontend_production.html")

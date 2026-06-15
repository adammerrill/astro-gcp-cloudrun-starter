# Application Scaffold

This directory contains a minimal, framework-agnostic placeholder application designed for deployment to Google Cloud Run.

### Customizing Your Application
You can replace the contents of this folder with your actual application code (e.g., Next.js, FastAPI, Go, Rust, Ruby, Python, etc.).

The only contract required by Google Cloud Run is:
1. **Containerized**: Must contain a valid `Dockerfile` at the root of the application directory.
2. **Expose Port**: Must listen on the port defined by the `$PORT` environment variable (defaults to `8080` if not set).
3. **Stateless**: Must be stateless and respond to standard HTTP requests.

# Users Service

Users service written in Rust with Actix-web.

## Prerequisites

- Rust (latest stable version)
- Cargo

## Installation

```bash
# Install dependencies
cargo build
```

## Development

### Option 1: Using the npm scripts (recommended)
```bash
# Run with bacon (hot-reload on file changes)
pnpm dev

# Run without bacon (simple cargo run)
pnpm start

# Alternative: Run with bacon but simpler (no TUI)
pnpm dev:simple

# Run in check mode only (no execution, just compilation checking)
pnpm dev:check

# Run tests with watch mode
pnpm test:watch
```

**Important:** All scripts (`dev`, `start`, `dev:simple`) include proper Ctrl+C signal handling. When you press Ctrl+C:
- The wrapper script catches the signal
- Kills the Rust process cleanly
- Frees up port 3012
- Shows a cleanup confirmation message

This prevents orphaned processes and port conflicts.

### Option 2: Using Cargo directly
```bash
# Run the service
cargo run

# Run tests
cargo test

# Lint
cargo clippy -- -D warnings

# Format code
cargo fmt
```

## Scripts

- `pnpm build` - Build the release version
- `pnpm dev` - Start development mode with bacon (code checker)
- `pnpm dev:watch` - Start development mode with bacon (auto-run on changes)
- `pnpm start` - Run the service (debug mode)
- `pnpm start:prod` - Run the service (release mode)
- `pnpm test` - Run tests
- `pnpm test:watch` - Run tests in watch mode
- `pnpm lint` - Lint the code with clippy
- `pnpm format` - Format the code
- `pnpm clean` - Clean build artifacts

## API Endpoints

### Health Check
- `GET /health` - Service health status
- `GET /` - Service info

### Users
- `GET /users` - Get all users
- `GET /users/{id}` - Get user by ID
- `POST /users` - Create a new user

### Example Request
```bash
# Create a user
curl -X POST http://localhost:3012/users \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "name": "John Doe"}'

# Get all users
curl http://localhost:3012/users

# Get user by ID
curl http://localhost:3012/users/{id}
```

## Adding Cargo to PATH (Optional)

If you want to use `bacon` and other Cargo binaries without full paths, add this to your shell profile:

### For Zsh (default on macOS):
```bash
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### For Bash:
```bash
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
```

After adding Cargo to your PATH, you can update the package.json to use `bacon` instead of `$HOME/.cargo/bin/bacon`.

## Project Structure

```
users-service/
├── src/
│   └── main.rs          # Main application entry point
├── Cargo.toml           # Rust dependencies and metadata
├── Dockerfile           # Docker configuration
└── package.json         # npm scripts for convenience
```

## Notes

- This service uses `bacon` for hot-reloading during development, which is a modern alternative to `cargo-watch`
- The service is configured to work with pnpm, but you can also use npm or yarn
- Bacon provides a nice TUI (Terminal User Interface) that shows compilation errors in real-time
- The service runs on port 3012 by default (configurable via PORT environment variable)


# Shared Packages Guide

A comprehensive guide to using stack-specific shared packages in the bilo-repo polyglot monorepo.

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Architecture](#architecture)
- [Usage by Stack](#usage-by-stack)
- [Available Features](#available-features)
- [Starting Services](#starting-services)
- [Testing Integration](#testing-integration)
- [Creating New Packages](#creating-new-packages)
- [Troubleshooting](#troubleshooting)

---

## Overview

### Pattern

This monorepo uses **stack-specific shared packages** to enable code reuse across services within the same technology stack:

```
packages/
├── ts/           # TypeScript shared packages
├── cs/           # C# shared packages
├── go/           # Go shared packages
├── py/           # Python shared packages
└── rust/         # Rust shared packages
```

### Key Principles

- **Stack-specific organization**: Each language has its own `packages/<stack>/` directory
- **Native dependency management**: Use each stack's standard tools (pnpm, cargo, go modules, etc.)
- **Turborepo orchestration**: Turborepo handles builds and caching across all stacks
- **Type safety**: Full IDE support with native tooling

### Benefits

✅ **Native Tooling** - Use tools developers already know  
✅ **Type Safety** - Full IDE IntelliSense and autocomplete  
✅ **Hot Reload** - Changes reflected instantly  
✅ **Efficient Caching** - Turborepo caches builds across stacks  
✅ **Scalable** - Easy to add new packages  

---

## Quick Start

### TypeScript

```typescript
// 1. Add dependency to package.json
{
  "dependencies": {
    "@bilo-repo/ts-shared-utils": "workspace:*"
  }
}

// 2. Import and use
import { helloFromSharedUtils, createSuccessResponse } from '@bilo-repo/ts-shared-utils';
import type { ServiceResponse } from '@bilo-repo/ts-shared-utils';

const message = helloFromSharedUtils('my-service');
return createSuccessResponse({ message });

// 3. Install
// pnpm install
```

### C#

```csharp
<!-- 1. Add ProjectReference to .csproj -->
<ItemGroup>
  <ProjectReference Include="../../../packages/cs/SharedUtils/SharedUtils.csproj" />
</ItemGroup>

// 2. Import and use
using BiloRepo.SharedUtils;

var message = SharedGreeter.HelloFromSharedUtils("my-service");
var response = ResponseFactory.CreateSuccess(new { message });

// 3. Restore
// dotnet restore
```

### Go

```go
// 1. Add to go.mod
require github.com/bilolwabona/bilo-repo/packages/go/shared-utils v0.0.0
replace github.com/bilolwabona/bilo-repo/packages/go/shared-utils => ../../../packages/go/shared-utils

// 2. Import and use
import sharedutils "github.com/bilolwabona/bilo-repo/packages/go/shared-utils"

message := sharedutils.HelloFromSharedUtils("my-service")
response := sharedutils.CreateSuccessResponse(data)

// 3. Tidy
// go mod tidy
```

### Python

```python
# 1. Add to requirements.txt
-e ../../../packages/py/shared-utils

# 2. Import and use
from bilo_shared_utils import hello_from_shared_utils, create_success_response

message = hello_from_shared_utils("my-service")
response = create_success_response({"message": message})

# 3. Install
# pip install -r requirements.txt
```

### Rust

```rust
// 1. Add to Cargo.toml
[dependencies]
bilo-shared-utils = { path = "../../../packages/rust/shared-utils" }

// 2. Import and use
use bilo_shared_utils::{hello_from_shared_utils, create_success_response};

let message = hello_from_shared_utils("my-service");
let response = create_success_response(data);

// 3. Build
// cargo build
```

---

## Architecture

### Dependency Flow

```
Service declares dependency
         ↓
Native package manager resolves
         ↓
IDE provides IntelliSense
         ↓
Turborepo handles builds/caching
```

### Build Process

1. **Turborepo detects changes** in shared packages
2. **Builds shared packages first** (using `^build` dependency)
3. **Builds dependent services** after packages
4. **Caches outputs** for future builds

### Package Structure

```
packages/<stack>/<package-name>/
├── Source files (language-specific)
├── package.json (Turborepo orchestration)
└── README.md (Documentation)
```

---

## Usage by Stack

### TypeScript Services

**Package**: `@bilo-repo/ts-shared-utils`  
**Location**: `packages/ts/shared-utils/`

**Integration Steps:**

1. Add to `package.json`:
   ```json
   {
     "dependencies": {
       "@bilo-repo/ts-shared-utils": "workspace:*"
     }
   }
   ```

2. Import in code:
   ```typescript
   // Import values
   import { helloFromSharedUtils, createSuccessResponse } from '@bilo-repo/ts-shared-utils';
   
   // Import types separately (required for NestJS decorators)
   import type { ServiceResponse } from '@bilo-repo/ts-shared-utils';
   ```

3. Use in service:
   ```typescript
   @Get('/demo')
   getDemo(): ServiceResponse<{ message: string }> {
     const message = helloFromSharedUtils('auth-service');
     return createSuccessResponse({ message });
   }
   ```

4. Install: `pnpm install`

**Example Service**: `services/ts/auth-service`

---

### C# Services

**Package**: `BiloRepo.SharedUtils`  
**Location**: `packages/cs/SharedUtils/`

**Integration Steps:**

1. Add to `.csproj`:
   ```xml
   <ItemGroup>
     <ProjectReference Include="../../../packages/cs/SharedUtils/SharedUtils.csproj" />
   </ItemGroup>
   ```

2. Import in code:
   ```csharp
   using BiloRepo.SharedUtils;
   ```

3. Use in service:
   ```csharp
   app.MapGet("/demo", () =>
   {
       var message = SharedGreeter.HelloFromSharedUtils("analytics-service");
       var response = ResponseFactory.CreateSuccess(new { message });
       return Results.Ok(response);
   });
   ```

4. Restore: `dotnet restore`

**Example Service**: `services/cs/reporting-service`

---

### Go Services

**Package**: `github.com/bilolwabona/bilo-repo/packages/go/shared-utils`  
**Location**: `packages/go/shared-utils/`

**Integration Steps:**

1. Add to `go.mod`:
   ```go
   require (
       github.com/bilolwabona/bilo-repo/packages/go/shared-utils v0.0.0
   )
   
   replace github.com/bilolwabona/bilo-repo/packages/go/shared-utils => ../../../packages/go/shared-utils
   ```

2. Import in code:
   ```go
   import sharedutils "github.com/bilolwabona/bilo-repo/packages/go/shared-utils"
   ```

3. Use in service:
   ```go
   app.Get("/demo", func(c *fiber.Ctx) error {
       message := sharedutils.HelloFromSharedUtils("funds-service")
       response := sharedutils.CreateSuccessResponse(fiber.Map{
           "message": message,
       })
       return c.JSON(response)
   })
   ```

4. Tidy: `go mod tidy`

**Example Service**: `services/go/funds-service`

---

### Python Services

**Package**: `bilo-shared-utils`  
**Location**: `packages/py/shared-utils/`

**Integration Steps:**

1. Add to `requirements.txt`:
   ```txt
   -e ../../../packages/py/shared-utils
   ```

2. Import in code:
   ```python
   from bilo_shared_utils import (
       hello_from_shared_utils,
       create_success_response,
       ServiceResponse
   )
   ```

3. Use in service:
   ```python
   @app.get("/demo")
   async def demo():
       message = hello_from_shared_utils("calculator-service")
       response = create_success_response({"message": message})
       return response
   ```

4. Install: `pip install -r requirements.txt`

**Example Service**: `services/py/calculator-service`

---

### Rust Services

**Package**: `bilo-shared-utils`  
**Location**: `packages/rust/shared-utils/`

**Integration Steps:**

1. Add to `Cargo.toml`:
   ```toml
   [dependencies]
   bilo-shared-utils = { path = "../../../packages/rust/shared-utils" }
   ```

2. Import in code:
   ```rust
   use bilo_shared_utils::{hello_from_shared_utils, create_success_response};
   ```

3. Use in service:
   ```rust
   #[get("/demo")]
   async fn demo() -> impl Responder {
       let message = hello_from_shared_utils("messaging-service");
       let data = serde_json::json!({ "message": message });
       let response = create_success_response(data);
       HttpResponse::Ok().json(response)
   }
   ```

4. Build: `cargo build`

**Example Service**: `services/rust/messaging-service`

---

## Available Features

All shared-utils packages provide:

### Greeting Function

Returns a formatted greeting message.

- **TypeScript**: `helloFromSharedUtils(serviceName: string): string`
- **C#**: `SharedGreeter.HelloFromSharedUtils(string serviceName)`
- **Go**: `HelloFromSharedUtils(serviceName string) string`
- **Python**: `hello_from_shared_utils(service_name: str) -> str`
- **Rust**: `hello_from_shared_utils(service_name: &str) -> String`

### Timestamp Formatting

Formats timestamps in ISO 8601 format.

- **TypeScript**: `formatTimestamp(date?: Date): string`
- **C#**: `SharedGreeter.FormatTimestamp(DateTime? dateTime)`
- **Go**: `FormatTimestamp(t *time.Time) string`
- **Python**: `format_timestamp(dt: Optional[datetime]) -> str`
- **Rust**: `format_timestamp(dt: Option<DateTime<Utc>>) -> String`

### Standard Response Type

Generic response structure with type safety.

```typescript
// TypeScript
interface ServiceResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
  timestamp: string;
}
```

Available in all stacks with equivalent types.

### Response Factory Functions

**Success Response:**
- **TypeScript**: `createSuccessResponse<T>(data: T): ServiceResponse<T>`
- **C#**: `ResponseFactory.CreateSuccess<T>(T data)`
- **Go**: `CreateSuccessResponse(data interface{}) ServiceResponse`
- **Python**: `create_success_response(data: Any) -> ServiceResponse`
- **Rust**: `create_success_response<T>(data: T) -> ServiceResponse<T>`

**Error Response:**
- **TypeScript**: `createErrorResponse(error: string): ServiceResponse`
- **C#**: `ResponseFactory.CreateError(string error)`
- **Go**: `CreateErrorResponse(errorMsg string) ServiceResponse`
- **Python**: `create_error_response(error: str) -> ServiceResponse`
- **Rust**: `create_error_response(error: String) -> ServiceResponse<Value>`

---

## Starting Services

### All Services (Recommended)

```bash
# From repository root
pnpm dev
```

### Individual Services

**TypeScript:**
```bash
cd services/ts/auth-service && pnpm dev
```

**C#:**
```bash
cd services/cs/reporting-service && dotnet run
```

**Go:**
```bash
cd services/go/funds-service && go run main.go
```

**Python:**
```bash
cd services/py/calculator-service && python main.py
```

**Rust:**
```bash
cd services/rust/messaging-service && cargo run
```

### Service Ports

| Service              | Port | Stack      |
|---------------------|------|------------|
| auth-service        | 3001 | TypeScript |
| reporting-service   | 3201 | C#         |
| funds-service       | 3101 | Go         |
| calculator-service  | 3010 | Python     |
| messaging-service   | 3009 | Rust       |

---

## Testing Integration

### Demo Endpoints

All integrated services have a `/shared-utils-demo` endpoint:

```bash
# TypeScript
curl http://localhost:3001/shared-utils-demo

# C#
curl http://localhost:3201/shared-utils-demo

# Go
curl http://localhost:3101/shared-utils-demo

# Python
curl http://localhost:3010/shared-utils-demo

# Rust
curl http://localhost:3009/shared-utils-demo
```

### Expected Response

```json
{
  "success": true,
  "data": {
    "message": "Hello from <Stack> shared-utils! Called by: <service-name>"
  },
  "timestamp": "2025-10-29T..."
}
```

---

## Creating New Packages

### TypeScript

```bash
mkdir -p packages/ts/my-package/src
cd packages/ts/my-package

# Create package.json
cat > package.json <<EOF
{
  "name": "@bilo-repo/ts-my-package",
  "version": "1.0.0",
  "main": "./src/index.ts",
  "scripts": {
    "build": "tsc"
  }
}
EOF

# Create source file
cat > src/index.ts <<EOF
export function myFunction() {
  return "Hello from my package!";
}
EOF
```

### C#

```bash
mkdir -p packages/cs/MyPackage
cd packages/cs/MyPackage

# Create project
dotnet new classlib

# Add package.json for Turborepo
cat > package.json <<EOF
{
  "name": "@bilo-repo/cs-my-package",
  "version": "1.0.0",
  "scripts": {
    "build": "dotnet build"
  }
}
EOF
```

### Go

```bash
mkdir -p packages/go/my-package
cd packages/go/my-package

# Initialize module
go mod init github.com/bilolwabona/bilo-repo/packages/go/my-package

# Create source file
cat > mypackage.go <<EOF
package mypackage

func MyFunction() string {
    return "Hello from my package!"
}
EOF

# Add package.json for Turborepo
cat > package.json <<EOF
{
  "name": "@bilo-repo/go-my-package",
  "version": "1.0.0",
  "scripts": {
    "build": "go build ./..."
  }
}
EOF
```

### Python

```bash
mkdir -p packages/py/my-package/bilo_my_package
cd packages/py/my-package

# Create setup.py
cat > setup.py <<EOF
from setuptools import setup, find_packages

setup(
    name="bilo-my-package",
    version="1.0.0",
    packages=find_packages(),
)
EOF

# Create package
cat > bilo_my_package/__init__.py <<EOF
def my_function():
    return "Hello from my package!"
EOF

# Add package.json for Turborepo
cat > package.json <<EOF
{
  "name": "@bilo-repo/py-my-package",
  "version": "1.0.0",
  "scripts": {
    "build": "python -m pip install -e ."
  }
}
EOF
```

### Rust

```bash
mkdir -p packages/rust/my-package
cd packages/rust/my-package

# Initialize library
cargo init --lib

# Add package.json for Turborepo
cat > package.json <<EOF
{
  "name": "@bilo-repo/rust-my-package",
  "version": "1.0.0",
  "scripts": {
    "build": "cargo build --release"
  }
}
EOF
```

---

## Troubleshooting

### TypeScript: "Cannot find module"

```bash
cd services/ts/<service-name>
pnpm install
pnpm build
```

**Common Issue**: Type imports in NestJS decorators

```typescript
// ❌ Wrong
import { ServiceResponse } from '@bilo-repo/ts-shared-utils';

// ✅ Correct
import type { ServiceResponse } from '@bilo-repo/ts-shared-utils';
```

### C#: "The type or namespace could not be found"

```bash
cd services/cs/<service-name>
dotnet restore
dotnet build
```

### Go: "no required module provides package"

```bash
cd services/go/<service-name>
go mod tidy
go build
```

### Python: "No module named 'bilo_shared_utils'"

```bash
cd services/py/<service-name>
pip install -e ../../../packages/py/shared-utils
```

### Rust: "can't find crate"

```bash
cd services/rust/<service-name>
cargo update
cargo build
```

### Port Already in Use

```bash
# Find and kill process
lsof -ti:3001 | xargs kill -9

# Or set different port
export PORT=3099
```

---

## Implementation Details

### What Was Built

**Shared Packages Created:**
- `packages/ts/shared-utils/` - TypeScript utilities
- `packages/cs/SharedUtils/` - C# utilities
- `packages/go/shared-utils/` - Go utilities
- `packages/py/shared-utils/` - Python utilities
- `packages/rust/shared-utils/` - Rust utilities

**Services Integrated:**
- `services/ts/auth-service` - TypeScript demo
- `services/cs/reporting-service` - C# demo
- `services/go/funds-service` - Go demo
- `services/py/calculator-service` - Python demo
- `services/rust/messaging-service` - Rust demo

**Configuration Updated:**
- `pnpm-workspace.yaml` - Added package patterns
- `turbo.json` - Added build outputs for all stacks

### Dependency Management

Each stack uses its native tools:

| Stack      | Tool                    | Mechanism                |
|------------|-------------------------|--------------------------|
| TypeScript | pnpm workspaces         | `workspace:*`            |
| C#         | MSBuild                 | `<ProjectReference>`     |
| Go         | Go modules              | `replace` directive      |
| Python     | pip                     | Editable install `-e`    |
| Rust       | Cargo                   | `path` dependency        |

### Turborepo Integration

Each shared package includes `package.json` with scripts:

```json
{
  "name": "@bilo-repo/<stack>-<package>",
  "version": "1.0.0",
  "scripts": {
    "build": "<stack-specific-build-command>"
  }
}
```

This enables:
- Cross-stack build orchestration
- Unified caching
- Dependency tracking
- Parallel execution

---

## Best Practices

### Do's ✅

- Use `workspace:*` for TypeScript packages
- Use `import type` for TypeScript type-only imports
- Use relative paths for local packages
- Add `package.json` to all packages for Turborepo
- Keep shared packages focused and single-purpose
- Document exported functions and types
- Version packages consistently

### Don'ts ❌

- Don't mix stacks in a single package
- Don't use absolute imports for local packages
- Don't skip Turborepo orchestration files
- Don't create circular dependencies
- Don't include service-specific logic in shared packages
- Don't forget to run install/restore commands

---

## Next Steps

1. **Expand utilities**: Add authentication, logging, validation helpers
2. **Create domain packages**: Add `packages/ts/carbon-models` for shared types
3. **Add configurations**: Shared ESLint, TypeScript, Prettier configs
4. **Cross-stack contracts**: Consider Protocol Buffers or OpenAPI
5. **Testing infrastructure**: Add shared testing utilities per stack

---

**Last Updated**: October 29, 2025  
**Status**: ✅ Production Ready

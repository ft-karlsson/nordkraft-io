# Nordkraft CLI

> Zero-trust container cloud management made simple

> [!WARNING]  
> **🚧 Active Development Notice**  
> Nordkraft CLI is currently in active development and friendly user testing phase. This tool is **not yet ready for production use**. Features may change, and breaking changes can occur between releases. Use at your own risk and expect potential instability.
> 
> For production workloads, please wait for the stable v1.0.0 release.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Latest Release](https://img.shields.io/github/v/release/ft-karlsson/nordkraft-io)](https://github.com/ft-karlsson/nordkraft-io/releases/latest)
[![Platform Support](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey)](https://github.com/ft-karlsson/nordkraft-io/releases/latest)
[![Development Status](https://img.shields.io/badge/status-alpha-orange)](https://github.com/ft-karlsson/nordkraft-io)

Nordkraft CLI provides secure, zero-trust access to container cloud infrastructure. Deploy, manage, and scale containers through an encrypted WireGuard tunnel with built-in authentication.

## ⚡ Quick Start

### One-Command Installation
#### macOS
```bash
curl -fsSL https://get.nordkraft.io/install.sh | sh
```

#### linux
```bash
bash <(curl -fsSL https://get.nordkraft.io/install.sh)
```

### Alternative Installation Methods

<details>
<summary>Manual Download</summary>

Download the binary for your platform from the [latest release](https://github.com/ft-karlsson/nordkraft-io/releases/latest):

- **macOS (Apple Silicon)**: `nordkraft-darwin-arm64.tar.gz`
- **macOS (Intel)**: `nordkraft-darwin-amd64.tar.gz` 
- **Linux (AMD64)**: `nordkraft-linux-amd64.tar.gz`

```bash
# Extract and install
tar -xzf nordkraft-*.tar.gz
sudo mv nordkraft /usr/local/bin/
```

</details>

## 🚀 Usage

### Authentication

```bash
# Test your zero-trust connection
nordkraft auth login

# Check connection status
nordkraft auth status
```

### Container Management

```bash
# List your containers
nordkraft container list

# Deploy a new container
nordkraft container deploy --image nginx:alpine --port 8080

# Stop a container
nordkraft container stop <container-id>

# Delete a container
nordkraft container delete <container-id>
```

### Help & Documentation

```bash
# Show all available commands
nordkraft help

# Command-specific help
nordkraft container --help
```

## 🔧 Prerequisites

- **WireGuard VPN** connection configured
- **Valid Nordkraft account** with appropriate permissions
- **macOS 10.15+** or **Linux** (x86_64)

## 🛡️ Security

Nordkraft CLI implements zero-trust architecture:

- ✅ **End-to-end encryption** via WireGuard
- ✅ **No direct internet exposure** of container APIs
- ✅ **Authentication required** for all operations
- ✅ **Role-based permissions** system
- ✅ **Network isolation** between clients

## 📖 Documentation

- [Getting Started Guide](https://docs.nordkraft.io)
- [WireGuard Setup](https://docs.nordkraft.io/wireguard)
- [API Reference](https://docs.nordkraft.io/api)
- [Security Architecture](https://docs.nordkraft.io/security)

## 🐛 Support

- [Report Issues](https://github.com/ft-karlsson/nordkraft-io/issues)
- [Feature Requests](https://github.com/ft-karlsson/nordkraft-io/discussions)
- [Community Discussion](https://github.com/ft-karlsson/nordkraft-io/discussions)

## 📝 Example Workflow

```bash
# 1. Verify connection
nordkraft auth login
# ✓ Sikker forbindelse etableret til Frederik!

# 2. Deploy a web application
nordkraft container deploy --image nginx:alpine --port 8080
# ✓ Container deployed successfully

# 3. List running containers
nordkraft container list
# 📦 Your containers:
# abc123 | nginx:alpine | Running on port 8080

# 4. Clean up when done
nordkraft container delete abc123
# ✓ Container deleted successfully
```

## 🔄 Updates

The CLI automatically checks for updates. To manually update:

```bash
curl -fsSL https://get.nordkraft.io/install.sh | sh
```

## 🏗️ Platform Support

| Platform | Architecture | Status |
|----------|-------------|---------|
| macOS | Apple Silicon (M1/M2) | ✅ Supported |
| macOS | Intel (x86_64) | ✅ Supported |
| Linux | AMD64 (x86_64) | ✅ Supported |
| Windows | AMD64 | 🔄 Coming Soon |

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">
  <strong>Built with 🦀 Rust for performance and security</strong>
</div>

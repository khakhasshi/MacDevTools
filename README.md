<p align="center">
  <img src="https://img.icons8.com/color/96/000000/console.png" alt="MacDevTools Logo"/>
</p>

<h1 align="center">MacDevTools</h1>

<p align="center">
  <strong>🛠️ macOS Terminal Toolkit - All-in-One System Maintenance & Development Tools</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/platform-macOS-blue?style=flat-square&logo=apple" alt="Platform">
  <img src="https://img.shields.io/badge/shell-bash-green?style=flat-square&logo=gnu-bash" alt="Shell">
  <img src="https://img.shields.io/badge/version-1.2.0-orange?style=flat-square" alt="Version">
  <img src="https://img.shields.io/badge/license-MIT-purple?style=flat-square" alt="License">
  <img src="https://img.shields.io/badge/PRs-welcome-brightgreen?style=flat-square" alt="PRs Welcome">
</p>

<p align="center">
  <b>👤 Author:</b> JIANGJINGZHE (江景哲)<br>
  <b>📧 Email:</b> <a href="mailto:contact@jiangjingzhe.com">contact@jiangjingzhe.com</a><br>
  <b>💬 WeChat:</b> jiangjingzhe_2004
</p>

<p align="center">
  English | <a href="./README_CN.md">简体中文</a>
</p>

<p align="center">
  <a href="#-features">Features</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-usage">Usage</a> •
  <a href="#-tools">Tools</a> •
  <a href="#-screenshots">Screenshots</a> •
  <a href="#-contributing">Contributing</a>
</p>

---

## ✨ Features

- 🎨 **Beautiful TUI Interface** - ASCII Art Logo + Colorful Interactive Menu
- ⚡ **One-Click Cleanup** - Quickly clean all development environment caches
- 🔧 **Modular Design** - Each tool runs independently
- 🌐 **Global Command** - Type `tool` anywhere to launch
- 📦 **Multi Package Manager Support** - Homebrew, pip, npm, pnpm, yarn, etc.
- 🔍 **Network Diagnostics** - Comprehensive network connection checks
- 🔌 **Port Management** - Quickly view and release occupied ports

## 📦 Supported Tools

| Category | Tool | Description |
|:---:|:---|:---|
| 🍺 | Homebrew | Clean download cache, old versions |
| 🐍 | pip | Clean pip cache, wheel cache |
| 📦 | npm/pnpm/yarn | Clean Node.js package manager caches |
| 🔨 | Xcode | Clean DerivedData, simulators, build cache |
| 🐳 | Docker | Clean images, containers, volumes, build cache |
| 🐹 | Go | Clean module cache, build cache |
| 🦀 | Cargo | Clean Rust registry, Git cache |
| 💎 | Ruby Gems | Clean gem cache, old versions |
| 🎮 | Steam | Clean Steam download/app/http cache |
| 📺 | Apple TV | Clean Apple TV app caches/download cache |
| 🪶 | Maven | Clean ~/.m2 local repository, stale metadata |
| 🐘 | Gradle | Clean build cache, daemon logs, wrapper dists |
| 🌐 | DNS Lookup | Resolve domain nameserver IPv4 |
| 🌐 | Network | Network diagnostics, DNS check |
| 🔌 | Port | Port usage viewer & process manager |
| 📋 | Log Cleanup | Clean app/system/crash/sim log files |
| 💾 | Disk Usage | Analyze disk hotspots & largest files |
| 📦 | Outdated | Check outdated packages across all managers |
| 🔐 | SSL Check | Inspect SSL cert expiry, SANs, TLS version |

## 🚀 Installation

### Install via Homebrew (Recommended)

```bash
brew install khakhasshi/tap/macdevtools
```

Or:

```bash
brew tap khakhasshi/tap
brew install macdevtools
```

After installation, run `tool` to start.

### Manual Install

```bash
# Clone repository to MacDevTools directory
git clone https://github.com/khakhasshi/MacDevTools.git ~/MacDevTools

# Add to PATH (auto-write to .zshrc)
echo 'export PATH="$HOME/MacDevTools:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Verify installation
tool help
```

## 📖 Usage

### Interactive Menu

```bash
tool
```

Launch to see a beautiful TUI interface, use number keys to select functions:

```
    __  ___           ____           ______            __    
     /  |/  /___ ______/ __ \___ _   _/_  __/___  ____  / /____
    / /|_/ / __ `/ ___/ / / / _ \ | / // / / __ \/ __ \/ / ___/
   / /  / / /_/ / /__/ /_/ /  __/ |/ // / / /_/ / /_/ / (__  ) 
  /_/  /_/\__,_/\___/_____/\___/|___//_/  \____/\____/_/____/  

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
              🛠️  Terminal Toolkit v1.2  |  macOS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 Cache Cleanup
     1) Homebrew Cache Cleanup
     2) pip Cache Cleanup
     3) npm/pnpm/yarn Cache Cleanup
     ...
```

### Command Line Mode

Execute specific functions directly without entering the menu:

```bash
# Cache Cleanup
tool brew          # Clean Homebrew cache
tool pip           # Clean pip cache
tool node          # Clean npm/pnpm/yarn cache
tool xcode         # Clean Xcode cache
tool docker        # Clean Docker cache
tool steam         # Clean Steam download cache
tool appletv       # Clean Apple TV cache
tool go            # Clean Go module cache
tool cargo         # Clean Cargo cache
tool gem           # Clean Ruby Gems cache
tool maven         # Clean Maven local repository
tool gradle        # Clean Gradle cache
tool dns example.com  # Lookup domain NS IPv4

# System Tools
tool network       # Network connection check
tool port 3000     # View port 3000 usage
tool port -k 8080  # Kill process using port 8080
tool port -l       # List all listening ports
tool port -c       # Check common dev ports
tool logs          # Clean log files
tool disk          # Analyze disk usage
tool outdated      # Check outdated packages
tool ssl github.com  # Check SSL certificate

# Quick Actions
tool all           # One-click clean all caches
tool help          # Show help
```

## 🔧 Tool Details

### 1. Homebrew Cache Cleanup (`clean_brew_cache.sh`)

```bash
tool brew
```

**Features:**
- ✅ Clean download cache
- ✅ Remove old software versions
- ✅ Deep clean all cache files
- ✅ Show before/after space comparison

---

### 2. pip Cache Cleanup (`clean_pip_cache.sh`)

```bash
tool pip
```

**Features:**
- ✅ Clean pip download cache
- ✅ Clean wheel cache
- ✅ Clean http cache
- ✅ Support macOS specific paths

---

### 3. Node.js Cache Cleanup (`clean_node_cache.sh`)

```bash
tool node
```

**Features:**
- ✅ npm cache clean
- ✅ pnpm store prune
- ✅ yarn cache clean
- ✅ Clean /tmp temporary files

---

### 4. Xcode Cache Cleanup (`clean_xcode_cache.sh`)

```bash
tool xcode
```

**Features:**
- ✅ Clean DerivedData (build artifacts)
- ✅ Clean module cache
- ✅ Clean LLVM/SPM cache
- ✅ Delete unavailable simulators
- ✅ Clean Playground cache
- ⚠️ Optional: Clean DeviceSupport/Archives

---

### 5. Docker Cache Cleanup (`clean_docker_cache.sh`)

```bash
tool docker
```

**Features:**
- ✅ Remove stopped containers
- ✅ Remove dangling images
- ✅ Remove unused volumes and networks
- ✅ Clean build cache
- ⚠️ Optional: Deep clean (remove all unused resources)

---

### 6. Go Cache Cleanup (`clean_go_cache.sh`)

```bash
tool go
```

**Features:**
- ✅ Clean build cache
- ✅ Clean test cache
- ✅ Clean fuzz test cache
- ⚠️ Optional: Clean module cache

---

### 7. Cargo Cache Cleanup (`clean_cargo_cache.sh`)

```bash
tool cargo
```

**Features:**
- ✅ Clean registry cache
- ✅ Clean Git checkouts
- ✅ Clean Git database
- ⚠️ Optional: Clean all target directories

---

### 8. Ruby Gems Cache Cleanup (`clean_gem_cache.sh`)

```bash
tool gem
```

**Features:**
- ✅ Clean gem cache
- ✅ Remove old gem versions
- ✅ Clean Bundler cache
- ✅ Support rbenv/rvm
- ⚠️ Optional: Clean CocoaPods cache

---

### 9. Steam Download Cache Cleanup (`clean_steam_cache.sh`)

```bash
tool steam
```

**Features:**
- ✅ Clean Steam download cache
- ✅ Clean app/http/depot caches
- ✅ Remove partial download markers
- ⚠️ Recommend quitting Steam before cleaning

---

### 10. DNS Nameserver Lookup (`dns_lookup.sh`)

```bash
tool dns example.com
```

**Features:**
- ✅ List NS records for a domain
- ✅ Resolve each nameserver's IPv4 (and show IPv6 if available)
- ⚠️ Requires `dig` (macOS has it by default)

---

### 11. Network Connection Check (`check_network.sh`)

```bash
tool network
```

**Features:**
- ✅ Check network interface status
- ✅ Test gateway connection
- ✅ DNS resolution test
- ✅ Ping test (Google/Cloudflare/Alibaba)
- ✅ HTTP/HTTPS connection test
- ✅ Dev service check (npm/PyPI/Docker Hub)
- ✅ Local port listening check
- ⚠️ Optional: Network speed test

---

### 12. Port Killer (`port_killer.sh`)

---

### 13. Apple TV Cache Cleanup (`clean_appletv_cache.sh`)

```bash
tool appletv
```

**Features:**
- ✅ Clean Apple TV app caches and download cache
- ✅ Clear group container caches
- ⚠️ Recommend quitting Apple TV app before cleaning

```bash
tool port [options] [port]
```

**Options:**
| Option | Description |
|:---|:---|
| `tool port 3000` | View port 3000 usage details |
| `tool port -k 8080` | Kill process using port 8080 |
| `tool port -l` | List all listening ports |
| `tool port -c` | Show common dev port status |

**Features:**
- ✅ View port usage details (process name, PID, CPU, memory)
- ✅ One-click kill process
- ✅ Support force terminate
- ✅ Quick check common ports

### 11. Maven Local Repository Cleanup (`clean_maven_cache.sh`)

```bash
tool maven
```

**Features:**
- ✅ Remove all `-SNAPSHOT` artifacts
- ✅ Delete stale `_remote.repositories` and `*.lastUpdated` metadata
- ✅ Remove zero-byte / incomplete downloads
- ✅ Optional: delete artifacts not accessed in >90 days
- ✅ Optional: clean old Maven wrapper distributions

---

### 12. Gradle Cache Cleanup (`clean_gradle_cache.sh`)

```bash
tool gradle
```

**Features:**
- ✅ Remove Gradle build cache
- ✅ Delete old versioned module caches
- ✅ Remove daemon logs and registry files
- ✅ Optional: delete JAR artifacts unused >60 days
- ✅ Optional: clean old wrapper distribution zips
- ✅ Optional: clean project-level `.gradle` directories

---

### 13. Log File Cleanup (`clean_logs.sh`)

```bash
tool logs
```

**Features:**
- ✅ Clean app logs in `~/Library/Logs` (>7 days old)
- ✅ Delete crash reports and diagnostic `.ips` files
- ✅ Clean iOS Simulator logs
- ✅ Remove rotated/compressed `/var/log` entries
- ✅ Clean developer tool log directories (npm, pip, yarn, Gradle)

---

### 14. Disk Usage Analyzer (`disk_usage.sh`)

```bash
tool disk
```

**Features:**
- ✅ Show overall disk usage for all mounted volumes
- ✅ Break down home directory by subdirectory size
- ✅ Find top 20 largest files in `~`
- ✅ Report known developer cache hotspots
- ✅ Show largest files in `/tmp` and `~/Downloads`

---

### 15. Package Outdated Checker (`pkg_outdated.sh`)

```bash
tool outdated
```

**Features:**
- ✅ Check Homebrew formulae and casks
- ✅ Check pip packages
- ✅ Check global npm / pnpm / yarn packages
- ✅ Check Ruby gems
- ✅ Check cargo-installed binaries (via `cargo-update`)
- ✅ Check macOS system software updates
- ✅ Print one-liner update commands in the summary

---

### 16. SSL Certificate Checker (`ssl_check.sh`)

```bash
tool ssl github.com
tool ssl github.com example.com:8443
```

**Features:**
- ✅ Show certificate subject, issuer, serial, key algorithm
- ✅ Display all Subject Alternative Names (SANs)
- ✅ Days-until-expiry with color-coded warnings (<14 / <30 days)
- ✅ Check negotiated TLS version
- ✅ Verify certificate chain trust
- ✅ Accept domain:port syntax; interactive mode with no arguments

---

## 📁 Directory Structure

```
~/MacDevTools/
├── tool                    # Main entry (global command)
├── clean_brew_cache.sh     # Homebrew cache cleanup
├── clean_pip_cache.sh      # pip cache cleanup
├── clean_node_cache.sh     # Node.js cache cleanup
├── clean_xcode_cache.sh    # Xcode cache cleanup
├── clean_docker_cache.sh   # Docker cache cleanup
├── clean_go_cache.sh       # Go cache cleanup
├── clean_cargo_cache.sh    # Cargo cache cleanup
├── clean_gem_cache.sh      # Ruby Gems cache cleanup
├── clean_steam_cache.sh    # Steam download cache cleanup
├── clean_appletv_cache.sh  # Apple TV cache cleanup
├── clean_maven_cache.sh    # Maven local repository cleanup
├── clean_gradle_cache.sh   # Gradle cache cleanup
├── clean_logs.sh           # Log file cleanup
├── disk_usage.sh           # Disk usage analyzer
├── pkg_outdated.sh         # Package outdated checker
├── ssl_check.sh            # SSL certificate checker
├── dns_lookup.sh           # DNS nameserver IPv4 lookup
├── check_network.sh        # Network connection check
├── port_killer.sh          # Port killer
├── fake_busy_build.sh      # Fake busy build simulator
├── README.md               # English documentation
└── README_CN.md            # Chinese documentation
```

## 🖼️ Screenshots

<details>
<summary>Click to expand screenshots</summary>

### Main Menu
```
    __  ___           ____           ______            __    
     /  |/  /___ ______/ __ \___ _   _/_  __/___  ____  / /____
    / /|_/ / __ `/ ___/ / / / _ \ | / // / / __ \/ __ \/ / ___/
   / /  / / /_/ / /__/ /_/ /  __/ |/ // / / /_/ / /_/ / (__  ) 
  /_/  /_/\__,_/\___/_____/\___/|___//_/  \____/\____/_/____/  

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
              🛠️  Terminal Toolkit v1.2  |  macOS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 Cache Cleanup
     1) Homebrew Cache Cleanup
     2) pip Cache Cleanup
     3) npm/pnpm/yarn Cache Cleanup
     4) Xcode Cache Cleanup
     5) Docker Cache Cleanup
     6) Go Cache Cleanup
     7) Cargo Cache Cleanup
     8) Ruby Gems Cache Cleanup
     9) Steam Download Cache Cleanup
     10) Apple TV Cache Cleanup
     11) Maven Local Repository Cleanup
     12) Gradle Cache Cleanup

  🔧 System Tools
     13) Network Connection Check
     14) DNS Nameserver Lookup
     15) Port Usage Killer
     16) Busy Build Simulator
     17) Log File Cleanup
     18) Disk Usage Analyzer
     19) Package Outdated Checker
     20) SSL Certificate Checker
     13) Port Killer

  ⚡ Quick Actions
     a) One-Click Clean All
     l) List All Listening Ports
     c) Check Common Ports

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     h) Help    q) Quit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Network Check
```
🌐 Network Connection Check Tool
===================

📡 Network Interface Status:
   ✓ Active Interface: en0
   ✓ Local IP: 192.168.1.100

🚪 Gateway Connection:
   Gateway: 192.168.1.1
   ✓ Gateway reachable

🔍 DNS Resolution:
   ✓ google.com → 142.250.xx.xx
   ✓ baidu.com → 220.181.xx.xx
   ✓ github.com → 20.205.xx.xx

🌍 Internet Connection:
   ✓ Google DNS (8.8.8.8): 25ms
   ✓ Cloudflare (1.1.1.1): 18ms
   ✓ Alibaba DNS (223.5.5.5): 12ms
```

### Port Killer
```
🔌 Port Killer Tool

🔍 Checking port 3000

⚠ Port 3000 is occupied

COMMAND   PID   USER   FD   TYPE   DEVICE   SIZE/OFF   NODE   NAME
node      1234  user   23u  IPv4   0x...    0t0        TCP    *:3000 (LISTEN)

Process Details:
   PID: 1234
   Name: node
   User: user
   CPU:  2.5%
   Memory: 1.2%
   Command: node /path/to/server.js

Kill this process? (y/N):
```

</details>

## ❓ FAQ

### Q: How to update MacDevTools?

```bash
cd ~/MacDevTools
git pull origin main
```

### Q: How to add custom tools?

1. Create a new `.sh` file in `~/MacDevTools/`
2. Add execute permission: `chmod +x your_script.sh`
3. Edit the `tool` file to add menu options

### Q: Some tools require sudo?

Some system-level operations require administrator privileges. The script will prompt when needed.

### Q: How to uninstall?

```bash
# Remove directory
rm -rf ~/MacDevTools

# Remove PATH config (edit .zshrc to remove related lines)
nano ~/.zshrc
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork this repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2026 JIANGJINGZHE (江景哲)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

<p align="center">
  Made with ❤️ by <a href="mailto:contact@jiangjingzhe.com">JIANGJINGZHE</a>
</p>

<p align="center">
  <a href="#macdevtools">⬆️ Back to Top</a>
</p>

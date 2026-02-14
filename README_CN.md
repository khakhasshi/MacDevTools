<p align="center">
  <img src="https://img.icons8.com/color/96/000000/console.png" alt="MacDevTools Logo"/>
</p>

<h1 align="center">MacDevTools</h1>

<p align="center">
  <strong>🛠️ macOS 终端工具集 - 一站式系统维护与开发辅助工具</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/platform-macOS-blue?style=flat-square&logo=apple" alt="Platform">
  <img src="https://img.shields.io/badge/shell-bash-green?style=flat-square&logo=gnu-bash" alt="Shell">
  <img src="https://img.shields.io/badge/version-1.0.0-orange?style=flat-square" alt="Version">
  <img src="https://img.shields.io/badge/license-MIT-purple?style=flat-square" alt="License">
  <img src="https://img.shields.io/badge/PRs-welcome-brightgreen?style=flat-square" alt="PRs Welcome">
</p>

<p align="center">
  <b>👤 作者 / Author:</b> 江景哲 (JIANGJINGZHE)<br>
  <b>📧 邮箱 / Email:</b> <a href="mailto:contact@jiangjingzhe.com">contact@jiangjingzhe.com</a><br>
  <b>💬 微信 / WeChat:</b> jiangjingzhe_2004
</p>

<p align="center">
  <a href="./README.md">English</a> | 简体中文
</p>

<p align="center">
  <a href="#-功能特性">功能特性</a> •
  <a href="#-安装">安装</a> •
  <a href="#-使用方法">使用方法</a> •
  <a href="#-工具列表">工具列表</a> •
  <a href="#-截图">截图</a> •
  <a href="#-贡献">贡献</a>
</p>

---

## ✨ 功能特性

- 🎨 **精美 TUI 界面** - ASCII Art Logo + 彩色交互式菜单
- ⚡ **一键清理** - 快速清理所有开发环境缓存
- 🔧 **模块化设计** - 每个工具独立运行，互不干扰
- 🌐 **全局命令** - 任意位置输入 `tool` 即可启动
- 📦 **多包管理器支持** - Homebrew、pip、npm、pnpm、yarn 等
- 🔍 **网络诊断** - 全面的网络连接检查
- 🔌 **端口管理** - 快速查看和释放被占用的端口

## 📦 支持的工具

| 类别 | 工具 | 描述 |
|:---:|:---|:---|
| 🍺 | Homebrew | 清理下载缓存、旧版本软件包 |
| 🐍 | pip | 清理 pip 缓存、wheel 缓存 |
| 📦 | npm/pnpm/yarn | 清理 Node.js 包管理器缓存 |
| 🔨 | Xcode | 清理 DerivedData、模拟器、构建缓存 |
| 🐳 | Docker | 清理镜像、容器、卷、构建缓存 |
| 🐹 | Go | 清理模块缓存、构建缓存 |
| 🦀 | Cargo | 清理 Rust 注册表、Git 缓存 |
| 💎 | Ruby Gems | 清理 gem 缓存、旧版本 |
| 🎮 | Steam | 清理 Steam 下载 / app / http 缓存 |
| 🌐 | DNS Lookup | 查询域名的 NS IPv4 |
| 🌐 | Network | 网络连接诊断、DNS 检查 |
| 🔌 | Port | 端口占用查看与进程管理 |

## 🚀 安装

### 通过 Homebrew 安装（推荐）

```bash
brew install khakhasshi/tap/shelltools
```

或者：

```bash
brew tap khakhasshi/tap
brew install shelltools
```

安装完成后，运行 `tool` 即可启动。

### 手动安装

```bash
# 克隆仓库到 MacDevTools 目录
git clone https://github.com/khakhasshi/MacDevTools.git ~/MacDevTools

# 添加到 PATH（自动写入 .zshrc）
echo 'export PATH="$HOME/MacDevTools:$PATH"' >> ~/.zshrc
source ~/.zshrc

# 验证安装
tool help
```

## 📖 使用方法

### 交互式菜单

```bash
tool
```

启动后将显示精美的 TUI 界面，使用数字键选择对应功能：

```
    __  ___           ____           ______            __    
     /  |/  /___ ______/ __ \___ _   _/_  __/___  ____  / /____
    / /|_/ / __ `/ ___/ / / / _ \ | / // / / __ \/ __ \/ / ___/
   / /  / / /_/ / /__/ /_/ /  __/ |/ // / / /_/ / /_/ / (__  ) 
  /_/  /_/\__,_/\___/_____/\___/|___//_/  \____/\____/_/____/  

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
              🛠️  终端工具集 v1.0  |  macOS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 缓存清理
     1) Homebrew 缓存清理
     2) pip 缓存清理
     3) npm/pnpm/yarn 缓存清理
     ...
```

### 命令行模式

直接执行特定功能，无需进入菜单：

```bash
# 缓存清理
tool brew          # 清理 Homebrew 缓存
tool pip           # 清理 pip 缓存
tool node          # 清理 npm/pnpm/yarn 缓存
tool xcode         # 清理 Xcode 缓存
tool docker        # 清理 Docker 缓存
tool steam         # 清理 Steam 下载缓存
tool go            # 清理 Go 模块缓存
tool cargo         # 清理 Cargo 缓存
tool gem           # 清理 Ruby Gems 缓存
tool dns example.com  # 查询域名 NS IPv4

# 系统工具
tool network       # 网络连接检查
tool port 3000     # 查看 3000 端口占用
tool port -k 8080  # 杀死占用 8080 端口的进程
tool port -l       # 列出所有监听端口
tool port -c       # 检查常用开发端口

# 快捷操作
tool all           # 一键清理所有缓存
tool help          # 显示帮助信息
```

## 🔧 工具详情

### 1. Homebrew 缓存清理 (`clean_brew_cache.sh`)

```bash
tool brew
```

**功能：**
- ✅ 清理下载缓存
- ✅ 删除旧版本软件包
- ✅ 深度清理所有缓存文件
- ✅ 显示清理前后空间对比

---

### 2. pip 缓存清理 (`clean_pip_cache.sh`)

```bash
tool pip
```

**功能：**
- ✅ 清理 pip 下载缓存
- ✅ 清理 wheel 缓存
- ✅ 清理 http 缓存
- ✅ 支持 macOS 特定路径

---

### 3. Node.js 缓存清理 (`clean_node_cache.sh`)

```bash
tool node
```

**功能：**
- ✅ npm cache clean
- ✅ pnpm store prune
- ✅ yarn cache clean
- ✅ 清理 /tmp 临时文件

---

### 4. Xcode 缓存清理 (`clean_xcode_cache.sh`)

```bash
tool xcode
```

**功能：**
- ✅ 清理 DerivedData（编译产物）
- ✅ 清理模块缓存
- ✅ 清理 LLVM/SPM 缓存
- ✅ 删除不可用的模拟器
- ✅ 清理 Playground 缓存
- ⚠️ 可选清理 DeviceSupport/Archives

---

### 5. Docker 缓存清理 (`clean_docker_cache.sh`)

```bash
tool docker
```

**功能：**
- ✅ 删除已停止的容器
- ✅ 删除悬空镜像
- ✅ 删除未使用的卷和网络
- ✅ 清理构建缓存
- ⚠️ 可选深度清理（删除所有未使用资源）

---

### 6. Go 缓存清理 (`clean_go_cache.sh`)

```bash
tool go
```

**功能：**
- ✅ 清理构建缓存
- ✅ 清理测试缓存
- ✅ 清理模糊测试缓存
- ⚠️ 可选清理模块缓存

---

### 7. Cargo 缓存清理 (`clean_cargo_cache.sh`)

```bash
tool cargo
```

**功能：**
- ✅ 清理注册表缓存
- ✅ 清理 Git checkouts
- ✅ 清理 Git 数据库
- ⚠️ 可选清理所有 target 目录

---

### 8. Ruby Gems 缓存清理 (`clean_gem_cache.sh`)

```bash
tool gem
```

**功能：**
- ✅ 清理 gem 缓存
- ✅ 删除旧版本 gems
- ✅ 清理 Bundler 缓存
- ✅ 支持 rbenv/rvm
- ⚠️ 可选清理 CocoaPods 缓存

---

### 9. Steam 下载缓存清理 (`clean_steam_cache.sh`)

```bash
tool steam
```

**功能：**
- ✅ 清理 Steam 下载缓存
- ✅ 清理 app/http/depot 缓存
- ✅ 删除 partial 下载标记
- ⚠️ 建议清理前先退出 Steam 客户端

---

### 10. DNS NS IPv4 查询 (`dns_lookup.sh`)

```bash
tool dns example.com
```

**功能：**
- ✅ 列出域名的 NS 记录
- ✅ 解析每个 NS 的 IPv4（如有则显示 IPv6）
- ⚠️ 依赖 `dig`（macOS 默认自带）

---

### 11. 网络连接检查 (`check_network.sh`)

```bash
tool network
```

**功能：**
- ✅ 检查网络接口状态
- ✅ 测试网关连接
- ✅ DNS 解析测试
- ✅ Ping 测试（Google/Cloudflare/阿里）
- ✅ HTTP/HTTPS 连接测试
- ✅ 开发服务检查（npm/PyPI/Docker Hub）
- ✅ 本地端口监听检查
- ⚠️ 可选网络速度测试

---

### 12. 端口占用查杀 (`port_killer.sh`)

```bash
tool port [选项] [端口号]
```

**选项：**
| 选项 | 描述 |
|:---|:---|
| `tool port 3000` | 查看 3000 端口占用详情 |
| `tool port -k 8080` | 直接杀死占用 8080 的进程 |
| `tool port -l` | 列出所有监听端口 |
| `tool port -c` | 显示常用开发端口状态 |

**功能：**
- ✅ 查看端口占用详情（进程名、PID、CPU、内存）
- ✅ 一键杀死占用进程
- ✅ 支持强制终止
- ✅ 常用端口快速检查

## 📁 目录结构

```
~/MacDevTools/
├── tool                    # 主入口（全局命令）
├── clean_brew_cache.sh     # Homebrew 缓存清理
├── clean_pip_cache.sh      # pip 缓存清理
├── clean_node_cache.sh     # Node.js 缓存清理
├── clean_xcode_cache.sh    # Xcode 缓存清理
├── clean_docker_cache.sh   # Docker 缓存清理
├── clean_go_cache.sh       # Go 缓存清理
├── clean_cargo_cache.sh    # Cargo 缓存清理
├── clean_gem_cache.sh      # Ruby Gems 缓存清理
├── clean_steam_cache.sh    # Steam 下载缓存清理
├── dns_lookup.sh           # 域名 NS IPv4 查询
├── check_network.sh        # 网络连接检查
├── port_killer.sh          # 端口占用查杀
├── README.md               # 英文文档
└── README_CN.md            # 中文文档
```

## 🖼️ 截图

<details>
<summary>点击展开截图</summary>

### 主菜单
```
    __  ___           ____           ______            __    
     /  |/  /___ ______/ __ \___ _   _/_  __/___  ____  / /____
    / /|_/ / __ `/ ___/ / / / _ \ | / // / / __ \/ __ \/ / ___/
   / /  / / /_/ / /__/ /_/ /  __/ |/ // / / /_/ / /_/ / (__  ) 
  /_/  /_/\__,_/\___/_____/\___/|___//_/  \____/\____/_/____/  

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
              🛠️  终端工具集 v1.0  |  macOS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  📦 缓存清理
     1) Homebrew 缓存清理
     2) pip 缓存清理
     3) npm/pnpm/yarn 缓存清理
     4) Xcode 缓存清理
     5) Docker 缓存清理
     6) Go 模块缓存清理
     7) Cargo (Rust) 缓存清理
     8) Ruby Gems 缓存清理
     9) Steam 下载缓存清理

  🔧 系统工具
     10) 网络连接检查
     11) DNS NS IPv4 查询
     12) 端口占用查杀

  ⚡ 快捷操作
     a) 一键清理所有缓存
     l) 列出所有监听端口
     c) 检查常用端口

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
     h) 帮助    q) 退出
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 端口检查
```
🔌 常用开发端口检查

端口     服务               状态       进程
─────────────────────────────────────────────────
22       SSH                ⚪ 空闲
80       HTTP               ⚪ 空闲
443      HTTPS              ⚪ 空闲
3000     React/Node Dev     🟢 占用    node
3306     MySQL              🟢 占用    mysqld
5432     PostgreSQL         ⚪ 空闲
6379     Redis              🟢 占用    redis-server
8080     Alt HTTP/Tomcat    ⚪ 空闲
```

</details>

## ⚠️ 注意事项

1. **首次使用** - 建议先运行 `tool` 查看菜单，熟悉各功能
2. **缓存清理** - 清理后首次编译/安装可能较慢（需重新下载）
3. **Xcode** - 清理前请确保没有正在进行的编译任务
4. **Docker** - 深度清理会删除所有未使用的镜像
5. **端口查杀** - 杀死系统进程可能需要 sudo 权限

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 提交 Pull Request

### 贡献指南

- 保持代码风格一致
- 添加适当的注释
- 更新 README 文档
- 测试脚本在 macOS 上的兼容性

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 🙏 致谢

- 感谢所有开源工具的开发者
- 图标来自 [Icons8](https://icons8.com)

---

<p align="center">
  <sub>Made with ❤️ for macOS developers</sub>
</p>

<p align="center">
  <a href="#macdevtools">⬆️ 回到顶部</a>
</p>

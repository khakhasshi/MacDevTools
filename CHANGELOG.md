# Changelog

## [1.2.0] - 2026-03-15
### Added
- Maven local repository cleaner (`tool maven` / `clean_maven_cache.sh`): removes SNAPSHOT artifacts, stale metadata, incomplete downloads, and optionally old JARs.
- Gradle cache cleaner (`tool gradle` / `clean_gradle_cache.sh`): removes build cache, old versioned caches, daemon logs, old wrapper distributions, and project `.gradle` dirs.
- Log file cleanup tool (`tool logs` / `clean_logs.sh`): cleans app logs, crash reports, iOS Simulator logs, `/var/log` rotated entries, and dev-tool log directories.
- Disk usage analyzer (`tool disk` / `disk_usage.sh`): shows full disk overview, home directory breakdown, top-20 largest files, developer cache hotspots, and Downloads summary.
- Package outdated checker (`tool outdated` / `pkg_outdated.sh`): summarizes outdated packages across Homebrew, pip, npm, pnpm, yarn, gem, cargo, Go, and macOS software updates.
- SSL certificate checker (`tool ssl <domain>` / `ssl_check.sh`): shows subject, issuer, SANs, expiry countdown, TLS version, and chain verification for one or more domains.

### Changed
- TUI menu expanded to 20 items (items 11-12 are Maven/Gradle; original system tools renumbered 13-16; new tools at 17-20).
- `clean_all` function updated to include Maven and Gradle (now 10 steps).
- Version label updated to v1.2.0.
- Documentation updated.

## [1.1.0] - 2026-02-20
### Added
- Steam download cache cleaner (`tool steam`).
- Apple TV cache cleaner (`tool appletv`).
- DNS nameserver IPv4 lookup tool with URL/parent-zone fallback (`tool dns <domain>`).
- .gitignore for common OS/editor/artifact files.

### Changed
- TUI banner color scheme and version label updated to v1.1.0.
- Script path resolution now searches common install locations (`/usr/local/lib/shelltools`, Homebrew `libexec`).
- Install scripts/Makefile include new tools and use MacDevTools naming.
- Documentation updated (brew install command now `khakhasshi/tap/macdevtools`; version badges to 1.1.0; screenshots menu counts).

### Fixed
- DNS lookup handles full URLs and falls back to parent zone when subdomains lack NS records.
- Homebrew formula renamed and aligned with new repo naming (class `Macdevtools`, v1.1.0 URL/SHA).

## [1.0.0] - 2026-02-15
- Initial release.

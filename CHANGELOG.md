# Changelog

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

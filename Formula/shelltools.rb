# Homebrew Formula for MacShellTool
# Save this file as: homebrew-tap/Formula/shelltools.rb

class Shelltools < Formula
  desc "macOS Terminal Toolkit - All-in-One System Maintenance & Development Tools"
  homepage "https://github.com/khakhasshi/MacShellTool"
  url "https://github.com/khakhasshi/MacShellTool/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
  license "MIT"
  version "1.0.0"

  def install
    libexec.install Dir["*.sh"]
    libexec.install "tool"
    
    # Update TOOL_DIR path in main script
    inreplace libexec/"tool", 'TOOL_DIR="$HOME/ShellTools"', "TOOL_DIR=\"#{libexec}\""
    
    bin.install_symlink libexec/"tool"
  end

  test do
    system "#{bin}/tool", "help"
  end
end

# Homebrew Formula for MacDevTools
# Save this file as: homebrew-tap/Formula/macdevtools.rb

class Macdevtools < Formula
  desc "macOS Terminal Toolkit - All-in-One System Maintenance & Development Tools"
  homepage "https://github.com/khakhasshi/MacDevTools"
  url "https://github.com/khakhasshi/MacDevTools/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "ea68bd49b99fc3f5168c1788b6eeb979496c70ae9b456f5140aca4fd85b2b3a2"
  license "MIT"
  version "1.1.0"

  def install
    libexec.install Dir["*.sh"]
    libexec.install "tool"
    
    # Force TOOL_DIR to libexec for Homebrew installs
    inreplace libexec/"tool", 'TOOL_DIR="$HOME/ShellTools"', "TOOL_DIR=\"#{libexec}\""
    
    bin.install_symlink libexec/"tool"
  end

  test do
    system "#{bin}/tool", "help"
  end
end

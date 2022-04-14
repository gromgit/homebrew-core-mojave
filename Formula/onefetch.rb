class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.12.0.tar.gz"
  sha256 "f57b16dfa2bb95dd1fb805257a1761baa20d69eb9ce7c311d369609894c53897"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/onefetch"
    sha256 cellar: :any_skip_relocation, mojave: "0d24843de627b64313c55963becfa12991f19ca6c7d25b3cf0f6d0a5d93c6384"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    system "echo \"puts 'Hello, world'\" > main.rb && git add main.rb && git commit -m \"First commit\""
    assert_match("Ruby (100.0 %)", shell_output("#{bin}/onefetch").chomp)
  end
end

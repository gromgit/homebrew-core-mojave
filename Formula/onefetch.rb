class Onefetch < Formula
  desc "Git repository summary on your terminal"
  homepage "https://github.com/o2sh/onefetch"
  url "https://github.com/o2sh/onefetch/archive/v2.11.0.tar.gz"
  sha256 "ffd3cc3bd24e299ede1fada2b2da8bf066d59219da167477e1997c860650c192"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/onefetch"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "e9277af2ba33c0162437f34fba5f3e36b18d1d58f8ab1e9cef37eb1fd2a7c5e9"
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
    assert_match(/Language:.*Ruby/, shell_output("#{bin}/onefetch").chomp)
  end
end

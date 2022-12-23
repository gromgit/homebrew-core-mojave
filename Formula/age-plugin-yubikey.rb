class AgePluginYubikey < Formula
  desc "Plugin for encrypting files with age and PIV tokens such as YubiKeys"
  homepage "https://github.com/str4d/age-plugin-yubikey"
  url "https://github.com/str4d/age-plugin-yubikey/archive/v0.3.0.tar.gz"
  sha256 "3dfd7923dcbd7b02d0bce1135ff4ba55a7860d8986d1b3b2d113d9553f439ba9"
  license "MIT"
  head "https://github.com/str4d/age-plugin-yubikey.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/age-plugin-yubikey"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "6de0ba4f0d4a692d1da12502f502cf6e315d3b847ca0c8b3b14c0bcb2aed79a3"
  end

  depends_on "rust" => :build

  uses_from_macos "pcsc-lite"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    assert_match "Let's get your YubiKey set up for age!",
      shell_output("#{bin}/age-plugin-yubikey 2>&1", 1)
  end
end

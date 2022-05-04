class AgePluginYubikey < Formula
  desc "Plugin for encrypting files with age and PIV tokens such as YubiKeys"
  homepage "https://github.com/str4d/age-plugin-yubikey"
  url "https://github.com/str4d/age-plugin-yubikey/archive/v0.3.0.tar.gz"
  sha256 "3dfd7923dcbd7b02d0bce1135ff4ba55a7860d8986d1b3b2d113d9553f439ba9"
  license "MIT"
  head "https://github.com/str4d/age-plugin-yubikey.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/age-plugin-yubikey"
    sha256 cellar: :any_skip_relocation, mojave: "1553dd97c9b519ee70d4e1a299c7b8291d53635dcfdbbeab035228fdf35459cf"
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

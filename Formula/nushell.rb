class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.66.2.tar.gz"
  sha256 "548668fe0e746cb068443b7701829e1839565e30aa5faa20c5481d0ead808045"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nushell"
    sha256 cellar: :any, mojave: "1ad740c63a8e066648f18a0cd837cc2fb81b5c5d9aed36297f965f7048c82a01"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "extra", *std_cargo_args

    buildpath.glob("crates/nu_plugin_*").each do |plugindir|
      next unless (plugindir/"Cargo.toml").exist?

      system "cargo", "install", *std_cargo_args(path: plugindir)
    end
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu -c \'{ foo: 1, bar: homebrew_test} | get bar\'", nil)
  end
end

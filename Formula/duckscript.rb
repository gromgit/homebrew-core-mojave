class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.14.tar.gz"
  sha256 "34c9a0fda9c635706a2b82dcaf11f6536cba6f24c6ff403fdf377e323f8f6272"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/duckscript"
    sha256 cellar: :any_skip_relocation, mojave: "38ce2fad7e2a8d1d7e4b3d8368749452dc7fa3da06cf867ba6cb179dc4c4a361"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
  end

  def install
    cd "duckscript_cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"hello.ds").write <<~EOS
      out = set "Hello World"
      echo The out variable holds the value: ${out}
    EOS
    output = shell_output("#{bin}/duck hello.ds")
    assert_match "The out variable holds the value: Hello World", output
  end
end

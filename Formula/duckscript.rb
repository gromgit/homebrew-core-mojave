class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.9.tar.gz"
  sha256 "b26ef19d50367352af3d0ba79946838202e7418a9e53e82fbb96f05c87dd389a"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/duckscript"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "1db17ce6e4761c2e3caa30cc2429dc1b2875efc1dbd38182c918a4253c8633b5"
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

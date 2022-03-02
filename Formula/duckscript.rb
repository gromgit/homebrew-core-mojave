class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.8.10.tar.gz"
  sha256 "20b4cd633e0d7e72bdb3e9e4018f1342acfea6b22fd271c90bc915d2339e8e6b"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/duckscript"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "af17e6f5f589c9668bc5b904b8dad97e7babbe6366d1e5252e2556fad1ae0ecb"
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

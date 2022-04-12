class Arturo < Formula
  desc "Simple, modern and portable programming language for efficient scripting"
  homepage "https://github.com/arturo-lang/arturo"
  url "https://github.com/arturo-lang/arturo/archive/v0.9.80.tar.gz"
  sha256 "25f4782e3ce1bc38bedf047ed06a3992cf765071acded79af202a1ab70b040e2"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/arturo"
    sha256 cellar: :any, mojave: "86c0f72dc5fa84b594378aa65c2e9ef2dccdf3eb8fe11f4f1ee05491bd8178a1"
  end

  depends_on "nim" => :build
  depends_on "gmp"
  depends_on "mysql"

  def install
    inreplace "build.nims", "ROOT_DIR    = r\"{getHomeDir()}.arturo\".fmt", "ROOT_DIR=\"#{prefix}\""
    # Use mini install on Linux to avoid webkit2gtk dependency, which does not have a formula.
    args = OS.mac? ? "" : "mini"
    system "./build.nims", "install", args
  end

  test do
    (testpath/"hello.art").write <<~EOS
      print "hello"
    EOS
    assert_equal "hello", shell_output("#{bin}/arturo #{testpath}/hello.art").chomp
  end
end

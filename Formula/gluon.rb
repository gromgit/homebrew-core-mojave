class Gluon < Formula
  desc "Static, type inferred and embeddable language written in Rust"
  homepage "https://gluon-lang.org"
  url "https://github.com/gluon-lang/gluon/archive/v0.17.2.tar.gz"
  sha256 "8fc8cc2211cff7a3d37a64c0b1f0901767725d3c2c26535cb9aabbfe921ba18e"
  license "MIT"
  head "https://github.com/gluon-lang/gluon.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gluon"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "414693c2a2d9f529d2097321977ab85f39e37db96be769a50f1a8524bb63cc07"
  end

  depends_on "rust" => :build

  def install
    cd "repl" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.glu").write <<~EOS
      let io = import! std.io
      io.print "Hello world!\\n"
    EOS
    assert_equal "Hello world!\n", shell_output("#{bin}/gluon test.glu")
  end
end

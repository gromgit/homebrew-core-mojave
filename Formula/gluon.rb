class Gluon < Formula
  desc "Static, type inferred and embeddable language written in Rust"
  homepage "https://gluon-lang.org"
  url "https://github.com/gluon-lang/gluon/archive/v0.18.0.tar.gz"
  sha256 "1532cae94c85c9172e0b96b061384c448e6e1b35093d1aacf0cd214e751fe1e3"
  license "MIT"
  head "https://github.com/gluon-lang/gluon.git", branch: "master"

  # There's a lot of false tags here.
  # Those prefixed with 'v' seem to be ok.
  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gluon"
    sha256 cellar: :any_skip_relocation, mojave: "0e1c22e947bb9d0b1faef7162b8dc635fea89a7b342f625c4c92a0b7f769d37a"
  end

  depends_on "rust" => :build

  # Fix compile with newer Rust.
  # Remove with 0.19.
  patch do
    url "https://github.com/gluon-lang/gluon/commit/f30127bf5e27520d41a654154381c2e9601d2f3e.patch?full_index=1"
    sha256 "bcfb2d0c36104a30745f7e6ddc4c8650ed60cb969f1e55cd4e6bb2cb6fe48722"
  end

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

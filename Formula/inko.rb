class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.10.0.tar.gz"
  sha256 "d38e13532a71290386164246ac8cf7efb884131716dba6553b66a170dd3a2796"
  license "MPL-2.0"
  head "https://gitlab.com/inko-lang/inko.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/inko"
    rebuild 1
    sha256 cellar: :any, mojave: "b55037e4b35bc59b1de98eaa80c2ce25c98fafb6d1d8f5c66f75f77a348cce6d"
  end

  depends_on "coreutils" => :build
  depends_on "rust" => :build

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ruby", since: :sierra

  def install
    system "make", "build", "PREFIX=#{prefix}", "FEATURES=libffi/system"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"hello.inko").write <<~EOS
      import std::stdio::STDOUT

      class async Main {
        fn async main {
          STDOUT.new.print('Hello, world!')
        }
      }
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}/inko hello.inko")
  end
end

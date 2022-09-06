class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.9.0.tar.gz"
  sha256 "311f6e675e6f7ca488a71022b62edbbc16946f907d7e1695f3f96747ece2051f"
  license "MPL-2.0"
  revision 1
  head "https://gitlab.com/inko-lang/inko.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/inko"
    rebuild 2
    sha256 cellar: :any, mojave: "8e6468be47a66d049ebab01e1333e0d1e038f59fb7fbace15e8ebf3a08a817ba"
  end

  depends_on "coreutils" => :build
  depends_on "rust" => :build

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ruby", since: :sierra

  def install
    system "make", "build", "PREFIX=#{prefix}", "FEATURES=libinko/libffi-system"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"hello.inko").write <<~EOS
      import std::stdio::stdout

      stdout.print('Hello, world!')
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}/inko hello.inko")
  end
end

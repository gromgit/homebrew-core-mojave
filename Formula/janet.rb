class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.20.0.tar.gz"
  sha256 "cc2e617e2bdffaeca0fc330c890c73a83e2211b4ff65555d58973c47376bf5b1"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/janet"
    sha256 cellar: :any, mojave: "24d96fbe7b134c1cb9383222bb9e0a92d1b8207b04c6e79449ba9c9906ed7353"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
  end
end

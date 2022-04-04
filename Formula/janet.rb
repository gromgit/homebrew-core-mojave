class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.21.1.tar.gz"
  sha256 "8c6eeabbc0c00ac901b66763676fa4bfdac96e5b6a3def85025b45126227c4e0"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/janet"
    sha256 cellar: :any, mojave: "4fdb228c1d9d380982f17568e7541276d2abf1c6cfe65d56570fdb50c9482124"
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

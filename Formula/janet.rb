class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.21.2.tar.gz"
  sha256 "52db8d18f93351256d0731810e8bea95516db8142f51eeb31664f7884bf63088"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/janet"
    sha256 cellar: :any, mojave: "a144d78f9207737f5982af3e64174a57c5c5b05045e64e24232248b0f20319eb"
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

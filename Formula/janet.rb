class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.22.0.tar.gz"
  sha256 "7c6969f8e82badc7afa28aa1054555c1c91d2858f9f45c41a82557f5c5ce85bd"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/janet"
    sha256 cellar: :any, mojave: "331b9b15bd4df265061efb310b0f815b6afd56a6d0454815d33945deac2ece6b"
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

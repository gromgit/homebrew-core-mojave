class Hyx < Formula
  desc "Powerful hex editor for the console"
  homepage "https://yx7.cc/code/"
  url "https://yx7.cc/code/hyx/hyx-2021.06.09.tar.xz"
  sha256 "8d4f14e58584d6cc8f04e43ca38042eed218882a389249c20b086730256da5eb"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hyx"
    sha256 cellar: :any_skip_relocation, mojave: "07bd2d86309e1c9396f832890d5e0f69d2623d81c52835779a2e4583fed1391c"
  end

  uses_from_macos "expect" => :test

  def install
    # CFLAGS set here because the defaults are not compatible with Clang.
    # Issue reported upstream via email to lorenz@yx7@.cc on 2022-07-19.
    ENV["CFLAGS"] = "-O2 -D_FORTIFY_SOURCE=2 -fstack-protector-all"
    system "make"

    bin.install "hyx"
    doc.install "license.txt"
  end

  test do
    assert_match(/window|0000/,
      pipe_output("env TERM=tty expect -",
                  "spawn #{bin}/hyx;send \"q\";expect eof"))
  end
end

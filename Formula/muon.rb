class Muon < Formula
  desc "Meson-compatible build system"
  homepage "https://muon.build"
  url "https://git.sr.ht/~lattis/muon/archive/0.1.0.tar.gz"
  sha256 "9d3825c2d562f8f8ad96d1f02167e89c4e84973decf205d127efd9293d7da35b"
  license "GPL-3.0-only"
  head "https://git.sr.ht/~lattis/muon", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/muon"
    sha256 cellar: :any_skip_relocation, mojave: "f96e0b625c703e48e9ed45dcdf2a6259bb34a530d57af14bd548b3fe61c532bb"
  end

  depends_on "ninja"
  depends_on "pkg-config"

  def install
    system "./bootstrap.sh", "build"
    system "./build/muon", "setup", "-Dprefix=#{prefix}", "build"
    system "ninja", "-C", "build"
    system "./build/muon", "-C", "build", "install"
  end

  test do
    (testpath/"helloworld.c").write <<~EOS
      #include <stdio.h>
      int main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<~EOS
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    system bin/"muon", "setup", "build"
    assert_predicate testpath/"build/build.ninja", :exist?

    system "ninja", "-C", "build", "--verbose"
    assert_equal "hi", shell_output("build/hello").chomp
  end
end

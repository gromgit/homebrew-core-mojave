class Highlight < Formula
  desc "Convert source code to formatted text with syntax highlighting"
  homepage "http://www.andre-simon.de/doku/highlight/en/highlight.php"
  url "http://www.andre-simon.de/zip/highlight-4.2.tar.bz2"
  sha256 "ed3efdb9b416b236e503989f9dfebdd94bf515536cfd183aefe36cefdd0d0468"
  license "GPL-3.0-or-later"
  head "https://gitlab.com/saalen/highlight.git", branch: "master"

  livecheck do
    url "http://www.andre-simon.de/zip/download.php"
    regex(/href=.*?highlight[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/highlight"
    rebuild 1
    sha256 mojave: "2627d8a374f99a08e3a4eaa2e3d247fefb71e4050b653c6c064f03b0459eb3ed"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # needs C++17

  def install
    conf_dir = etc/"highlight/" # highlight needs a final / for conf_dir
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}"
    system "make", "PREFIX=#{prefix}", "conf_dir=#{conf_dir}", "install"
  end

  test do
    system bin/"highlight", doc/"extras/highlight_pipe.php"
  end
end

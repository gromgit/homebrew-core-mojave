class Luit < Formula
  desc "Filter run between arbitrary application and UTF-8 terminal emulator"
  homepage "https://invisible-island.net/luit/"
  url "https://invisible-mirror.net/archives/luit/luit-20221028.tgz"
  sha256 "ef78b3a64a697cb70a881558abb8251e4b30748ceefb8d44adbd8ea797bcfca6"
  license "MIT"

  livecheck do
    url "https://invisible-mirror.net/archives/luit/"
    regex(/href=.*?luit[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/luit"
    sha256 cellar: :any_skip_relocation, mojave: "4bbce4fe9cf04527202d18326b372915cb846c4a2692bd2e6e7d5326ad12c705"
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}", "--without-x"
    system "make", "install"
  end

  test do
    require "pty"
    (testpath/"input").write("#end {bye}\n")
    PTY.spawn(bin/"luit", "-encoding", "GBK", "echo", "foobar") do |r, _w, _pid|
      assert_match "foobar", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end

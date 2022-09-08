class Xaric < Formula
  desc "IRC client"
  homepage "https://xaric.org/"
  url "https://xaric.org/software/xaric/releases/xaric-0.13.9.tar.gz"
  sha256 "cb6c23fd20b9f54e663fff7cab22e8c11088319c95c90904175accf125d2fc11"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://xaric.org/software/xaric/releases/"
    regex(/href=.*?xaric[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xaric"
    rebuild 1
    sha256 mojave: "1896be97296f7f764865d91af636c9cf34a6c4b0272b686a7b3bd6e7e2dd7f01"
  end

  depends_on "openssl@1.1"

  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args,
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    require "pty"
    output = ""
    PTY.spawn("#{bin}/xaric", "-v") do |r, _w, _pid|
      r.each_line { |line| output += line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
    assert_match "Xaric #{version}", output
  end
end

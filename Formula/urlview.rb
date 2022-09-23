class Urlview < Formula
  desc "URL extractor/launcher"
  homepage "https://packages.debian.org/sid/misc/urlview"
  url "https://deb.debian.org/debian/pool/main/u/urlview/urlview_0.9.orig.tar.gz"
  version "0.9-23"
  sha256 "746ff540ccf601645f500ee7743f443caf987d6380e61e5249fc15f7a455ed42"
  license "GPL-2.0-or-later"

  # Since this formula incorporates patches and uses a version like `0.9-21`,
  # this check is open-ended (rather than targeting the .orig.tar.gz file), so
  # we identify patch versions as well.
  livecheck do
    url "https://deb.debian.org/debian/pool/main/u/urlview/"
    regex(/href=.*?urlview[._-]v?(\d+(?:[.-]\d+)+)/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/urlview"
    sha256 cellar: :any_skip_relocation, mojave: "81a4f1e7c09b3d7a492aad58c821338b5e78ea0b2418b2b536e76d3dab0d197e"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "automake"
  end

  patch do
    url "https://deb.debian.org/debian/pool/main/u/urlview/urlview_0.9-23.diff.gz"
    sha256 "32dcff6d032ae23f100a42cb7b23573338033b5e0613b20813324ddb417ce86f"
  end

  def install
    url_handler = OS.mac? ? "open" : etc/"urlview/url_handler.sh"
    inreplace "urlview.man", "/etc/urlview/url_handler.sh", url_handler
    inreplace "urlview.c",
      '#define DEFAULT_COMMAND "/etc/urlview/url_handler.sh %s"',
      %Q(#define DEFAULT_COMMAND "#{url_handler} %s")

    man1.mkpath

    unless OS.mac?
      touch("NEWS") # autoreconf will fail if this file does not exist
      system "autoreconf", "-i"

      # Disable use of librx, since it is not needed on Linux.
      ENV["CFLAGS"] = "-DHAVE_REGEX_H"
      (etc/"urlview").install "url_handler.sh"
    end

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      https://github.com/Homebrew
    EOS
    PTY.spawn("urlview test.txt") do |_r, w, _pid|
      sleep 1
      w.write("\cD")
    end
  end
end

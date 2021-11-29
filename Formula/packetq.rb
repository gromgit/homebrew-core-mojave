class Packetq < Formula
  desc "SQL-like frontend to PCAP files"
  homepage "https://www.dns-oarc.net/tools/packetq"
  url "https://www.dns-oarc.net/files/packetq/packetq-1.5.0.tar.gz"
  sha256 "2358a878a2cf656d60f715b528911fb9a937149c71e336d7d65bb1af4e388ce2"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?packetq[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/packetq"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "babc72f026bfaa2453a1dbba0357af3054da25010f89eda8c3ae22fa644b3ce3"
  end

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/packetq --csv -s 'select id from dns' -")
    assert_equal '"id"', output.chomp
  end
end

class Packetq < Formula
  desc "SQL-like frontend to PCAP files"
  homepage "https://www.dns-oarc.net/tools/packetq"
  url "https://www.dns-oarc.net/files/packetq/packetq-1.7.1.tar.gz"
  sha256 "a1b087335fcb018a5ded3d067d22ee906d24b6e932f018e959302be9b527c620"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?packetq[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/packetq"
    sha256 cellar: :any_skip_relocation, mojave: "0cf2638b67db04d5a4ce93d15d1aa21385a69572876feffc9eec7e4f48e1cda1"
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

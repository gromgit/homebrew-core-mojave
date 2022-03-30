class IpRelay < Formula
  desc "TCP traffic shaping relay application"
  homepage "https://stewart.com.au/ip_relay/"
  url "https://stewart.com.au/ip_relay/ip_relay-0.71.tgz"
  sha256 "0cf6c7db64344b84061c64e848e8b4f547b5576ad28f8f5e67163fc0382d9ed3"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?ip_relay[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "35934dd4047dc1c1966fca089d71bc870e23f5a6370368fad9861ff3e3f76064"
  end

  def install
    bin.install "ip_relay.pl" => "ip_relay"
  end

  test do
    shell_output("#{bin}/ip_relay -b", 1)
  end
end

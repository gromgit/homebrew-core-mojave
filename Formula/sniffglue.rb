class Sniffglue < Formula
  desc "Secure multithreaded packet sniffer"
  homepage "https://github.com/kpcyrd/sniffglue"
  url "https://github.com/kpcyrd/sniffglue/archive/v0.15.0.tar.gz"
  sha256 "ac30c0748a4247d2a36b82d623e88863480c300d3f6bbbdc303077240a8292c5"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sniffglue"
    sha256 cellar: :any_skip_relocation, mojave: "e4bb1dd4473b49cedc7b406c1ff35cf2dcaef41f9bfacb781a6f545a94a2f0a5"
  end

  depends_on "rust" => :build
  depends_on "scdoc" => :build

  uses_from_macos "libpcap"

  on_linux do
    depends_on "libseccomp"
  end

  resource "homebrew-testdata" do
    url "https://github.com/kpcyrd/sniffglue/raw/163ca299bab711fb0082de216d07d7089c176de6/pcaps/SkypeIRC.pcap"
    sha256 "bac79a9c3413637f871193589d848697af895b7f2700d949022224d59aa6830f"
  end

  def install
    system "cargo", "install", *std_cargo_args
    system "make", "docs"

    etc.install "sniffglue.conf"
    man1.install "docs/sniffglue.1"
  end

  test do
    testpath.install resource("homebrew-testdata")
    system bin/"sniffglue", "-r", "SkypeIRC.pcap"
  end
end

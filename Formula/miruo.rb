class Miruo < Formula
  desc "Pretty-print TCP session monitor/analyzer"
  homepage "https://github.com/KLab/miruo/"
  url "https://github.com/KLab/miruo/archive/0.9.6b.tar.gz"
  version "0.9.6b"
  sha256 "0b31a5bde5b0e92a245611a8e671cec3d330686316691daeb1de76360d2fa5f1"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cd45391af46ccd1a166e139e2aa6020e0e75999a094e5e4a4eabb8ca5056fc97"
    sha256 cellar: :any_skip_relocation, big_sur:       "61fbf984ade171a70ae80af4695a78ed35331a143cdc12ddf4440fee74889807"
    sha256 cellar: :any_skip_relocation, catalina:      "044456429802d6f6d8ba2a8d00547e0e0695e99edd1cceb1af29e70eb004d13f"
    sha256 cellar: :any_skip_relocation, mojave:        "a71716a29094f72b62cc6a84284abb509916907c5559b25a2b85196148b86c84"
    sha256 cellar: :any_skip_relocation, high_sierra:   "36df62e0454d4b7e5743a002a2ff3293e087a9fb607c369f3d23732d87330e4e"
    sha256 cellar: :any_skip_relocation, sierra:        "dbe92dd3ab515528597eb76aa986f4e9d8dd512504d76ca60b86b5dc5dc70449"
    sha256 cellar: :any_skip_relocation, el_capitan:    "8a5402f68bcb73e22f13fb0b049caea5d186520e81bf77889c91a558d9988c59"
    sha256 cellar: :any_skip_relocation, yosemite:      "f39aa9336ac2ec07ec0bd25bc7f7d3ae1b7a76c8af8c4d5e1f7e0ffdcfcbc9fe"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--with-libpcap=#{MacOS.sdk_path}/usr"
    system "make", "install"
  end

  test do
    (testpath/"dummy.pcap").write "\xd4\xc3\xb2\xa1\x02\x00\x04\x00\x00\x00\x00\x00" \
                                  "\x00\x00\x00\x00\xff\xff\x00\x00\x01\x00\x00\x00"
    system "#{sbin}/miruo", "--file=dummy.pcap"
  end
end

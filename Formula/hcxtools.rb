class Hcxtools < Formula
  desc "Utils for conversion of cap/pcap/pcapng WiFi dump files"
  homepage "https://github.com/ZerBea/hcxtools"
  url "https://github.com/ZerBea/hcxtools/archive/6.2.7.tar.gz"
  sha256 "c9d69b5ddcf61c3deff687fad6c17197970cc75c5dbc7706b31c138bf0c784e1"
  license "MIT"
  head "https://github.com/ZerBea/hcxtools.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hcxtools"
    rebuild 1
    sha256 cellar: :any, mojave: "79147a69c1d59951c8bce7f382c9e87dcadd21ea4de1f62fd7545f94c2704b69"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"

  def install
    bin.mkpath
    man1.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Create file with 22000 hash line
    testhash = testpath/"test.22000"
    (testpath/"test.22000").write <<~EOS
      WPA*01*4d4fe7aac3a2cecab195321ceb99a7d0*fc690c158264*f4747f87f9f4*686173686361742d6573736964***
    EOS

    # Convert hash to .cap file
    testcap = testpath/"test.cap"
    system "#{bin}/hcxhash2cap", "--pmkid-eapol=#{testhash}", "-c", testpath/"test.cap"

    # Convert .cap file back to hash file
    newhash = testpath/"new.22000"
    system "#{bin}/hcxpcapngtool", "-o", newhash, testcap

    # Diff old and new hash file to check if they are identical
    system "diff", newhash, testhash
  end
end

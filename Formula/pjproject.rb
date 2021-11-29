class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "https://www.pjsip.org/"
  url "https://github.com/pjsip/pjproject/archive/2.11.1.tar.gz"
  sha256 "45f6604372df3f49293749cd7c0b42cb21c4fb666c66f8ed9765de004d1eae38"
  license "GPL-2.0-or-later"
  head "https://github.com/pjsip/pjproject.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pjproject"
    rebuild 1
    sha256 cellar: :any, mojave: "36ff83146a5caea17445568a652c7e54228759fdabc66d59cc580882c6e47646"
  end

  depends_on macos: :high_sierra # Uses Security framework API enum cases introduced in 10.13.4
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}"
    ENV.deparallelize
    system "make", "dep"
    system "make"
    system "make", "install"

    arch = Utils.safe_popen_read("uname", "-m").chomp
    if OS.mac?
      bin.install "pjsip-apps/bin/pjsua-#{arch}-apple-darwin#{OS.kernel_version}" => "pjsua"
    else
      bin.install "pjsip-apps/bin/pjsua-#{arch}-unknown-linux-gnu" => "pjsua"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pjsua --version 2>&1")
  end
end

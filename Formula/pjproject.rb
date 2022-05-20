class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "https://www.pjsip.org/"
  url "https://github.com/pjsip/pjproject/archive/2.12.1.tar.gz"
  sha256 "d0feef6963b07934e821ba4328aecb4c36358515c1b3e507da5874555d713533"
  license "GPL-2.0-or-later"
  head "https://github.com/pjsip/pjproject.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pjproject"
    sha256 cellar: :any, mojave: "ae429a4a4e1816d61153191cc3fd827218ccb9ffe5ac718ae696340419552a40"
  end

  depends_on macos: :high_sierra # Uses Security framework API enum cases introduced in 10.13.4
  depends_on "openssl@1.1"

  # restore --version flag, remove in next version
  patch do
    url "https://github.com/pjsip/pjproject/commit/4a8cf9f3.patch?full_index=1"
    sha256 "2a343db0ba4c0cb02ebaa4fc197b27aa9ef064f8367f02f77b854204ff640112"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    ENV.deparallelize
    system "make", "dep"
    system "make"
    system "make", "install"

    arch = OS.mac? && Hardware::CPU.arm? ? "arm" : Hardware::CPU.arch.to_s
    target = OS.mac? ? "apple-darwin#{OS.kernel_version}" : "unknown-linux-gnu"

    bin.install "pjsip-apps/bin/pjsua-#{arch}-#{target}" => "pjsua"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pjsua --version 2>&1")
  end
end

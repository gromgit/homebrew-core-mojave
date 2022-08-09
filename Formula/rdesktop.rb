class Rdesktop < Formula
  desc "UNIX client for connecting to Windows Remote Desktop Services"
  homepage "https://github.com/rdesktop/rdesktop"
  url "https://github.com/rdesktop/rdesktop/releases/download/v1.9.0/rdesktop-1.9.0.tar.gz"
  sha256 "473c2f312391379960efe41caad37852c59312bc8f100f9b5f26609ab5704288"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 arm64_monterey: "671a5f5ead3a6f2406306b8a05a0a63bee37eda0e7e771ab33acc397a8f7c645"
    sha256 arm64_big_sur:  "1903e4da2086a2942a0cb67b7eaaab26b3fb5048114b6ccccfa0977f676f52a4"
    sha256 monterey:       "087f1adc8db1045091b37fa769df85d5bd9cc886c8c12e7ff5d1216da6dd62ba"
    sha256 big_sur:        "60d5a72e5a55cace788d0a28241b9080fbf039c25fd91eb3bf91a95a8e8e4a89"
    sha256 catalina:       "8b22a2d1f52ff40334a16fc4614bc2f2c9e50386f0732e8e4478f68c7008f961"
    sha256 mojave:         "91b95a137be4361dee7d8bf2e442fa75eaf159469c09e238a127aa1186534638"
    sha256 high_sierra:    "84ca9f1d74ad63108e320f2cae63a2afdfafd3995aa2d37837d551cc5dda8688"
    sha256 x86_64_linux:   "05b175c2263baf72cb59debeaf49a974d31db23caf9f1c2b5e9eb3007a02e791"
  end

  disable! date: "2022-07-31", because: :unmaintained

  # Added automake as a build dependency to update config files for ARM support.
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libao"
  depends_on "libtasn1"
  depends_on "libx11"
  depends_on "libxcursor"
  depends_on "libxrandr"
  depends_on "nettle"

  uses_from_macos "pcsc-lite"

  def install
    # Workaround for ancient config files not recognizing aarch64 macos.
    %w[config.guess config.sub].each do |fn|
      cp Formula["automake"].share/"automake-#{Formula["automake"].version.major_minor}"/fn, fn
    end

    args = %W[
      --prefix=#{prefix}
      --disable-credssp
      --enable-smartcard
      --with-sound=libao
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rdesktop -help 2>&1", 64)
  end
end

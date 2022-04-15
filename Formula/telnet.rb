class Telnet < Formula
  desc "User interface to the TELNET protocol"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/remote_cmds/archive/refs/tags/remote_cmds-64.tar.gz"
  sha256 "9beae91af0ac788227119c4ed17c707cd3bb3e4ed71422ab6ed230129cbb9362"
  license all_of: ["BSD-4-Clause-UC", "APSL-1.0"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/telnet"
    sha256 cellar: :any_skip_relocation, mojave: "c4b39922253e22bcfc2ada9ff0e5d75ace75719015b11fa5fc373d2d458e40d4"
  end

  depends_on xcode: :build
  depends_on :macos

  conflicts_with "inetutils", because: "both install 'telnet' binaries"

  resource "libtelnet" do
    url "https://opensource.apple.com/tarballs/libtelnet/libtelnet-13.tar.gz"
    sha256 "e7d203083c2d9fa363da4cc4b7377d4a18f8a6f569b9bcf58f97255941a2ebd1"
  end

  def install
    resource("libtelnet").stage do
      ENV["SDKROOT"] = MacOS.sdk_path
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

      xcodebuild "SYMROOT=build", "-arch", Hardware::CPU.arch

      libtelnet_dst = buildpath/"telnet.tproj/build/Products"
      libtelnet_dst.install "build/Release/libtelnet.a"
      libtelnet_dst.install "build/Release/usr/local/include/libtelnet/"
    end

    ENV.append_to_cflags "-isystembuild/Products/"
    system "make", "-C", "telnet.tproj",
                   "OBJROOT=build/Intermediates",
                   "SYMROOT=build/Products",
                   "DSTROOT=build/Archive",
                   "CFLAGS=$(CC_Flags) #{ENV.cflags}",
                   "LDFLAGS=$(LD_Flags) -Lbuild/Products/",
                   "RC_ARCHS=#{Hardware::CPU.arch}",
                   "install"

    bin.install "telnet.tproj/build/Archive/usr/local/bin/telnet"
    man1.install "telnet.tproj/telnet.1"
  end

  test do
    output = shell_output("#{bin}/telnet india.colorado.edu 13", 1)
    assert_match "Connected to india.colorado.edu.", output
  end
end

class Webarchiver < Formula
  desc "Allows you to create Safari .webarchive files"
  homepage "https://github.com/newzealandpaul/webarchiver"
  url "https://github.com/newzealandpaul/webarchiver/archive/0.10.tar.gz"
  sha256 "06705d361ebb1de6411e4d386a01a60314aa52d5c20f64603c1b9652a3eceae4"
  head "https://github.com/newzealandpaul/webarchiver.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/webarchiver"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "f8c5615d92a4376036a30cc7bdb388088180aac6f0b303e88cc42eebb1662f2e"
  end

  depends_on xcode: ["6.0.1", :build]
  depends_on :macos

  def install
    # Force 64 bit-only build, otherwise it fails on Mojave
    xcodebuild "SYMROOT=build", "-arch", Hardware::CPU.arch

    bin.install "./build/Release/webarchiver"
  end

  test do
    system "#{bin}/webarchiver", "-url", "https://www.google.com", "-output", "foo.webarchive"
    assert_match "Apple binary property list", shell_output("file foo.webarchive")
  end
end

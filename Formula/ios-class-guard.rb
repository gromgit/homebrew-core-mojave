class IosClassGuard < Formula
  desc "Objective-C obfuscator for Mach-O executables"
  homepage "https://github.com/Polidea/ios-class-guard/"
  url "https://github.com/Polidea/ios-class-guard/archive/0.8.tar.gz"
  sha256 "4446993378f1e84ce1d1b3cbace0375661e3fe2fa1a63b9bf2c5e9370a6058ff"
  license "GPL-2.0"
  head "https://github.com/Polidea/ios-class-guard.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(0(?:\.\d+)+)$/i)
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ios-class-guard"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "75429d7820de960c336cc9bcdf3628183fe9142b4f7aa8af192e29a0eb97f0ec"
  end

  # The latest version tags in the Git repository are `0.8` (2015-10-14) and
  # `0.6` (2014-08-20) but versions before these are like `3.5` (2013-11-16),
  # `3.4` (2012-11-19), `3.3.4` (2011-09-03), etc. The older releases like `3.5`
  # are wrongly treated as newer but the GitHub repository doesn't mark a
  # "latest" release, so we can only work around this by restricting matching
  # to 0.x releases for now. If the major version reaches 1.x in the
  # future, this check will also need to be updated.

  depends_on xcode: :build

  def install
    xcodebuild "-workspace", "ios-class-guard.xcworkspace",
               "-scheme", "ios-class-guard",
               "-configuration", "Release",
               "SYMROOT=build", "PREFIX=#{prefix}", "ONLY_ACTIVE_ARCH=YES"
    bin.install "build/Release/ios-class-guard"
  end

  test do
    (testpath/"crashdump").write <<~EOS
      1   MYAPP                           0x0006573a -[C03B setR02:] + 42
    EOS
    (testpath/"symbols.json").write <<~EOS
      {
        "C03B" : "MyViewController",
        "setR02" : "setRightButtons"
      }
    EOS
    system "#{bin}/ios-class-guard", "-c", "crashdump", "-m", "symbols.json"
  end
end

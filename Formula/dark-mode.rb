class DarkMode < Formula
  desc "Control the macOS dark mode from the command-line"
  homepage "https://github.com/sindresorhus/dark-mode"
  url "https://github.com/sindresorhus/dark-mode/archive/v3.0.2.tar.gz"
  sha256 "fda7d4337fe3f0af92267fb517a17f11a267b5f8f38ec2db0c416526efd42619"
  license "MIT"
  head "https://github.com/sindresorhus/dark-mode.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dark-mode"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "1141d9f55b8fde1104019645435674b23b1f72be21e6e2b1dddad2ca2865562a"
  end


  depends_on xcode: :build
  depends_on :macos
  depends_on macos: :mojave

  def install
    # https://github.com/sindresorhus/dark-mode/blob/main/build
    Dir.mktmpdir do |tmpdir|
      xcodebuild "-arch", Hardware::CPU.arch,
                 "-derivedDataPath", tmpdir,
                 "-scheme", "dark-mode",
                 "-configuration", "Release",
                 "OBJROOT=.build",
                 "SYMROOT=.build"
    end
    bin.install ".build/Release/dark-mode"
  end

  test do
    assert_match(/\A(on|off)\z/, shell_output("#{bin}/dark-mode status").chomp)
  end
end

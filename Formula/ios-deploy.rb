class IosDeploy < Formula
  desc "Install and debug iPhone apps from the command-line"
  homepage "https://github.com/ios-control/ios-deploy"
  license all_of: ["GPL-3.0-or-later", "BSD-3-Clause"]
  head "https://github.com/ios-control/ios-deploy.git", branch: "master"

  stable do
    url "https://github.com/ios-control/ios-deploy/archive/1.12.1.tar.gz"
    sha256 "635cc36b027ec36cd9f5ebd4136f0e1274caa60049c1f6e4fd15d45d7bef5bc3"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ios-deploy"
    sha256 cellar: :any_skip_relocation, mojave: "8c80453647b8dcb5229de34e77f399bc60b494b7dc29da4851173979317bd35c"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-configuration", "Release",
               "SYMROOT=build",
               "-arch", Hardware::CPU.arch

    xcodebuild "test",
               "-scheme", "ios-deploy-tests",
               "-configuration", "Release",
               "SYMROOT=build",
               "-arch", Hardware::CPU.arch

    bin.install "build/Release/ios-deploy"
  end

  test do
    system "#{bin}/ios-deploy", "-V"
  end
end

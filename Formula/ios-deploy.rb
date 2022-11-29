class IosDeploy < Formula
  desc "Install and debug iPhone apps from the command-line"
  homepage "https://github.com/ios-control/ios-deploy"
  license all_of: ["GPL-3.0-or-later", "BSD-3-Clause"]
  head "https://github.com/ios-control/ios-deploy.git", branch: "master"

  stable do
    url "https://github.com/ios-control/ios-deploy/archive/refs/tags/1.12.0.tar.gz"
    sha256 "49f4835e365f6c5c986af3f4bd5c1858c1a1d110aa7f9cf45649c3617911c508"

    # fix build failure, remove in next release
    patch do
      url "https://github.com/ios-control/ios-deploy/commit/24c9efbd43f2acd25c0f3e85137e29ec3c1654cf.patch?full_index=1"
      sha256 "efc223ca219fb64c06155b1675a8a81d57ee42c18ff210c070d8d6f37c893b07"
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ios-deploy"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "39155833ffcb9ef99fdf8dd326467d9a22072c1d24ccea8d651a1f03e9a4b933"
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

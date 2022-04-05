class Mogenerator < Formula
  desc "Generate Objective-C & Swift classes from your Core Data model"
  homepage "https://rentzsch.github.io/mogenerator/"
  url "https://github.com/rentzsch/mogenerator/archive/1.32.tar.gz"
  sha256 "4fa660a19934d94d7ef35626d68ada9912d925416395a6bf4497bd7df35d7a8b"
  license "MIT"
  head "https://github.com/rentzsch/mogenerator.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mogenerator"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "36fa0bc82189dcb55b047ab197eb9cbc7d2347fea2a8ddef289707524432a13f"
  end

  depends_on xcode: :build

  # https://github.com/rentzsch/mogenerator/pull/390
  patch do
    url "https://github.com/rentzsch/mogenerator/commit/20d9cce6df8380160cac0ce07687688076fddf3d.patch?full_index=1"
    sha256 "de700f06c32cc0d4fbcb1cdd91e9e97a55931bc047841985d5c0905e65b5e5b0"
  end

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
               "-target", "mogenerator",
               "-configuration", "Release",
               "SYMROOT=symroot",
               "OBJROOT=objroot"
    bin.install "symroot/Release/mogenerator"
  end

  test do
    system "#{bin}/mogenerator", "--version"
  end
end

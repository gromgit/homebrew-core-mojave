class ImgurScreenshot < Formula
  desc "Take screenshot selection, upload to imgur. + more cool things"
  homepage "https://github.com/jomo/imgur-screenshot"
  url "https://github.com/jomo/imgur-screenshot/archive/v2.0.0.tar.gz"
  sha256 "1581b3d71e9d6c022362c461aa78ea123b60b519996ed068e25a4ccf5a3409f5"
  license "MIT"
  head "https://github.com/jomo/imgur-screenshot.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/imgur-screenshot"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "9824e2339c27c1dba9a36971b844adca76a9f0145c2c610996c22ae0f200fd62"
  end

  depends_on "bash"
  depends_on "jq"
  depends_on "terminal-notifier"

  uses_from_macos "curl"

  def install
    bin.install "imgur-screenshot"
    bin.install_symlink "imgur-screenshot" => "imgur-screenshot.sh"
  end

  test do
    # Check deps
    args = %w[
      --open false
      --auto-delete 1
    ]
    system bin/"imgur-screenshot", *args, test_fixtures("test.jpg")
    system bin/"imgur-screenshot.sh", *args, test_fixtures("test.png")
  end
end

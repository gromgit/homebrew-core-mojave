class MacosTrash < Formula
  desc "Move files and folders to the trash"
  homepage "https://github.com/sindresorhus/macos-trash"
  url "https://github.com/sindresorhus/macos-trash/archive/v1.2.0.tar.gz"
  sha256 "c4472b5c8024806720779bc867da1958fe871fbd93d200af8a2cc4ad1941be28"
  license "MIT"
  head "https://github.com/sindresorhus/macos-trash.git", branch: "main"

  bottle do
    sha256 mojave: "f27baf8ae2f171b8f7236ee399bb9df7da423c4ef81b68d7e0ece78df850d204" # fake mojave
  end

  depends_on xcode: ["12.0", :build]
  depends_on :macos
  uses_from_macos "swift", since: :big_sur # Swift 5.5.0

  conflicts_with "trash", because: "both install a `trash` binary"
  conflicts_with "trash-cli", because: "both install a `trash` binary"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/trash"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trash --version")
    system "#{bin}/trash", "--help"
  end
end

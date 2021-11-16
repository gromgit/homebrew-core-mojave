class MacosTrash < Formula
  desc "Move files and folders to the trash"
  homepage "https://github.com/sindresorhus/macos-trash"
  url "https://github.com/sindresorhus/macos-trash/archive/v1.1.1.tar.gz"
  sha256 "e215bda0c485c89a893b5ad8f4087b99b78b3616f26f0c8da3f0bb09022136dc"
  license "MIT"
  head "https://github.com/sindresorhus/macos-trash.git"


  depends_on xcode: ["12.0", :build]
  depends_on :macos

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

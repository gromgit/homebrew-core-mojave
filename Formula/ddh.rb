class Ddh < Formula
  desc "Fast duplicate file finder"
  homepage "https://github.com/darakian/ddh"
  url "https://github.com/darakian/ddh/archive/refs/tags/0.13.0.tar.gz"
  sha256 "87010f845fa68945d2def4a05a3eb796222b67c5d3cea41e576cfaf2ab078ef8"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ddh"
    sha256 cellar: :any_skip_relocation, mojave: "ed62dc9b03d277b3dfe6cd5d218291273da9ea326f951d0e8bc9a721c8290bc0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test/file1").write "brew test"
    (testpath/"test/file2").write "brew test"

    expected = <<~EOS
      2 Total files (with duplicates): 0 Kilobytes
      1 Total files (without duplicates): 0 Kilobytes
      0 Single instance files: 0 Kilobytes
      1 Shared instance files: 0 Kilobytes (2 instances)
      Standard results written to Results.txt
    EOS

    assert_equal expected, shell_output("#{bin}/ddh -d test")

    assert_match "Duplicates", (testpath/"Results.txt").read
  end
end

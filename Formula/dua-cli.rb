class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "02de8d80347405a876867901bd16539b7d7ceac3095cabcbf9abae3d7da1f357"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dua-cli"
    sha256 cellar: :any_skip_relocation, mojave: "c94c0709de24881e19c84a1db4be26a72d30985270d1fb2e7d2e11d043ddbf01"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    # The "-EOS" is needed instead of "~EOS" in order to keep
    # the expected indentation at the start of each line.
    expected = <<-EOS
      0  B #{testpath}/empty.txt
      2  B #{testpath}/file.txt
      2  B total
    EOS

    assert_equal expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end

class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "fcbf2d9dbcdad2db17d2a3b690fb05d69ad3953237f2971d546d341339bf6271"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dua-cli"
    sha256 cellar: :any_skip_relocation, mojave: "317da11b34bae18b2e206620ba3482a9857d900363e6adf2eac34775bc0215f5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    expected = <<~EOS
      \e[32m      0  B\e[39m #{testpath}/empty.txt
      \e[32m      2  B\e[39m #{testpath}/file.txt
      \e[32m      2  B\e[39m total
    EOS

    assert_equal expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end

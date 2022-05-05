class Ddh < Formula
  desc "Fast duplicate file finder"
  homepage "https://github.com/darakian/ddh"
  url "https://github.com/darakian/ddh/archive/refs/tags/0.12.0.tar.gz"
  sha256 "f16dd4da04852670912c1b3fd65ce9b6ebd01ba2d0df97cb8c9bdf91ba453384"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ddh"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "771c6c56a3bb413376ad9362e2a8a700d2d7551e9bd002c9fdc4f074f3910cde"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test/file1").write "brew test"
    (testpath/"test/file2").write "brew test"

    expected = <<~EOS
      2 Total files (with duplicates): 0 Megabytes
      1 Total files (without duplicates): 0 Megabytes
      0 Single instance files: 0 Megabytes
      1 Shared instance files: 0 Megabytes (2 instances)
      Standard results written to Results.txt
    EOS

    assert_equal expected, shell_output("#{bin}/ddh -d test")

    assert_match "Duplicates", (testpath/"Results.txt").read
  end
end

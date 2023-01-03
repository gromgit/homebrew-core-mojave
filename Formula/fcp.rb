class Fcp < Formula
  desc "Significantly faster alternative to the classic Unix cp(1) command"
  homepage "https://github.com/Svetlitski/fcp/"
  url "https://github.com/Svetlitski/fcp/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "e835d014849f5a3431a0798bcac02332915084bf4f4070fb1c6914b1865295f2"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fcp"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "2a43e9b47bfd613dc3eb0f6663a12af191fa337764372db4c536e8b5d9e080e5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"src.old").write "Hello world!"
    system bin/"fcp", "src.old", "dest.txt"
    assert_equal (testpath/"src.old").read, (testpath/"dest.txt").read

    (testpath/"src.new").write "Hello Homebrew!"
    system bin/"fcp", "src.new", "dest.txt"
    assert_equal (testpath/"src.new").read, (testpath/"dest.txt").read

    ["foo", "bar", "baz"].each { |f| (testpath/f).write f }
    (testpath/"dest_dir").mkdir
    system bin/"fcp", "foo", "bar", "baz", "dest_dir/"
    assert_equal (testpath/"foo").read, (testpath/"dest_dir/foo").read
    assert_equal (testpath/"bar").read, (testpath/"dest_dir/bar").read
    assert_equal (testpath/"baz").read, (testpath/"dest_dir/baz").read
  end
end

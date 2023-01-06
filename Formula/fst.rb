class Fst < Formula
  desc "Represent large sets and maps compactly with finite state transducers"
  homepage "https://github.com/BurntSushi/fst"
  url "https://github.com/BurntSushi/fst/archive/refs/tags/fst-bin-0.4.2.tar.gz"
  sha256 "15eca6442021c7a4eeb64891515b9fe6cef7cf3f39eb72fb02042c90cae8ae1f"
  license any_of: ["Unlicense", "MIT"]
  head "https://github.com/BurntSushi/fst.git", branch: "master"

  livecheck do
    url :stable
    regex(/^fst-bin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fst"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "0e892468f34e73b55ce24415bd1a0283b15ac9676c02dd89ff24c121496cb9b8"
  end

  depends_on "rust" => :build

  def install
    cd "fst-bin" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"map.csv").write <<~EOF
      four,4
      one,1
      twenty,20
      two,2
    EOF
    expected = <<~EOF
      twenty,20
      two,2
    EOF
    system bin/"fst", "map", "--sorted", testpath/"map.csv", testpath/"map.fst"
    assert_predicate testpath/"map.fst", :exist?
    system bin/"fst", "verify", testpath/"map.fst"
    assert_equal expected, shell_output("#{bin}/fst grep -o #{testpath}/map.fst 'tw.*'")
  end
end

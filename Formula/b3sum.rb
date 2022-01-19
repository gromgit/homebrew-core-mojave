class B3sum < Formula
  desc "BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/1.3.0.tar.gz"
  sha256 "a559309c2dad8cc8314ea779664ec5093c79de2e9be14edbf76ae2ce380222c0"
  license "CC0-1.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/b3sum"
    sha256 cellar: :any_skip_relocation, mojave: "91eff732aa404fdbd192d8b3f7ed3c412094709853401edb96a196ecd8c819a1"
  end

  depends_on "rust" => :build

  def install
    cd "b3sum" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.txt").write <<~EOS
      content
    EOS

    output = shell_output("#{bin}/b3sum test.txt")
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  test.txt", output.strip
  end
end

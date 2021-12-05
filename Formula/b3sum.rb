class B3sum < Formula
  desc "BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/1.2.0.tar.gz"
  sha256 "2873f42f89c0553b7105bda4b3edb93584ba3a163b31bbfae6b6e1bc203ca8c3"
  license "CC0-1.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/b3sum"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "63c1cb8b19848c8ad17174de02ceae0a3a63f4dce8a1c03e8f66f49a934e7696"
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

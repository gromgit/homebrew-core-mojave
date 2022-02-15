class B3sum < Formula
  desc "BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/1.3.1.tar.gz"
  sha256 "112becf0983b5c83efff07f20b458f2dbcdbd768fd46502e7ddd831b83550109"
  license "CC0-1.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/b3sum"
    sha256 cellar: :any_skip_relocation, mojave: "a4c1ffc9976449252b38594939fda726413362f8770348b01346d78c078458b5"
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

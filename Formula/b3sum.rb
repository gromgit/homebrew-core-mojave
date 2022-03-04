class B3sum < Formula
  desc "BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/1.3.1.tar.gz"
  sha256 "112becf0983b5c83efff07f20b458f2dbcdbd768fd46502e7ddd831b83550109"
  license "CC0-1.0"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/b3sum"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "9b545bf59bdfb4e4bf887fc651b032ba196db08c7cf43c0665dfdc9a43405787"
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

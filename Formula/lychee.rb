class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://github.com/lycheeverse/lychee"
  url "https://github.com/lycheeverse/lychee/archive/v0.8.0.tar.gz"
  sha256 "bac7a31011aa46b5f239ef34bb33b7a87e07de35ed06c4e1cc83a8fa1d03b466"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lychee"
    rebuild 1
    sha256 cellar: :any, mojave: "12ac5f7f3249cbc4f24009b3ca59db953fa0cf34a8f5b39da3cad1e9c1824630"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "lychee-bin" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.md").write "[This](https://example.com) is an example.\n"
    output = shell_output("#{bin}/lychee #{testpath}/test.md")
    assert_match(/Total\.*1\n.*Successful\.*1\n/, output)
  end
end

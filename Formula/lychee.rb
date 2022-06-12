class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://github.com/lycheeverse/lychee"
  url "https://github.com/lycheeverse/lychee/archive/v0.10.0.tar.gz"
  sha256 "e7f8ae04c0d4714c4116f5cfccc41fef4b469d22c568a4f509c949378b30cafb"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lychee"
    sha256 cellar: :any, mojave: "b6d43909b5b2835565c8861cdb27ca5d7a08148c4b76a536c17a5b047b24cdaa"
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
    output = shell_output(bin/"lychee #{testpath}/test.md")
    assert_match "🔍 1 Total ✅ 0 OK 🚫 0 Errors 💤 1 Excluded", output
  end
end

class Curlie < Formula
  desc "Power of curl, ease of use of httpie"
  homepage "https://curlie.io"
  url "https://github.com/rs/curlie/archive/v1.6.7.tar.gz"
  sha256 "25a0ea35be6ff9dd88551c992a0f7ea565ce2fae8213c674bd28a7cc512493d9"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/curlie"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "26c0fe81114ab2e9412aba48f97bd1315342420ebc252629d41b9799f19fa5b6"
  end

  depends_on "go" => :build

  uses_from_macos "curl"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "httpbin.org",
      shell_output("#{bin}/curlie -X GET httpbin.org/headers 2>&1")
  end
end

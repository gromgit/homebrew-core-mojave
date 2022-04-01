class Curlie < Formula
  desc "Power of curl, ease of use of httpie"
  homepage "https://curlie.io"
  url "https://github.com/rs/curlie/archive/v1.6.7.tar.gz"
  sha256 "25a0ea35be6ff9dd88551c992a0f7ea565ce2fae8213c674bd28a7cc512493d9"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/curlie"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "695cc00f9256182edcc9d6b7a7260529c56a638b8b49593c89adb20548326806"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  uses_from_macos "curl"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "httpbin.org",
      shell_output("#{bin}/curlie -X GET httpbin.org/headers 2>&1")
  end
end

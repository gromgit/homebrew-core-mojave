class Oauth2l < Formula
  desc "Simple CLI for interacting with Google oauth tokens"
  homepage "https://github.com/google/oauth2l"
  url "https://github.com/google/oauth2l/archive/v1.3.0.tar.gz"
  sha256 "3f708e3fab87c6ae50e0608b02b01a66ce427a4097f3a73f1fa8c6ea43839110"
  license "Apache-2.0"
  head "https://github.com/google/oauth2l.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/oauth2l"
    sha256 cellar: :any_skip_relocation, mojave: "8c3c2f843f22742b25745f3103ea0e45c71190c882bd5804e58ac3698215a12f"
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"

    system "go", "build", "-o", "oauth2l"
    bin.install "oauth2l"
  end

  test do
    assert_match "Invalid Value",
      shell_output("#{bin}/oauth2l info abcd1234")
  end
end

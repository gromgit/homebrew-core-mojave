class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v4.9.0.tar.gz"
  sha256 "e54b21f8e12a98af7476cf376a1b816889d2a9424bd80ec367abb5d6eaf0e4c1"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lego"
    sha256 cellar: :any_skip_relocation, mojave: "2d3ad3be53107fe972e6dd39a938058a51bddc3766c54105d67b76306244a50b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/lego"
  end

  test do
    output = shell_output("lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output("DO_AUTH_TOKEN=xx lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end

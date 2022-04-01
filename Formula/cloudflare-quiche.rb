class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.12.0",
      revision: "6437b3c2db0dd3c1d6c76cb71d784c874b185d01"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cloudflare-quiche"
    sha256 cellar: :any_skip_relocation, mojave: "bd95e62d8c44748a5601eb51a0bab48df4798e9a16831118557cb8a2d82f973a"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps")
  end

  test do
    assert_match "it does support HTTP/3!", shell_output("#{bin}/quiche-client https://http3.is/")
  end
end

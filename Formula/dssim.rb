class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/kornelski/dssim"
  url "https://github.com/kornelski/dssim/archive/3.2.4.tar.gz"
  sha256 "f58d834876ebcc8e5f21e94e0db42b173d2bea600642cbbbb6dab16a6b5d7537"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dssim"
    sha256 cellar: :any_skip_relocation, mojave: "6aead033c709c47160947286cc4c3bb8c25041e5f99034fc5becf8f9d5fea57b"
  end

  depends_on "nasm" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end

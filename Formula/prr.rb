class Prr < Formula
  desc "Mailing list style code reviews for github"
  homepage "https://github.com/danobi/prr"
  url "https://github.com/danobi/prr/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "0506ade022a7e4be858cdc4048d82a80587f9ca7ebd78c5a652baa1e967cf41e"
  license "GPL-2.0-only"
  head "https://github.com/danobi/prr.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/prr"
    sha256 cellar: :any_skip_relocation, mojave: "b45abaa94d54b7af194775a90034b2d33389a9f7c72e59c5ed8d6105727c39c0"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Failed to read config", shell_output("#{bin}/prr get Homebrew/homebrew-core/6 2>&1", 1)
  end
end

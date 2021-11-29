class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://sheldon.cli.rs"
  url "https://github.com/rossmacarthur/sheldon/archive/0.6.5.tar.gz"
  sha256 "f546eedce0a81aad5972671eded7c743c6abcc812ccf17b610d1b53e9331779e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git", branch: "trunk"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sheldon"
    rebuild 1
    sha256 cellar: :any, mojave: "a10e7ad8cdbbd89036e9071cb6ee6463d193895849e64d30032c24f4374d66e0"
  end

  depends_on "rust" => :build
  depends_on "curl"
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"plugins.toml"
    system "#{bin}/sheldon", "--home", testpath, "--config-dir", testpath, "--data-dir", testpath, "lock"
    assert_predicate testpath/"plugins.lock", :exist?
  end
end

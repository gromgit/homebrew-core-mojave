class Sheldon < Formula
  desc "Fast, configurable, shell plugin manager"
  homepage "https://sheldon.cli.rs"
  url "https://github.com/rossmacarthur/sheldon/archive/0.6.6.tar.gz"
  sha256 "9d6cdc8fe011c4defe65fbe1507e48a51f8efdeebb5d5b0b39fbde2c73566973"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rossmacarthur/sheldon.git", branch: "trunk"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sheldon"
    sha256 cellar: :any, mojave: "54eb44d6892c0d7929699219a861d4ee7e9ebbed5cac9188628ecafc2091c9d8"
  end

  depends_on "rust" => :build
  depends_on "curl"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/sheldon.bash" => "sheldon"
    zsh_completion.install "completions/sheldon.zsh" => "_sheldon"
  end

  test do
    touch testpath/"plugins.toml"
    system "#{bin}/sheldon", "--home", testpath, "--config-dir", testpath, "--data-dir", testpath, "lock"
    assert_predicate testpath/"plugins.lock", :exist?
  end
end

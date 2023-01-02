class Dura < Formula
  desc "Backs up your work automatically via Git commits"
  homepage "https://github.com/tkellogg/dura"
  url "https://github.com/tkellogg/dura/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "6486afa167cc2c9b6b6646b9a3cb36e76c1a55e986f280607c8933a045d58cca"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dura"
    rebuild 1
    sha256 cellar: :any, mojave: "56f01d4c1c408af99146e5367be4ca6da6a25db7662c562ff3fd0c7c7320a439"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"dura", "serve"]
    keep_alive true
    error_log_path var/"log/dura.stderr.log"
    log_path var/"log/dura.log.json"
    working_dir var
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"
    assert_match(/commit_hash:\s+\h{40}/, shell_output("#{bin}/dura capture ."))
  end
end

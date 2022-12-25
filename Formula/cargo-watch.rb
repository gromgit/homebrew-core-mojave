class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https://watchexec.github.io/#cargo-watch"
  url "https://github.com/watchexec/cargo-watch/archive/v8.1.2.tar.gz"
  sha256 "6fe6a45c9acddeb2e8baab84f93fc8bdb04e141639859c52715cba7e57665e97"
  license "CC0-1.0"
  head "https://github.com/watchexec/cargo-watch.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cargo-watch"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "7dbe31bcd6bec0dba0f1fbe82477a6fca79c9ae57bafe7efb90881513139e57e"
  end

  depends_on "rust" => [:build, :test]

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cargo-watch -x build 2>&1", 1)
    assert_match "error: project root does not exist", output

    assert_equal "cargo-watch #{version}", shell_output("#{bin}/cargo-watch --version").strip
  end
end

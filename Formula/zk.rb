class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://github.com/mickael-menu/zk"
  url "https://github.com/mickael-menu/zk/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "102754f2722e7e4ff0a83715085c8bfdac090b440f89020123481a95b566730f"
  license "GPL-3.0-only"

  head "https://github.com/mickael-menu/zk.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/zk"
    sha256 cellar: :any, mojave: "9a6aa05d6b59f77b0da2ff6b6182e6e281aaf2d03c18d8d212d63c8d070fae8c"
  end

  depends_on "go" => :build

  depends_on "icu4c"
  uses_from_macos "sqlite"

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.Version=#{version} -X=main.Build=#{tap.user}"), "-tags", "fts5,icu"
  end

  test do
    system "#{bin}/zk", "init", "--no-input"
    system "#{bin}/zk", "index", "--no-input"
    (testpath/"testnote.md").write "note content"
    (testpath/"anothernote.md").write "todolist"

    output = pipe_output("#{bin}/zk list --quiet").chomp
    assert_match "note content", output
    assert_match "todolist", output
  end
end

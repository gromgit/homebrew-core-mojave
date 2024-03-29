class Zk < Formula
  desc "Plain text note-taking assistant"
  homepage "https://github.com/mickael-menu/zk"
  url "https://github.com/mickael-menu/zk/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "c38e88cbf8a6b1a00df51e1d87d6dbff4d13279c18bfef6ed275e7dc28dce0d8"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/mickael-menu/zk.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/zk"
    sha256 cellar: :any, mojave: "49e31bcaffcfbc12eb8bd33e05b56f722d9d02479123e5f741739efc245bdf2a"
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

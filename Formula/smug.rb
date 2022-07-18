class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://github.com/ivaaaan/smug/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "0cc7ffe94e5f0a8b2a2ea61bb44429c6959ccf5a399a0eab6ab6c6fab3b81301"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/smug"
    sha256 cellar: :any_skip_relocation, mojave: "c54a4fc4afa0d2e52b719fb511eed281e7450b0f2454c5da107f4d8061ff84c2"
  end

  depends_on "go" => :build
  depends_on "tmux" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    (testpath/"test.yml").write <<~EOF
      session: homebrew-test-session
      windows:
        - name: test
    EOF

    assert_equal(version, shell_output("smug").lines.first.split("Version").last.chomp)

    with_env(TERM: "screen-256color") do
      system bin/"smug", "start", "--file", testpath/"test.yml", "--detach"
    end

    assert_empty shell_output("tmux has-session -t homebrew-test-session")
    system "tmux", "kill-session", "-t", "homebrew-test-session"
  end
end

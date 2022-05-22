class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://github.com/ivaaaan/smug/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "391fa8b6a427f7bf3f98669222ad0053ce8dc237bdb67bf2cdee0ca2f4597b8b"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/smug"
    sha256 cellar: :any_skip_relocation, mojave: "ec191d8677d226796f9e38970306f1243bff2b27719550e3615e00753fb91cbe"
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

class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://github.com/ivaaaan/smug/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "cf9b4a8a040dd97a483ce45a6ceda729faec746d38ed3b60962bd9a84db5e5b4"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/smug"
    sha256 cellar: :any_skip_relocation, mojave: "bcb9d1817a4fb57b48515ede944c604481013e079b5cc69468d217cd860b6eb6"
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

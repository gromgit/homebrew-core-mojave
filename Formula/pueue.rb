class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v2.0.2.tar.gz"
  sha256 "92e54105f840d973d048c280a9320c8740d205770d82f8ca882a4eb5716c4136"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pueue"
    sha256 cellar: :any_skip_relocation, mojave: "bc55fcc595ff5bee1de75c94535f9a354ef5f6dc8f894ae4536d173f0f47e834"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    mkdir "utils/completions" do
      system "#{bin}/pueue", "completions", "bash", "."
      bash_completion.install "pueue.bash" => "pueue"
      system "#{bin}/pueue", "completions", "fish", "."
      fish_completion.install "pueue.fish" => "pueue.fish"
      system "#{bin}/pueue", "completions", "zsh", "."
      zsh_completion.install "_pueue" => "_pueue"
    end

    prefix.install_metafiles
  end

  service do
    run [opt_bin/"pueued", "--verbose"]
    keep_alive false
    working_dir var
    log_path var/"log/pueued.log"
    error_log_path var/"log/pueued.log"
  end

  test do
    pid = fork do
      exec bin/"pueued"
    end
    sleep 2

    begin
      mkdir testpath/"Library/Preferences" # For macOS
      mkdir testpath/".config" # For Linux

      output = shell_output("#{bin}/pueue status")
      assert_match "Task list is empty. Add tasks with `pueue add -- [cmd]`", output

      output = shell_output("#{bin}/pueue add x")
      assert_match "New task added (id 0).", output

      output = shell_output("#{bin}/pueue status")
      assert_match "(1 parallel): running", output
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "Pueue daemon #{version}", shell_output("#{bin}/pueued --version")
    assert_match "Pueue client #{version}", shell_output("#{bin}/pueue --version")
  end
end

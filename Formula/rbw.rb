class Rbw < Formula
  desc "Unoffical Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://github.com/doy/rbw/archive/refs/tags/1.4.1.tar.gz"
  sha256 "70c55c1341f4181f8974f99ec24ee1caf918487135cfa578566d9e6c44eb47b0"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rbw"
    sha256 cellar: :any_skip_relocation, mojave: "68c1d6e9e38aa97a8197c7017a06fe63b76aed2ca02851b4596b7c25c1550f4f"
  end

  depends_on "rust" => :build
  depends_on "pinentry"

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read(bin/"rbw", "gen-completions", "bash")
    (bash_completion/"rbw").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"rbw", "gen-completions", "zsh")
    (zsh_completion/"_rbw").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"rbw", "gen-completions", "fish")
    (fish_completion/"rbw.fish").write fish_output
  end

  test do
    expected = "ERROR: Before using rbw"
    output = shell_output("#{bin}/rbw ls 2>&1 > /dev/null", 1).each_line.first.strip
    assert_match expected, output
  end
end

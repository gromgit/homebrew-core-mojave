class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/v2.11.2030.tar.gz"
  sha256 "5d7dadc2d48bde20fe2239d8087612eccaa310b0f88863bdae2288b30388dff7"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/murex"
    sha256 cellar: :any_skip_relocation, mojave: "dd49e040344ee62d0f7565ea1c07465229a8e63478b531241eb55604268765dd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/murex", "--run-tests"
    assert_equal "homebrew", shell_output("#{bin}/murex -c 'echo homebrew'").chomp
  end
end

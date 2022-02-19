class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https://murex.rocks"
  url "https://github.com/lmorg/murex/archive/v2.5.2020.tar.gz"
  sha256 "d4cc4dd698b5b54972780dfd4d4e22c5fdccccc917ba58e8e202eb6e7ac926af"
  license "GPL-2.0-only"
  head "https://github.com/lmorg/murex.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/murex"
    sha256 cellar: :any_skip_relocation, mojave: "36da0548a436158bf9a5480919658723aee41f6b0ac4ac9891edfb301c8b2521"
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

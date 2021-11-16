class Repl < Formula
  desc "Wrap non-interactive programs with a REPL"
  homepage "https://github.com/defunkt/repl"
  url "https://github.com/defunkt/repl/archive/v1.0.0.tar.gz"
  sha256 "d0542404f03159b0d6eb22a1aa4a509714c87c8594fca5121c578d50d950307d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "497a5e7b673fbd288181f823e1b1a7ba71770b6d3da82bd66ac100c60b0295b3"
  end

  def install
    bin.install "bin/repl"
    man1.install "man/repl.1"
  end

  test do
    pipe_output("#{bin}/repl git", "init", 0)
  end
end

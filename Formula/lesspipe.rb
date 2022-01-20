class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://github.com/wofr06/lesspipe/archive/v2.02.tar.gz"
  sha256 "f66da17dce756d06087ca0d9ff98f97e29cd3d026613853b60c174aa6fa0fd47"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "809f54e556c9288bf10d9acf5089dd4880aacc701eb444c09296cb410f74fab5"
  end

  def install
    inreplace "configure", "/etc/bash_completion.d", bash_completion
    system "./configure", "--prefix=#{prefix}", "--yes"
    man1.mkpath
    system "make", "install"
  end

  def caveats
    <<~EOS
      Append the following to your #{shell_profile}:
      export LESSOPEN="|#{HOMEBREW_PREFIX}/bin/lesspipe.sh %s"
    EOS
  end

  test do
    touch "file1.txt"
    touch "file2.txt"
    system "tar", "-cvzf", "homebrew.tar.gz", "file1.txt", "file2.txt"

    assert_predicate testpath/"homebrew.tar.gz", :exist?
    assert_match "file2.txt", pipe_output(bin/"archive_color", shell_output("tar -tvzf homebrew.tar.gz"))
  end
end

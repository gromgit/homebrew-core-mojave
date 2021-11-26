class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.165.1.tar.gz"
  sha256 "8750e7f6c8b9c05d317a4c9bc3d9bf33a575c27aa0e1c1eb99f7e5378cd55108"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/flow"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "c789d9fdefa0db02e8b47d98d10c901bcf2f5d02ef9d24d90a19fb338fd8dd06"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end

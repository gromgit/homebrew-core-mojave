class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.166.1.tar.gz"
  sha256 "45ed148e2862023b79259c11a75b5d7339115ae29c97b6f4e5a3411f1d2ecfaf"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/flow"
    sha256 cellar: :any_skip_relocation, mojave: "867d3e9329663e9212c6104087b8994d8981da2dae105c9b17654ae8667e629c"
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

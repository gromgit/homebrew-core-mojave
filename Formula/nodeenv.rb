class Nodeenv < Formula
  include Language::Python::Shebang

  desc "Node.js virtual environment builder"
  homepage "https://github.com/ekalinin/nodeenv"
  url "https://github.com/ekalinin/nodeenv/archive/1.7.0.tar.gz"
  sha256 "a9e9e36e1be6439e877c53e7f27ce068f75b82cc08201f2c68471687199cfd7b"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nodeenv"
    sha256 cellar: :any_skip_relocation, mojave: "b62820fdf34eb99d433736cc707c41a506f404ff2043418b62a4ab47a46fe99d"
  end

  uses_from_macos "python"

  def install
    rw_info = OS.mac? ? python_shebang_rewrite_info("/usr/bin/env python3") : detected_python_shebang
    rewrite_shebang rw_info, "nodeenv.py"
    bin.install "nodeenv.py" => "nodeenv"
  end

  test do
    system bin/"nodeenv", "--node=16.0.0", "--prebuilt", "env-16.0.0-prebuilt"
    # Dropping into the virtualenv itself requires sourcing activate which
    # isn't easy to deal with. This ensures current Node installed & functional.
    ENV.prepend_path "PATH", testpath/"env-16.0.0-prebuilt/bin"

    (testpath/"test.js").write "console.log('hello');"
    assert_match "hello", shell_output("node test.js")
    assert_match "v16.0.0", shell_output("node -v")
  end
end

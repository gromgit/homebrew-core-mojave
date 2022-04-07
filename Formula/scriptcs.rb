class Scriptcs < Formula
  desc "Tools to write and execute C#"
  homepage "https://github.com/scriptcs/scriptcs"
  url "https://github.com/scriptcs/scriptcs/archive/v0.17.1.tar.gz"
  sha256 "e876118d82f52cbdd9569783ec9278c4ac449055aa628cdcb2d785bf8098a434"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/scriptcs"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "25b02d1fea63e74c038531cddd88fd84c0646773df37ab672b52c6f996f3b500"
  end

  depends_on "mono"

  def install
    script_file = "scriptcs.sh"
    system "sh", "./build_brew.sh"
    libexec.install Dir["src/ScriptCs/bin/Release/*"]
    (libexec/script_file).write <<~EOS
      #!/bin/bash
      mono #{libexec}/scriptcs.exe $@
    EOS
    (libexec/script_file).chmod 0755
    bin.install_symlink libexec/script_file => "scriptcs"
  end

  test do
    test_file = "tests.csx"
    (testpath/test_file).write('Console.WriteLine("{0}, {1}!", "Hello", "world");')
    assert_equal "Hello, world!", `scriptcs #{test_file}`.strip
  end
end

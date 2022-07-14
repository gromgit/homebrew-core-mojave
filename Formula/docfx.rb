class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/releases/download/v2.59.3/docfx.zip"
  sha256 "129ab6f8f3683d258ab84771f7ebfd3c18cbcd4bae10e6e138dbe3c233dcaec1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0ac1f562ede21e10b7dd57fbccd76d673ef346c6d16fa5a85025041d6d217ffb"
  end

  depends_on "mono"

  def install
    libexec.install Dir["*"]

    (bin/"docfx").write <<~EOS
      #!/bin/bash
      mono #{libexec}/docfx.exe "$@"
    EOS
  end

  test do
    system bin/"docfx", "init", "-q"
    assert_predicate testpath/"docfx_project/docfx.json", :exist?,
                     "Failed to generate project"
  end
end

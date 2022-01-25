class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/releases/download/v2.59.0/docfx.zip"
  sha256 "e6bd6d788ddb07d9bcb6d90f2822d7e2e6c4feb0e2caeabc60ff39232d07bc52"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9c6025656fe2c6df716b216976427cc0c768ff31cbdd1c36c0d3a7d8777357a6"
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

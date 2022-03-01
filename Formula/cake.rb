class Cake < Formula
  desc "Cross platform build automation system with a C# DSL"
  homepage "https://cakebuild.net/"
  url "https://github.com/cake-build/cake/releases/download/v1.3.0/Cake-bin-net461-v1.3.0.zip"
  sha256 "52934fec19c02b668851b73d0fac9f3e6676be239e5bfef6af54b56fb91a244c"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cake"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "66131084e0cb86e097764898c2478d4ccc045ed80c5d11963840f2b891432327"
  end


  depends_on "mono"

  conflicts_with "coffeescript", because: "both install `cake` binaries"

  def install
    libexec.install Dir["*.dll"]
    libexec.install Dir["*.exe"]
    libexec.install Dir["*.xml"]

    bin.mkpath
    (bin/"cake").write <<~EOS
      #!/bin/bash
      mono #{libexec}/Cake.exe "$@"
    EOS
  end

  test do
    (testpath/"build.cake").write <<~EOS
      var target = Argument ("target", "info");

      Task("info").Does(() =>
      {
        Information ("Hello Homebrew");
      });

      RunTarget ("info");
    EOS
    assert_match "Hello Homebrew\n", shell_output("#{bin}/cake build.cake")
  end
end

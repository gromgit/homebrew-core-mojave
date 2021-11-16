class Ditaa < Formula
  desc "Convert ASCII diagrams into proper bitmap graphics"
  homepage "https://ditaa.sourceforge.io/"
  url "https://github.com/stathissideris/ditaa/releases/download/v0.11.0/ditaa-0.11.0-standalone.jar"
  sha256 "9418aa63ff6d89c5d2318396f59836e120e75bea7a5930c4d34aa10fe7a196a9"
  license "LGPL-3.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d436c5a9b3d8ccd94a2c4da1ed06ae544e71278d32e911db402f51fd5f2db089"
  end

  depends_on "openjdk"

  def install
    libexec.install "ditaa-#{version}-standalone.jar"
    (bin/"ditaa").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" -jar "#{libexec}/ditaa-#{version}-standalone.jar" "$@"
    EOS
  end

  test do
    system "#{bin}/ditaa", "-help"
  end
end

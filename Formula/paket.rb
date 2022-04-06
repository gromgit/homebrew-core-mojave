class Paket < Formula
  desc "Dependency manager for .NET with support for NuGet and Git repositories"
  homepage "https://fsprojects.github.io/Paket/"
  url "https://github.com/fsprojects/Paket/releases/download/6.2.1/paket.exe"
  sha256 "1ff11a801e0747d4b09798caacdfb0708c6a7fa7c7b40b317a354daf012cc12e"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/paket"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "330cd6980e9b373816075815c4f3c677e6c56fbd819476df6e29410b16e9152f"
  end

  depends_on "mono"

  def install
    libexec.install "paket.exe"
    (bin/"paket").write <<~EOS
      #!/bin/bash
      mono #{libexec}/paket.exe "$@"
    EOS
  end

  test do
    test_package_id = "Paket.Test"
    test_package_version = "1.2.3"

    touch testpath/"paket.dependencies"
    touch testpath/"testfile.txt"

    system bin/"paket", "install"
    assert_predicate testpath/"paket.lock", :exist?

    (testpath/"paket.template").write <<~EOS
      type file

      id #{test_package_id}
      version #{test_package_version}
      authors Test package author

      description
          Description of this test package

      files
          testfile.txt ==> lib
    EOS

    system bin/"paket", "pack", "output", testpath
    assert_predicate testpath/"#{test_package_id}.#{test_package_version}.nupkg", :exist?
  end
end

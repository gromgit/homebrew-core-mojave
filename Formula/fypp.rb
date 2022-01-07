class Fypp < Formula
  include Language::Python::Virtualenv

  desc "Python powered Fortran preprocessor"
  homepage "https://fypp.readthedocs.io/en/stable/"
  url "https://github.com/aradi/fypp/archive/refs/tags/3.1.tar.gz"
  sha256 "0f66e849869632978a8a0623ee510bb860a74004fdabfbfb542656c6c1a7eb5a"
  license "BSD-2-Clause"
  head "https://github.com/aradi/fypp.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fypp"
    sha256 cellar: :any_skip_relocation, mojave: "20d62a61da2cc4ff53250237b0545572ace9952699dcb23783ca398714e9beff"
  end

  depends_on "gcc" => :test
  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/fypp", "--version"
    (testpath/"hello.F90").write <<~EOS
      program hello
      #:for val in [_SYSTEM_, _MACHINE_, _FILE_, _LINE_]
        print *, '${val}$'
      #:endfor
      end
    EOS
    system "#{bin}/fypp", testpath/"hello.F90", testpath/"hello.f90"
    ENV.fortran
    system ENV.fc, testpath/"hello.f90", "-o", testpath/"hello"
    system testpath/"hello"
  end
end

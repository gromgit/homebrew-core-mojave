class Fprettify < Formula
  include Language::Python::Virtualenv

  desc "Auto-formatter for modern fortran source code"
  homepage "https://github.com/pseewald/fprettify/"
  url "https://github.com/pseewald/fprettify/archive/v0.3.7.tar.gz"
  sha256 "052da19a9080a6641d3202e10572cf3d978e6bcc0e7db29c1eb8ba724e89adc7"
  license "GPL-3.0-or-later"
  head "https://github.com/pseewald/fprettify.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fprettify"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "f1d901353f3bb5ecf7c8157335b8f4f3391e5f2394b29ece6762a98d1e79836c"
  end

  depends_on "gcc" => :test
  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/fprettify", "--version"
    (testpath/"test.f90").write <<~EOS
      program demo
      integer :: endif,if,elseif
      integer,DIMENSION(2) :: function
      endif=3;if=2
      if(endif==2)then
      endif=5
      elseif=if+4*(endif+&
      2**10)
      elseif(endif==3)then
      function(if)=elseif/endif
      print*,endif
      endif
      end program
    EOS
    system "#{bin}/fprettify", testpath/"test.f90"
    ENV.fortran
    system ENV.fc, testpath/"test.f90", "-o", testpath/"test"
    system testpath/"test"
  end
end

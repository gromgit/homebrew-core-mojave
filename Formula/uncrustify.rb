class Uncrustify < Formula
  desc "Source code beautifier"
  homepage "https://uncrustify.sourceforge.io/"
  url "https://github.com/uncrustify/uncrustify/archive/uncrustify-0.75.1.tar.gz"
  sha256 "fd14acc0a31ed88b33137bdc26d32964327488c835f885696473ef07caf2e182"
  license "GPL-2.0-or-later"
  head "https://github.com/uncrustify/uncrustify.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/uncrustify"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "beaf25a2bb6c629759b246cbfe095b165dcf615433ff5f51a4a50a5687e323ae"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  fails_with gcc: "5"

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    doc.install (buildpath/"documentation").children
  end

  test do
    (testpath/"t.c").write <<~EOS
      #include <stdio.h>
      int main(void) {return 0;}
    EOS
    expected = <<~EOS
      #include <stdio.h>
      int main(void) {
      \treturn 0;
      }
    EOS

    system "#{bin}/uncrustify", "-c", "#{doc}/htdocs/default.cfg", "t.c"
    assert_equal expected, File.read("#{testpath}/t.c.uncrustify")
  end
end

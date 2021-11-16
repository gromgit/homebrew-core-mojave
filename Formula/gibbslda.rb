class Gibbslda < Formula
  desc "Library wrapping imlib2's context API"
  homepage "https://gibbslda.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gibbslda/GibbsLDA%2B%2B/0.2/GibbsLDA%2B%2B-0.2.tar.gz"
  sha256 "4ca7b51bd2f098534f2fdf82c3f861f5d8bf92e29a6b7fbdc50c3c2baeb070ae"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8ef52ad690cdbeaaf7b4a148dc97b730585f491335aae782c2d1fbda0149e868"
    sha256 cellar: :any_skip_relocation, big_sur:       "4e088fd9bf4de22483a82b36f48fbe0f2ea8ecb16e08f2fb2cbfd6a68e0dc274"
    sha256 cellar: :any_skip_relocation, catalina:      "1531c6a6f324f3639ad798d9ae63b461812aecf0a0f3e5a4ad3ea786997c1e5d"
    sha256 cellar: :any_skip_relocation, mojave:        "2d8cab4cd368d2c12c301dae37449d9b5ce6e625b39bfa7f96d542e6390c6848"
    sha256 cellar: :any_skip_relocation, high_sierra:   "a92cdb534bb1061948417a9840addb3bda01fcbdca63ca290b34e818bd4e695c"
    sha256 cellar: :any_skip_relocation, sierra:        "9244041821944e45946fcf6a491ee1579293b4c154c7b9921b38fd6159567552"
    sha256 cellar: :any_skip_relocation, el_capitan:    "c8a95c74f3c9e967506fb386a1343459ecae8362cbf91362a7955ba017bea5fc"
    sha256 cellar: :any_skip_relocation, yosemite:      "091c214c2589c2a2a0b0dcb90f45cf993ffeeb7d7260f505ef84f1fd773b326c"
  end

  # Build fails without including stdlib - https://trac.macports.org/ticket/41915
  # https://sourceforge.net/p/gibbslda/bugs/4/
  patch :DATA

  def install
    system "make", "clean"
    system "make", "all"
    bin.install "src/lda"
    share.install "docs/GibbsLDA++Manual.pdf"
  end
end

__END__

diff --git a/src/utils.cpp b/src/utils.cpp
index e2f538b..1df5fb3 100644
--- a/src/utils.cpp
+++ b/src/utils.cpp
@@ -22,6 +22,7 @@
  */

 #include <stdio.h>
+#include <stdlib.h>
 #include <string>
 #include <map>
 #include "strtokenizer.h"

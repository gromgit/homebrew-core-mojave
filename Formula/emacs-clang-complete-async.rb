class EmacsClangCompleteAsync < Formula
  desc "Emacs plugin using libclang to complete C/C++ code"
  homepage "https://github.com/Golevka/emacs-clang-complete-async"
  license "GPL-3.0"
  revision 6
  head "https://github.com/Golevka/emacs-clang-complete-async.git", branch: "master"

  stable do
    url "https://github.com/Golevka/emacs-clang-complete-async/archive/v0.5.tar.gz"
    sha256 "151a81ae8dd9181116e564abafdef8e81d1e0085a1e85e81158d722a14f55c76"

    # https://github.com/Golevka/emacs-clang-complete-async/issues/65
    patch :DATA
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/emacs-clang-complete-async"
    rebuild 3
    sha256 cellar: :any, mojave: "c560a516449cae44848e84b3af83accaa082d2a56b93d2dac4ac489f4f0d3ff0"
  end


  depends_on "llvm"

  # https://github.com/Golevka/emacs-clang-complete-async/pull/59
  patch do
    url "https://github.com/yocchi/emacs-clang-complete-async/commit/5ce197b15d7b8c9abfc862596bf8d902116c9efe.patch?full_index=1"
    sha256 "f5057f683a9732c36fea206111507e0e373e76ee58483e6e09a0302c335090d0"
  end

  def install
    system "make"
    bin.install "clang-complete"
    share.install "auto-complete-clang-async.el"
  end
end

__END__
--- a/src/completion.h	2013-05-26 17:27:46.000000000 +0200
+++ b/src/completion.h	2014-02-11 21:40:18.000000000 +0100
@@ -3,6 +3,7 @@


 #include <clang-c/Index.h>
+#include <stdio.h>


 typedef struct __completion_Session_struct

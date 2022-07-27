class Idutils < Formula
  desc "ID database and query tools"
  homepage "https://www.gnu.org/s/idutils/"
  url "https://ftp.gnu.org/gnu/idutils/idutils-4.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/idutils/idutils-4.6.tar.xz"
  sha256 "8181f43a4fb62f6f0ccf3b84dbe9bec71ecabd6dfdcf49c6b5584521c888aac2"
  license "GPL-3.0"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/idutils"
    rebuild 3
    sha256 mojave: "6de7ee3174b593ebe39c5da439a25140cc8c73f9a9bac216d549a92300eaf31e"
  end

  conflicts_with "coreutils", because: "both install `gid` and `gid.1`"

  patch :p0 do
    on_high_sierra :or_newer do
      url "https://raw.githubusercontent.com/macports/macports-ports/b76d1e48dac/editors/nano/files/secure_snprintf.patch"
      sha256 "57f972940a10d448efbd3d5ba46e65979ae4eea93681a85e1d998060b356e0d2"
    end
  end

  # Fix build on Linux. Upstream issue:
  # https://savannah.gnu.org/bugs/?57429
  # Patch submitted here:
  # https://savannah.gnu.org/patch/index.php?10240
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-lispdir=#{elisp}"
    system "make", "install"
  end

  test do
    system bin/"mkid", "#{MacOS.sdk_path}/usr/include"
    system bin/"lid", "FILE"
  end
end

__END__
diff --git a/lib/stdio.in.h b/lib/stdio.in.h
index 0481930..79720e0 100644
--- a/lib/stdio.in.h
+++ b/lib/stdio.in.h
@@ -715,7 +715,6 @@ _GL_CXXALIASWARN (gets);
 /* It is very rare that the developer ever has full control of stdin,
    so any use of gets warrants an unconditional warning.  Assume it is
    always declared, since it is required by C89.  */
-_GL_WARN_ON_USE (gets, "gets is a security hole - use fgets instead");
 #endif

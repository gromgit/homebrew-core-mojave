class GnuTar < Formula
  desc "GNU version of the tar archiving utility"
  homepage "https://www.gnu.org/software/tar/"
  url "https://ftp.gnu.org/gnu/tar/tar-1.34.tar.gz"
  mirror "https://ftpmirror.gnu.org/tar/tar-1.34.tar.gz"
  sha256 "03d908cf5768cfe6b7ad588c921c6ed21acabfb2b79b788d1330453507647aed"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gnu-tar"
    sha256 mojave: "43eff6bebd5a5c31f75f4dfa28b211ab6caf90e8ab2034574d839d6ebb18a662"
  end

  head do
    url "https://git.savannah.gnu.org/git/tar.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  on_linux do
    depends_on "acl"
  end

  def install
    # Work around unremovable, nested dirs bug that affects lots of
    # GNU projects. See:
    # https://github.com/Homebrew/homebrew/issues/45273
    # https://github.com/Homebrew/homebrew/issues/44993
    # This is thought to be an el_capitan bug:
    # https://lists.gnu.org/archive/html/bug-tar/2015-10/msg00017.html
    ENV["gl_cv_func_getcwd_abort_bug"] = "no" if MacOS.version == :el_capitan

    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
    ]

    args << if OS.mac?
      "--program-prefix=g"
    else
      "--without-selinux"
    end
    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"

    return unless OS.mac?

    # Symlink the executable into libexec/gnubin as "tar"
    (libexec/"gnubin").install_symlink bin/"gtar" => "tar"
    (libexec/"gnuman/man1").install_symlink man1/"gtar.1" => "tar.1"
    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        GNU "tar" has been installed as "gtar".
        If you need to use it as "tar", you can add a "gnubin" directory
        to your PATH from your bashrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    (testpath/"test").write("test")
    if OS.mac?
      system bin/"gtar", "-czvf", "test.tar.gz", "test"
      assert_match "test", shell_output("#{bin}/gtar -xOzf test.tar.gz")
      assert_match "test", shell_output("#{opt_libexec}/gnubin/tar -xOzf test.tar.gz")
    else
      system bin/"tar", "-czvf", "test.tar.gz", "test"
      assert_match "test", shell_output("#{bin}/tar -xOzf test.tar.gz")
    end
  end
end

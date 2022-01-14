class Libsigsegv < Formula
  desc "Library for handling page faults in user mode"
  homepage "https://www.gnu.org/software/libsigsegv/"
  url "https://ftp.gnu.org/gnu/libsigsegv/libsigsegv-2.14.tar.gz"
  mirror "https://ftpmirror.gnu.org/libsigsegv/libsigsegv-2.14.tar.gz"
  sha256 "cdac3941803364cf81a908499beb79c200ead60b6b5b40cad124fd1e06caa295"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libsigsegv"
    sha256 cellar: :any, mojave: "9eb16b54aac87c248f8024417adf230945335fd3b09680189f352eacba8e9fbe"
  end

  head do
    url "https://git.savannah.gnu.org/git/libsigsegv.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./gitsub.sh", "pull" if build.head?
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    # Sourced from tests/efault1.c in tarball.
    (testpath/"test.c").write <<~EOS
      #include "sigsegv.h"

      #include <errno.h>
      #include <fcntl.h>
      #include <stdio.h>
      #include <stdlib.h>
      #include <unistd.h>

      const char *null_pointer = NULL;
      static int
      handler (void *fault_address, int serious)
      {
        abort ();
      }

      int
      main ()
      {
        if (open (null_pointer, O_RDONLY) != -1 || errno != EFAULT)
          {
            fprintf (stderr, "EFAULT not detected alone");
            exit (1);
          }

        if (sigsegv_install_handler (&handler) < 0)
          exit (2);

        if (open (null_pointer, O_RDONLY) != -1 || errno != EFAULT)
          {
            fprintf (stderr, "EFAULT not detected with handler");
            exit (1);
          }

        printf ("Test passed");
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lsigsegv", "-o", "test"
    assert_match "Test passed", shell_output("./test")
  end
end

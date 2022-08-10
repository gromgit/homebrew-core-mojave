class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.17.1.tar.bz2"
  sha256 "711eabf5dd661b9b04be9edc9ace2a7bc031f6bd9d37a768d02d0efdef108f5f"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gpgme"
    sha256 cellar: :any, mojave: "946d22fb31a4f2a67b738a9ef4977c2ee37bf2efa5bd91dccfa4f52f8964b915"
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "swig" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgpg-error"

  # Fix detection of Python 3.10 version string. We use Arch Linux's configure
  # patch to avoid having to regenerate with autoconf. There is an open upstream
  # PR for m4 and configure.ac changes, but it is still pending review.
  # Ref: https://dev.gnupg.org/D546
  patch do
    url "https://raw.githubusercontent.com/archlinux/svntogit-packages/6a4d7746de4670dbd245e1855584f7bb5ae10934/trunk/python310.patch"
    sha256 "5de2f6bcb6b30642d0cbc3fbd86803c9460d732f44a526f44cedee8bb78d291a"
  end

  def install
    ENV["PYTHON"] = which("python3")
    # setuptools>=60 prefers its own bundled distutils, which breaks the installation
    # Remove when distutils is no longer used. Related PR: https://dev.gnupg.org/D545
    ENV["SETUPTOOLS_USE_DISTUTILS"] = "stdlib"

    # Work around Homebrew's "prefix scheme" patch which causes non-pip installs
    # to incorrectly try to write into HOMEBREW_PREFIX/lib since Python 3.10.
    inreplace "lang/python/Makefile.in",
              /^\s*install\s*\\\n\s*--prefix "\$\(DESTDIR\)\$\(prefix\)"/,
              "\\0 --install-lib=#{prefix/Language::Python.site_packages("python3")}"

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-static"
    system "make"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpgme-config", prefix, opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gpgme-tool --lib-version")
    system Formula["python@3.10"].opt_bin/"python3", "-c", "import gpg; print(gpg.version.versionstr)"
  end
end

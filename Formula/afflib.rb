class Afflib < Formula
  desc "Advanced Forensic Format"
  homepage "https://github.com/sshock/AFFLIBv3"
  url "https://github.com/sshock/AFFLIBv3/archive/v3.7.19.tar.gz"
  sha256 "d358b07153dd08df3f35376bab0202c6103808686bab5e8486c78a18b24e2665"
  revision 2

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/afflib"
    rebuild 1
    sha256 cellar: :any, mojave: "f428404d149607a278eb7d11dc979d6fe612e8f4874c885c6dc5df43e9a3d676"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libcython" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.11"

  uses_from_macos "curl"
  uses_from_macos "expat"

  def python3
    which("python3.11")
  end

  def install
    # Fix build with Python 3.11 by regenerating cythonized file.
    (buildpath/"pyaff/pyaff.c").unlink
    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_path "PYTHONPATH", Formula["libcython"].opt_libexec/site_packages

    ENV["PYTHON"] = python3
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args,
                          "--enable-s3",
                          "--enable-python",
                          "--disable-fuse"

    # Prevent installation into HOMEBREW_PREFIX.
    inreplace "pyaff/Makefile", "--single-version-externally-managed",
                                "--install-lib=#{prefix/site_packages} \\0"
    system "make", "install"
  end

  test do
    system "#{bin}/affcat", "-v"
    system python3, "-c", "import pyaff"
  end
end

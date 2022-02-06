class Global < Formula
  include Language::Python::Shebang

  desc "Source code tag system"
  homepage "https://www.gnu.org/software/global/"
  url "https://ftp.gnu.org/gnu/global/global-6.6.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/global/global-6.6.8.tar.gz"
  sha256 "6f93d9732a07175817907d26640a90dc1009918e02be761bba09d1fa068357cd"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/global"
    sha256 mojave: "fe8c5db6ef8ae93a46a87344ed8696b1b37679263251b3c15ebab44269c1f65e"
  end

  head do
    url ":pserver:anonymous:@cvs.savannah.gnu.org:/sources/global", using: :cvs

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "flex" => :build
    ## gperf is provided by OSX Command Line Tools.
    depends_on "libtool" => :build
  end

  depends_on "libtool"
  depends_on "ncurses"
  depends_on "python@3.10"
  depends_on "sqlite"
  depends_on "universal-ctags"

  skip_clean "lib/gtags"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/94/9c/cb656d06950268155f46d4f6ce25d7ffc51a0da47eadf1b164bbf23b718b/Pygments-2.11.2.tar.gz"
    sha256 "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a"
  end

  def install
    system "sh", "reconf.sh" if build.head?

    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages("python3")

    resource("Pygments").stage do
      system "python3", *Language::Python.setup_install_args(libexec)
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-sqlite3=#{Formula["sqlite"].opt_prefix}
      --with-universal-ctags=#{Formula["universal-ctags"].opt_bin}/ctags
    ]

    system "./configure", *args
    system "make", "install"

    rewrite_shebang detected_python_shebang, share/"gtags/script/pygments_parser.py"

    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])

    etc.install "gtags.conf"

    # we copy these in already
    cd share/"gtags" do
      rm %w[README COPYING LICENSE INSTALL ChangeLog AUTHORS]
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      int c2func (void) { return 0; }
      void cfunc (void) {int cvar = c2func(); }")
    EOS
    (testpath/"test.py").write <<~EOS
      def py2func ():
           return 0
      def pyfunc ():
           pyvar = py2func()
    EOS

    system bin/"gtags", "--gtagsconf=#{share}/gtags/gtags.conf", "--gtagslabel=pygments"
    assert_match "test.c", shell_output("#{bin}/global -d cfunc")
    assert_match "test.c", shell_output("#{bin}/global -d c2func")
    assert_match "test.c", shell_output("#{bin}/global -r c2func")
    assert_match "test.py", shell_output("#{bin}/global -d pyfunc")
    assert_match "test.py", shell_output("#{bin}/global -d py2func")
    assert_match "test.py", shell_output("#{bin}/global -r py2func")
    assert_match "test.c", shell_output("#{bin}/global -s cvar")
    assert_match "test.py", shell_output("#{bin}/global -s pyvar")

    system bin/"gtags", "--gtagsconf=#{share}/gtags/gtags.conf", "--gtagslabel=exuberant-ctags"
    # ctags only yields definitions
    assert_match "test.c", shell_output("#{bin}/global -d cfunc   # passes")
    assert_match "test.c", shell_output("#{bin}/global -d c2func  # passes")
    assert_match "test.py", shell_output("#{bin}/global -d pyfunc  # passes")
    assert_match "test.py", shell_output("#{bin}/global -d py2func # passes")
    refute_match "test.c", shell_output("#{bin}/global -r c2func  # correctly fails")
    refute_match "test.c", shell_output("#{bin}/global -s cvar    # correctly fails")
    refute_match "test.py", shell_output("#{bin}/global -r py2func # correctly fails")
    refute_match "test.py", shell_output("#{bin}/global -s pyvar   # correctly fails")

    # Test the default parser
    system bin/"gtags", "--gtagsconf=#{share}/gtags/gtags.conf", "--gtagslabel=default"
    assert_match "test.c", shell_output("#{bin}/global -d cfunc")
    assert_match "test.c", shell_output("#{bin}/global -d c2func")
    assert_match "test.c", shell_output("#{bin}/global -r c2func")
    assert_match "test.c", shell_output("#{bin}/global -s cvar")

    # Test tag files in sqlite format
    system bin/"gtags", "--gtagsconf=#{share}/gtags/gtags.conf", "--gtagslabel=pygments", "--sqlite3"
    assert_match "test.c", shell_output("#{bin}/global -d cfunc")
    assert_match "test.c", shell_output("#{bin}/global -d c2func")
    assert_match "test.c", shell_output("#{bin}/global -r c2func")
    assert_match "test.py", shell_output("#{bin}/global -d pyfunc")
    assert_match "test.py", shell_output("#{bin}/global -d py2func")
    assert_match "test.py", shell_output("#{bin}/global -r py2func")
    assert_match "test.c", shell_output("#{bin}/global -s cvar")
    assert_match "test.py", shell_output("#{bin}/global -s pyvar")
  end
end

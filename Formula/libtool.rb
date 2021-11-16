class Libtool < Formula
  desc "Generic library support script"
  homepage "https://www.gnu.org/software/libtool/"
  url "https://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.xz"
  sha256 "7c87a8c2c8c0fc9cd5019e402bed4292462d00a718a7cd5f11218153bf28b26f"
  license "GPL-2.0-or-later"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "51902377c9a9595aa62838170d43102ca12bfc0c2f926b78ea380220edfc271e"
    sha256 cellar: :any,                 arm64_big_sur:  "a41a4872cdfaa34bb4723e728b73dd8c7a05725501a262bb41ad9af4e2fcd1d6"
    sha256 cellar: :any,                 monterey:       "2bb6a492c764410cc07978cd1a4f46ca3fe555c234cb72015a729dcaa6533fea"
    sha256 cellar: :any,                 big_sur:        "dfb94265706b7204b346e3e5d48e149d7c7870063740f0c4ab2d6ec971260517"
    sha256 cellar: :any,                 catalina:       "ad541ac37b9a8042f998fb3640fe60f70d38483fa6a0784953d880190e9cc762"
    sha256 cellar: :any,                 mojave:         "35c8d3e024a2507d7d3244bcebdb0ccc61c25ae292e6df6025f78c7342a9799d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e91d7c9a8eac6eccecea681d94cec3acfd1a13056e36f4cd2a623ddaeacd49a"
  end

  depends_on "m4"

  # Fixes the build on macOS 11:
  # https://lists.gnu.org/archive/html/libtool-patches/2020-06/msg00001.html
  patch :p0 do
    url "https://github.com/Homebrew/formula-patches/raw/e5fbd46a25e35663059296833568667c7b572d9a/libtool/dynamic_lookup-11.patch"
    sha256 "5ff495a597a876ce6e371da3e3fe5dd7f78ecb5ebc7be803af81b6f7fcef1079"
  end

  def install
    # Ensure configure is happy with the patched files
    %w[aclocal.m4 libltdl/aclocal.m4 Makefile.in libltdl/Makefile.in
       config-h.in libltdl/config-h.in configure libltdl/configure].each do |file|
      touch file
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ltdl-install
    ]

    args << "--program-prefix=g" if OS.mac?

    system "./configure", *args
    system "make", "install"

    if OS.mac?
      %w[libtool libtoolize].each do |prog|
        (libexec/"gnubin").install_symlink bin/"g#{prog}" => prog
        (libexec/"gnuman/man1").install_symlink man1/"g#{prog}.1" => "#{prog}.1"
      end
      libexec.install_symlink "gnuman" => "man"
    end

    if OS.linux?
      bin.install_symlink "libtool" => "glibtool"
      bin.install_symlink "libtoolize" => "glibtoolize"

      # Avoid references to the Homebrew shims directory
      inreplace bin/"libtool", Superenv.shims_path, "/usr/bin"
    end
  end

  def caveats
    on_macos do
      <<~EOS
        All commands have been installed with the prefix "g".
        If you need to use these commands with their normal names, you
        can add a "gnubin" directory to your PATH from your bashrc like:
          PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    system "#{bin}/glibtool", "execute", File.executable?("/usr/bin/true") ? "/usr/bin/true" : "/bin/true"
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() { puts("Hello, world!"); return 0; }
    EOS
    system bin/"glibtool", "--mode=compile", "--tag=CC",
      ENV.cc, "-c", "hello.c", "-o", "hello.o"
    system bin/"glibtool", "--mode=link", "--tag=CC",
      ENV.cc, "hello.o", "-o", "hello"
    assert_match "Hello, world!", shell_output("./hello")
  end
end

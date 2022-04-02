class Findutils < Formula
  desc "Collection of GNU find, xargs, and locate"
  homepage "https://www.gnu.org/software/findutils/"
  url "https://ftp.gnu.org/gnu/findutils/findutils-4.9.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/findutils/findutils-4.9.0.tar.xz"
  sha256 "a2bfb8c09d436770edc59f50fa483e785b161a3b7b9d547573cb08065fd462fe"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/findutils"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "53c7b27534e69a3aba4e0fe543a6333c06cfa39621b192c8cba047d6a3fe68c6"
  end

  def install
    # Work around unremovable, nested dirs bug that affects lots of
    # GNU projects. See:
    # https://github.com/Homebrew/homebrew/issues/45273
    # https://github.com/Homebrew/homebrew/issues/44993
    # This is thought to be an el_capitan bug:
    # https://lists.gnu.org/archive/html/bug-tar/2015-10/msg00017.html
    ENV["gl_cv_func_getcwd_abort_bug"] = "no" if MacOS.version == :el_capitan

    # Workaround for build failures in 4.8.0
    # https://lists.gnu.org/archive/html/bug-findutils/2021-01/msg00050.html
    # https://lists.gnu.org/archive/html/bug-findutils/2021-01/msg00051.html
    ENV.append "CFLAGS", "-D__nonnull\\(params\\)="

    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}/locate
      --disable-dependency-tracking
      --disable-debug
      --disable-nls
      --with-packager=Homebrew
      --with-packager-bug-reports=#{tap.issues_url}
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make", "install"

    if OS.mac?
      [[prefix, bin], [share, man/"*"]].each do |base, path|
        Dir[path/"g*"].each do |p|
          f = Pathname.new(p)
          gnupath = "gnu" + f.relative_path_from(base).dirname
          (libexec/gnupath).install_symlink f => f.basename.sub(/^g/, "")
        end
      end
    end

    libexec.install_symlink "gnuman" => "man"
  end

  def post_install
    (var/"locate").mkpath
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
    touch "HOMEBREW"
    if OS.mac?
      assert_match "HOMEBREW", shell_output("#{bin}/gfind .")
      assert_match "HOMEBREW", shell_output("#{opt_libexec}/gnubin/find .")
    else
      assert_match "HOMEBREW", shell_output("#{bin}/find .")
    end
  end
end

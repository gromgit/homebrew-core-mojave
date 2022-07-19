class Findutils < Formula
  desc "Collection of GNU find, xargs, and locate"
  homepage "https://www.gnu.org/software/findutils/"
  url "https://ftp.gnu.org/gnu/findutils/findutils-4.9.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/findutils/findutils-4.9.0.tar.xz"
  sha256 "a2bfb8c09d436770edc59f50fa483e785b161a3b7b9d547573cb08065fd462fe"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/findutils"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "bf68be96eebb7bf6601a98dfededfdb6a2059e58c0361a521b22a04442a3c844"
  end

  def install
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

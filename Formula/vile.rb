class Vile < Formula
  desc "Vi Like Emacs Editor"
  homepage "https://invisible-island.net/vile/"
  url "https://invisible-island.net/archives/vile/current/vile-9.8w.tgz"
  sha256 "78253ec3f7ae5f4f9d4799a3c8bc35b85b47d456f2ac172810008a48e4609815"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vile"
    rebuild 1
    sha256 mojave: "56abb68a9b7de5db03ab0afff5701c1ed0b6398108c64ba5700571a1b4c3f344"
  end

  uses_from_macos "flex" => :build
  uses_from_macos "expect" => :test
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "perl"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

  def install
    system "./configure", *std_configure_args,
                          "--disable-imake",
                          "--enable-colored-menus",
                          "--with-ncurses",
                          "--without-x",
                          "--with-screen=ncurses"
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    (testpath/"vile.exp").write <<~EOS
      spawn #{bin}/vile
      expect "unnamed"
      send ":w new\r:q\r"
      expect eof
    EOS
    system "expect", "-f", "vile.exp"
    assert_predicate testpath/"new", :exist?
  end
end

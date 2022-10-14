class Vifm < Formula
  desc "Ncurses-based file manager with vi-like keybindings"
  homepage "https://vifm.info/"
  url "https://github.com/vifm/vifm/releases/download/v0.12.1/vifm-0.12.1.tar.bz2"
  sha256 "8fe2813ebdcccfe99aece02b05d62a20991525d46b0ccfbaec3af614c6655688"
  license "GPL-2.0-or-later"
  head "https://github.com/vifm/vifm.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vifm"
    sha256 mojave: "74704e29d6628780363dd664d32730cfa64eeb47602857730209dc3a545eca70"
  end

  uses_from_macos "groff" => :build
  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-gtk",
                          "--without-libmagic",
                          "--without-X11"
    system "make"
    # Run make check only when not root
    # https://github.com/vifm/vifm/issues/654
    system "make", "check" unless Process.uid.zero?

    ENV.deparallelize { system "make", "install" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vifm --version")
  end
end

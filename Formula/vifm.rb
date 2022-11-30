class Vifm < Formula
  desc "Ncurses-based file manager with vi-like keybindings"
  homepage "https://vifm.info/"
  url "https://github.com/vifm/vifm/releases/download/v0.12.1/vifm-0.12.1.tar.bz2"
  sha256 "8fe2813ebdcccfe99aece02b05d62a20991525d46b0ccfbaec3af614c6655688"
  license "GPL-2.0-or-later"
  head "https://github.com/vifm/vifm.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vifm"
    rebuild 1
    sha256 mojave: "eb1829a6203b7f6ca3aaa133e123eeabe6f34b610854826441d2ba8f290f6b3d"
  end

  uses_from_macos "ncurses"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

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

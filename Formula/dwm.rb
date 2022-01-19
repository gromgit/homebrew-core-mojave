class Dwm < Formula
  desc "Dynamic window manager"
  homepage "https://dwm.suckless.org/"
  url "https://dl.suckless.org/dwm/dwm-6.3.tar.gz"
  sha256 "badaa028529b1fba1fd7f9a84f3b64f31190466c858011b53e2f7b70c6a3078d"
  license "MIT"
  head "https://git.suckless.org/dwm", using: :git, branch: "master"

  livecheck do
    url "https://dl.suckless.org/dwm/"
    regex(/href=.*?dwm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dwm"
    sha256 cellar: :any, mojave: "42888d31314c5feba35ef7e4940b523d64eff1fb8c5f42479fe1b8b10fa689d2"
  end

  depends_on "dmenu"
  depends_on "libx11"
  depends_on "libxft"
  depends_on "libxinerama"

  def install
    # The dwm default quit keybinding Mod1-Shift-q collides with
    # the Mac OS X Log Out shortcut in the Apple menu.
    inreplace "config.def.h",
    "{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },",
    "{ MODKEY|ControlMask,           XK_q,      quit,           {0} },"
    inreplace "dwm.1", '.B Mod1\-Shift\-q', '.B Mod1\-Control\-q'
    system "make", "FREETYPEINC=#{Formula["freetype2"].opt_include}/freetype2", "PREFIX=#{prefix}", "install"
  end

  def caveats
    <<~EOS
      In order to use the Mac OS X command key for dwm commands,
      change the X11 keyboard modifier map using xmodmap (1).

      e.g. by running the following command from $HOME/.xinitrc
      xmodmap -e 'remove Mod2 = Meta_L' -e 'add Mod1 = Meta_L'&

      See also https://gist.github.com/311377 for a handful of tips and tricks
      for running dwm on Mac OS X.
    EOS
  end

  test do
    assert_match "dwm: cannot open display", shell_output("DISPLAY= #{bin}/dwm 2>&1", 1)
    assert_match "dwm-#{version}", shell_output("DISPLAY= #{bin}/dwm -v 2>&1", 1)
  end
end

class Rmw < Formula
  desc "Safe-remove utility for the command-line"
  homepage "https://remove-to-waste.info/"
  url "https://github.com/theimpossibleastronaut/rmw/releases/download/v0.8.1/rmw-0.8.1.tar.gz"
  sha256 "abad25d8c0b2d6593fe426ca2c2d064207630e6a827a7d769f4991cbb583337b"
  license "GPL-3.0-or-later"
  head "https://github.com/theimpossibleastronaut/rmw.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rmw"
    sha256 mojave: "a1b9ab8de7f0d7a6710822f6428c3dbc39c52acf9e70c89ad59295eaef1f7835"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "canfigger"
  depends_on "gettext"
  # Slightly buggy with system ncurses
  # https://github.com/theimpossibleastronaut/rmw/issues/205
  depends_on "ncurses"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    file = testpath/"foo"
    touch file
    assert_match "removed", shell_output("#{bin}/rmw #{file}")
    refute_predicate file, :exist?
    system "#{bin}/rmw", "-u"
    assert_predicate file, :exist?
    assert_match "/.local/share/Waste", shell_output("#{bin}/rmw -l")
    assert_match "purging is disabled", shell_output("#{bin}/rmw -vvg")
  end
end

class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  url "https://github.com/dosbox-staging/dosbox-staging/archive/v0.77.1.tar.gz"
  sha256 "85359efb7cd5c5c0336d88bdf023b7b462a8233490e00274fef0b85cca2f5f3c"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/dosbox-staging/dosbox-staging.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dosbox-staging"
    rebuild 1
    sha256 cellar: :any, mojave: "c777bc36d718cb28187122380b6d0761a43031b3169985ff1bef5642fdb4dcb3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "libpng"
  depends_on "mt32emu"
  depends_on "opusfile"
  depends_on "sdl2"
  depends_on "sdl2_net"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Db_lto=true", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
    mv bin/"dosbox", bin/"dosbox-staging"
    mv man1/"dosbox.1", man1/"dosbox-staging.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dosbox-staging -version")
    mkdir testpath/"Library/Preferences/DOSBox"
    touch testpath/"Library/Preferences/DOSBox/dosbox-staging.conf"
    output = shell_output("#{bin}/dosbox-staging -printconf")
    assert_equal "#{testpath}/Library/Preferences/DOSBox/dosbox-staging.conf", output.chomp
  end
end

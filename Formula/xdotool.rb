class Xdotool < Formula
  desc "Fake keyboard/mouse input and window management for X"
  homepage "https://www.semicomplete.com/projects/xdotool/"
  url "https://github.com/jordansissel/xdotool/releases/download/v3.20211022.1/xdotool-3.20211022.1.tar.gz"
  sha256 "96f0facfde6d78eacad35b91b0f46fecd0b35e474c03e00e30da3fdd345f9ada"
  license "BSD-3-Clause"
  head "https://github.com/jordansissel/xdotool.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xdotool"
    rebuild 2
    sha256 mojave: "1fa310b217b0fbcba7182a25df30b082168b612624e088700db7400fbf5017fc"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxinerama"
  depends_on "libxkbcommon"
  depends_on "libxtst"

  # Disable clock_gettime() workaround since the real API is available on macOS >= 10.12
  # Note that the PR from this patch was actually closed originally because of problems
  # caused on pre-10.12 environments, but that is no longer a concern.
  patch do
    url "https://github.com/jordansissel/xdotool/commit/dffc9a1597bd96c522a2b71c20301f97c130b7a8.patch?full_index=1"
    sha256 "447fa42ec274eb7488bb4aeeccfaaba0df5ae747f1a7d818191698035169a5ef"
  end

  def install
    system "make", "PREFIX=#{prefix}", "INSTALLMAN=#{man}", "install"
  end

  def caveats
    <<~EOS
      You will probably want to enable XTEST in your X11 server now by running:
        defaults write org.x.X11 enable_test_extensions -boolean true

      For the source of this useful hint:
        https://stackoverflow.com/questions/1264210/does-mac-x11-have-the-xtest-extension
    EOS
  end

  test do
    system "#{bin}/xdotool", "--version"
  end
end

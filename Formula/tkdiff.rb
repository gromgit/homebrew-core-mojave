class Tkdiff < Formula
  desc "Graphical side by side diff utility"
  homepage "https://tkdiff.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tkdiff/tkdiff/5.5.1/tkdiff-5-5-1.zip"
  version "5.5.1"
  sha256 "f8afa4e491f89df2868993f511807ece5ae51535bc268e674e92de54554a62c8"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/tkdiff/v?(\d+(?:\.\d+)+)/[^"]+?\.zip}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "25a9074dad2f48932c00dea0ab2452f1a0ed53bacf96d40a6cae4b106cf8821e"
  end

  uses_from_macos "tcl-tk"

  def install
    bin.install "tkdiff"
  end

  test do
    # Fails with: no display name and no $DISPLAY environment variable on GitHub Actions
    system "#{bin}/tkdiff", "--help" if OS.mac?
  end
end

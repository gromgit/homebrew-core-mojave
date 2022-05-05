class Homeworlds < Formula
  desc "C++ framework for the game of Binary Homeworlds"
  homepage "https://github.com/Quuxplusone/Homeworlds/"
  url "https://github.com/Quuxplusone/Homeworlds.git",
      revision: "917cd7e7e6d0a5cdfcc56cd69b41e3e80b671cde"
  version "20141022"
  license "BSD-2-Clause"
  revision 3

  livecheck do
    skip "No version information available to check"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/homeworlds"
    sha256 cellar: :any, mojave: "17e513bb7662795e5d33d09110b9907bb4aad0c93031e7aed67f9628dd554661"
  end

  depends_on "wxwidgets"

  def install
    system "make"
    bin.install "wxgui" => "homeworlds-wx", "annotate" => "homeworlds-cli"
  end
end

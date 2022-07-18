class Homeworlds < Formula
  desc "C++ framework for the game of Binary Homeworlds"
  homepage "https://github.com/Quuxplusone/Homeworlds/"
  url "https://github.com/Quuxplusone/Homeworlds.git",
      revision: "917cd7e7e6d0a5cdfcc56cd69b41e3e80b671cde"
  version "20141022"
  license "BSD-2-Clause"
  revision 5

  livecheck do
    skip "No version information available to check"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/homeworlds"
    sha256 cellar: :any, mojave: "c48d6ad611ea9018c19a71b81044e7e5e9c9ca6a42277d1c3efb9ff9298d77ef"
  end

  depends_on "wxwidgets"

  def install
    system "make"
    bin.install "wxgui" => "homeworlds-wx", "annotate" => "homeworlds-cli"
  end
end

class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/2.8.2.tar.gz"
  sha256 "e6bb5bcac18ad64070b70836750a0f3752cbe5fe31e9acd455a700ee57f3a799"
  license "MIT"
  head "https://github.com/clibs/clib.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/clib"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "c806612b0631f34fbd5ea53ddc74666e14d2302d87310c69cb469764626d1d14"
  end

  uses_from_macos "curl"

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end

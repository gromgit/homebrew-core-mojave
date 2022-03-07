class Iniparser < Formula
  desc "Library for parsing ini files"
  homepage "http://ndevilla.free.fr/iniparser/"
  url "https://github.com/ndevilla/iniparser/archive/v4.1.tar.gz"
  sha256 "960daa800dd31d70ba1bacf3ea2d22e8ddfc2906534bf328319495966443f3ae"
  license "MIT"
  head "https://github.com/ndevilla/iniparser.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/iniparser"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "0d2127b86c3024cda391a8e0f0872587f21dc13265e5546fc7f4d06a69ec9370"
  end

  conflicts_with "fastbit", because: "both install `include/dictionary.h`"

  def install
    # Only make the *.a file; the *.so target is useless (and fails).
    system "make", "libiniparser.a", "CC=#{ENV.cc}", "RANLIB=ranlib"
    lib.install "libiniparser.a"
    include.install Dir["src/*.h"]
  end
end

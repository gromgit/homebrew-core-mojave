class Lolcode < Formula
  desc "Esoteric programming language"
  homepage "http://www.lolcode.org/"
  # NOTE: 0.10.* releases are stable, 0.11.* is dev. We moved over to
  # 0.11.x accidentally, should move back to stable when possible.
  url "https://github.com/justinmeza/lci/archive/v0.11.2.tar.gz"
  sha256 "cb1065936d3a7463928dcddfc345a8d7d8602678394efc0e54981f9dd98c27d2"
  license "GPL-3.0-or-later"
  head "https://github.com/justinmeza/lci.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lolcode"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "1c3819407c30a56a85accddfafc4ba945c66afe33fd786a1adfc2ed381063154"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "readline"
  end

  conflicts_with "lci", because: "both install `lci` binaries"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    # Don't use `make install` for this one file
    bin.install "lci"
  end

  test do
    path = testpath/"test.lol"
    path.write <<~EOS
      HAI 1.2
      CAN HAS STDIO?
      VISIBLE "HAI WORLD"
      KTHXBYE
    EOS
    assert_equal "HAI WORLD\n", shell_output("#{bin}/lci #{path}")
  end
end

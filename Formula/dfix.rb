class Dfix < Formula
  desc "Auto-upgrade tool for D source code"
  homepage "https://github.com/dlang-community/dfix"
  url "https://github.com/dlang-community/dfix.git",
      tag:      "v0.3.5",
      revision: "5265a8db4b0fdc54a3d0837a7ddf520ee94579c4"
  license "BSL-1.0"
  head "https://github.com/dlang-community/dfix.git", branch: "master"

  livecheck do
    url "https://code.dlang.org/packages/dfix"
    regex(%r{"badge">v?(\d+(?:\.\d+)+)</strong>}i)
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dfix"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "2a0efbbb33abf783c03a04e16d074134fbba00b8cf5fb30f65f65269f0954e20"
  end

  depends_on "dmd" => :build

  def install
    system "make"
    bin.install "bin/dfix"
    pkgshare.install "test/testfile_expected.d", "test/testfile_master.d"
  end

  test do
    system "#{bin}/dfix", "--help"

    cp "#{pkgshare}/testfile_master.d", "testfile.d"
    system "#{bin}/dfix", "testfile.d"
    system "diff", "testfile.d", "#{pkgshare}/testfile_expected.d"
    # Make sure that running dfix on the output of dfix changes nothing.
    system "#{bin}/dfix", "testfile.d"
    system "diff", "testfile.d", "#{pkgshare}/testfile_expected.d"
  end
end

class Sevenzip < Formula
  desc "7-Zip is a file archiver with a high compression ratio"
  homepage "https://7-zip.org"
  url "https://7-zip.org/a/7z2107-src.tar.xz"
  version "21.07"
  sha256 "213d594407cb8efcba36610b152ca4921eda14163310b43903d13e68313e1e39"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sevenzip"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "ea61adf561d4092599e56e1153470cfc5e4beb63bf06a24989083eb272aa4527"
  end

  def install
    cd "CPP/7zip/Bundles/Alone2" do
      mac_suffix = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch
      mk_suffix, directory = if OS.mac?
        ["mac_#{mac_suffix}", "m_#{mac_suffix}"]
      else
        ["gcc", "g"]
      end

      system "make", "-f", "../../cmpl_#{mk_suffix}.mak", "DISABLE_RAR_COMPRESS=1"

      # Cherry pick the binary manually. This should be changed to something
      # like `make install' if the upstream adds an install target.
      # See: https://sourceforge.net/p/sevenzip/discussion/45797/thread/1d5b04f2f1/
      bin.install "b/#{directory}/7zz"
    end
  end

  test do
    (testpath/"foo.txt").write("hello world!\n")
    system bin/"7zz", "a", "-t7z", "foo.7z", "foo.txt"
    system bin/"7zz", "e", "foo.7z", "-oout"
    assert_equal "hello world!\n", (testpath/"out/foo.txt").read
  end
end

class Sevenzip < Formula
  desc "7-Zip is a file archiver with a high compression ratio"
  homepage "https://7-zip.org"
  url "https://7-zip.org/a/7z2200-src.tar.xz"
  version "22.00"
  sha256 "40969f601e86aff49aaa0ba0df5ce6fd397cf7e2683a84b591b0081e461ef675"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://7-zip.org/download.html"
    regex(/>\s*Download\s+7-Zip\s+v?(\d+(?:\.\d+)+)[\s<]/im)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sevenzip"
    sha256 cellar: :any_skip_relocation, mojave: "1417aacd5e96dc9d13636a793107a1971b044c1d3467deec85a0d157be61074a"
  end

  def install
    # See https://sourceforge.net/p/sevenzip/discussion/45797/thread/9c2d9061ce/#01e7
    if OS.mac?
      inreplace ["Common/FileStreams.cpp", "UI/Common/UpdateCallback.cpp"].map { |d| buildpath/"CPP/7zip"/d },
                "sysmacros.h",
                "types.h"
    end

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

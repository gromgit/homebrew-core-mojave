class Sevenzip < Formula
  desc "7-Zip is a file archiver with a high compression ratio"
  homepage "https://7-zip.org"
  url "https://7-zip.org/a/7z2107-src.tar.xz"
  version "21.07"
  sha256 "213d594407cb8efcba36610b152ca4921eda14163310b43903d13e68313e1e39"
  license all_of: ["LGPL-2.1-or-later", "BSD-3-Clause"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sevenzip"
    sha256 cellar: :any_skip_relocation, mojave: "a89bf7108595e49d8dd521909e140e1ad3cd6e41c7dc729b942590379487b586"
  end

  def install
    cd "CPP/7zip/Bundles/Alone2" do
      mac_suffix = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch
      mk_suffix, directory = if OS.mac?
        ["mac_#{mac_suffix}", "m_#{mac_suffix}"]
      else
        ["gcc", "g"]
      end

      system "make", "-f", "../../cmpl_#{mk_suffix}.mak"

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

class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20211122.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20211122.tar.bz2"
  sha256 "48b256322c56a4cb1a7818fe0894fdde575dab0e0f925c6a2289517b6bd8962e"
  license "GPL-3.0-or-later"
  version_scheme 1
  head "https://git.savannah.gnu.org/git/parallel.git", branch: "master"

  livecheck do
    url :homepage
    regex(/GNU Parallel v?(\d{6,8}).*? released/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "27b5f22736730dde86fb8a9302161b4608bec9525d43a190ae9c89440583aeab"
  end

  conflicts_with "moreutils", because: "both install a `parallel` executable"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    inreplace_files = [
      bin/"parallel",
      doc/"parallel.texi",
      doc/"parallel_design.texi",
      man1/"parallel.1",
      man7/"parallel_design.7",
    ]
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end

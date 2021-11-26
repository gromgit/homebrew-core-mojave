class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.uni-due.de/~be0001/bibtexconv/"
  url "https://github.com/dreibh/bibtexconv/archive/bibtexconv-1.3.1.tar.gz"
  sha256 "db08bd2b21b137c073ceeb97e5c7f68be4994d3e2af7a8c7dda088ccc0dea9b6"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bibtexconv"
    rebuild 1
    sha256 cellar: :any, mojave: "303580cb4e24b1487e07bb69479cd59143c1bb93adc19357c37be51e5099a8f3"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  def install
    system "cmake", *std_cmake_args,
                    "-DCRYPTO_LIBRARY=#{Formula["openssl@1.1"].opt_lib}/#{shared_library("libcrypto")}"
    system "make", "install"
  end

  test do
    cp "#{opt_share}/doc/bibtexconv/examples/ExampleReferences.bib", testpath

    system bin/"bibtexconv", "#{testpath}/ExampleReferences.bib",
                             "-export-to-bibtex=UpdatedReferences.bib",
                             "-check-urls", "-only-check-new-urls",
                             "-non-interactive"
  end
end

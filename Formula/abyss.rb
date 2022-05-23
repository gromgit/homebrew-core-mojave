class Abyss < Formula
  desc "Genome sequence assembler for short reads"
  homepage "https://www.bcgsc.ca/resources/software/abyss"
  url "https://github.com/bcgsc/abyss/releases/download/2.3.5/abyss-2.3.5.tar.gz"
  sha256 "5455f7708531681ee15ec4fd5620526a53c86d28f959e630dc495f526b7d40f7"
  license all_of: ["GPL-3.0-only", "LGPL-2.1-or-later", "MIT", "BSD-3-Clause"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/abyss"
    sha256 cellar: :any, mojave: "facf7543d9eb5f26e3085b0d300c59e8574a6205a931add9031d76fa12435197"
  end

  head do
    url "https://github.com/bcgsc/abyss.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "multimarkdown" => :build
  end

  depends_on "boost" => :build
  depends_on "google-sparsehash" => :build
  depends_on "gcc"
  depends_on "open-mpi"

  fails_with gcc: "5"
  fails_with :clang # no OpenMP support

  resource "homebrew-testdata" do
    url "https://www.bcgsc.ca/sites/default/files/bioinformatics/software/abyss/releases/1.3.4/test-data.tar.gz"
    sha256 "28f8592203daf2d7c3b90887f9344ea54fda39451464a306ef0226224e5f4f0e"
  end

  def install
    ENV.delete("HOMEBREW_SDKROOT") if MacOS.version >= :mojave && MacOS::CLT.installed?
    system "./autogen.sh" if build.head?
    system "./configure", "--enable-maxk=128",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].include}",
                          "--with-mpi=#{Formula["open-mpi"].prefix}",
                          "--with-sparsehash=#{Formula["google-sparsehash"].prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    testpath.install resource("homebrew-testdata")
    if which("column")
      system "#{bin}/abyss-pe", "B=2G", "k=25", "name=ts", "in=reads1.fastq reads2.fastq"
    else
      # Fix error: abyss-tabtomd: column: not found
      system "#{bin}/abyss-pe", "B=2G", "unitigs", "scaffolds", "k=25", "name=ts", "in=reads1.fastq reads2.fastq"
    end
    system "#{bin}/abyss-fac", "ts-unitigs.fa"
  end
end

class Blast < Formula
  desc "Basic Local Alignment Search Tool"
  homepage "https://blast.ncbi.nlm.nih.gov/"
  url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.13.0/ncbi-blast-2.13.0+-src.tar.gz"
  version "2.13.0"
  sha256 "89553714d133daf28c477f83d333794b3c62e4148408c072a1b4620e5ec4feb2"
  license :public_domain

  livecheck do
    url "https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/VERSION"
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/blast"
    rebuild 2
    sha256 mojave: "cca14a07de4f690c40e57d28f8a089537ee0b5acc1945aa3b11ebf988643c31c"
  end

  depends_on "lmdb"

  uses_from_macos "cpio" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "gcc"
  end

  conflicts_with "proj", because: "both install a `libproj.a` library"

  fails_with gcc: "5" # C++17

  def install
    cd "c++" do
      # Boost is only used for unit tests.
      args = %W[
        --prefix=#{prefix}
        --with-bin-release
        --with-mt
        --with-strip
        --with-experimental=Int8GI
        --without-debug
        --without-boost
      ]
      # Allow SSE4.2 on some platforms. The --with-bin-release sets --without-sse42
      args << "--with-sse42" if Hardware::CPU.intel? && MacOS.version.requires_sse42?

      if OS.mac?
        args += ["OPENMP_FLAGS=-Xpreprocessor -fopenmp",
                 "LDFLAGS=-lomp"]
      end

      system "./configure", *args

      # Fix the error: install: ReleaseMT/lib/*.*: No such file or directory
      system "make"
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/update_blastdb.pl --showall")
    assert_match "nt", output

    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    output = shell_output("#{bin}/blastn -query test.fasta -subject test.fasta")
    assert_match "Identities = 70/70", output

    # Create BLAST database
    output = shell_output("#{bin}/makeblastdb -in test.fasta -out testdb -dbtype nucl")
    assert_match "Adding sequences from FASTA", output

    # Check newly created BLAST database
    output = shell_output("#{bin}/blastdbcmd -info -db testdb")
    assert_match "Database: test", output
  end
end

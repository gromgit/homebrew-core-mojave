class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v6.4.0/miller-6.4.0.tar.gz"
  sha256 "20a8687a0c5b5fedf4fc3a794ef1cee7e9872e87476e1f24bde8de25799f8c51"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/miller"
    sha256 cellar: :any_skip_relocation, mojave: "4e5b1a7e5d58ae7daeb48ccfd64e17931a95c1b082cf10ce4dbf6607f8af744d"
  end

  depends_on "go" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
      4,5,6
    EOS
    output = pipe_output("#{bin}/mlr --csvlite cut -f a test.csv")
    assert_match "a\n1\n4\n", output
  end
end

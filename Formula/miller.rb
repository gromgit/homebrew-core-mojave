class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v6.3.0/miller-6.3.0.tar.gz"
  sha256 "6af8d2b8387c416090a9bf02129667920b86903e67561ccc4a5c9a3b33ea76cb"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/miller"
    sha256 cellar: :any_skip_relocation, mojave: "d82427942ed2050deefff0c3ea763ab4f36c18c5b27525279561885364bc860a"
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

class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v6.0.0/miller-6.0.0.tar.gz"
  sha256 "b5e04ccbcb021bebbd758db4ae844712eb4fcfc67e6aaf39e24f751f45cfd0cd"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/miller"
    sha256 cellar: :any_skip_relocation, mojave: "1ab6d7678e7d5c8ddfab6b591fadaea9fde4a7c5c7a8d10c0cd16dec18343576"
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

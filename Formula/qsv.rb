class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/0.61.4.tar.gz"
  sha256 "d82093b4b3fbae9469000b1970c34ad31b9e59918f617ffab6d9ba5eb785e04a"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/qsv"
    sha256 cellar: :any_skip_relocation, mojave: "e0996af1fc6b6f709f6ecdea1c23907306194fb737e58ca89c961762bb6c245c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,full"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,min_length,max_length,mean,stddev,variance,nullcount
      first header,NULL,,,,,,,,,0
      second header,NULL,,,,,,,,,0
    EOS
  end
end

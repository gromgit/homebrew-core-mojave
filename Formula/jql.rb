class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https://github.com/yamafaktory/jql"
  url "https://github.com/yamafaktory/jql/archive/v3.0.4.tar.gz"
  sha256 "4d916c75184742b98c1df6b21641647b9150992314a8ae19940a44a6a65ade89"
  license "MIT"
  head "https://github.com/yamafaktory/jql.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jql"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "ad4b84f3c0d0de57bc76bbe28ef2f10416557075077147c98ec6e0d432bab08a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}/jql --raw-output '\"cats\".[2:1].[0].\"third\"' example.json")
    assert_equal "Misty\n", output
  end
end

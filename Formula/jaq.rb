class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "f78ee650c7058419d0dba37360ba0e9930b88f1432234b48f25dc89dbaaf665f"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jaq"
    sha256 cellar: :any_skip_relocation, mojave: "533ecf6b7add10d6b9b78ed3be4ae727f967b3a5d966c3e28b93fc1cc9184f46"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}/jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}/jaq -s 'add / length'")
  end
end

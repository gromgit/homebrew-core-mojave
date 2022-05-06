class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://codeberg.org/flausch/mdcat"
  url "https://codeberg.org/flausch/mdcat/archive/mdcat-0.27.1.tar.gz"
  sha256 "79961e0a842ee0f68aee3d54b39458352664c67388e56175a9d18d80f357bf14"
  license "MPL-2.0"
  head "https://codeberg.org/flausch/mdcat.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mdcat"
    sha256 cellar: :any_skip_relocation, mojave: "65ec07306d797cf1902facf7cbd3bc21348d609fe3eec4d191421dec75c3d7e0"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end

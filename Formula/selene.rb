class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/0.16.0.tar.gz"
  sha256 "35879e6cb85993935481e2940d3532fff787733f940cbe27bbede70f84aea496"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/selene"
    sha256 cellar: :any_skip_relocation, mojave: "1902772d1807bf2505269811095f4fd713d7c12b525c0cacfd09cba3e907b1ef"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "selene" do
      system "cargo", "install", "--bin", "selene", *std_cargo_args
    end
  end

  test do
    (testpath/"test.lua").write("print(1 / 0)")
    assert_match "warning[divide_by_zero]", shell_output("#{bin}/selene #{testpath}/test.lua", 1)
  end
end

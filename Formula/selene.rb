class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/0.18.2.tar.gz"
  sha256 "16401ee92f0df8d6384160110c5f30e5935b4cd687a6d24de4e744278223ce30"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/selene"
    sha256 cellar: :any_skip_relocation, mojave: "83ff60843ff1e5fef7220c5f5234df00cfc2fbdca7812451a545ce683c43a22a"
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

class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v1.13.0.tar.gz"
  sha256 "acfe2d57fc81bfe7a02f60ba995f10fffbf5e93df62d6f263862eaf2b79c5413"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dbmate"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "6cb49e4ef07e253b7b5903e5e6b48c0d74d71f79cddc659b61b5ee455b105101"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "sqlite_omit_load_extension,sqlite_json"
  end

  test do
    (testpath/".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin/"dbmate", "create"
    assert_predicate testpath/"test.sqlite3", :exist?, "failed to create test.sqlite3"
  end
end

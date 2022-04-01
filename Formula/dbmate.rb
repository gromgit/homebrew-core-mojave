class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https://github.com/amacneil/dbmate"
  url "https://github.com/amacneil/dbmate/archive/v1.15.0.tar.gz"
  sha256 "1460d1591c0c7340a90e6aee32aa123ec24d88f8e5486482d2bab318497a42bf"
  license "MIT"
  head "https://github.com/amacneil/dbmate.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dbmate"
    sha256 cellar: :any_skip_relocation, mojave: "f615b872b16033ced373c907d238fabd8028c5889f41f215b82f58f6fe65f95a"
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

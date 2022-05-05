class GolangMigrate < Formula
  desc "Database migrations CLI tool"
  homepage "https://github.com/golang-migrate/migrate"
  url "https://github.com/golang-migrate/migrate/archive/v4.15.2.tar.gz"
  sha256 "070b8c370fe45a2c2f6aa445feb65a1d63d749ce8b2dc5c7d1dffe45418b567a"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/golang-migrate"
    sha256 cellar: :any_skip_relocation, mojave: "a09c59e5067881f6b64a61e6fae9e718c7dd3cedd560e2ad0815206ba852f9d6"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=v#{version}"
    bin.install "migrate"
  end

  test do
    touch "0001_migtest.up.sql"
    output = shell_output("#{bin}/migrate -database stub: -path . up 2>&1")
    assert_match "1/u migtest", output
  end
end

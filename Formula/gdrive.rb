class Gdrive < Formula
  desc "Google Drive CLI Client"
  homepage "https://github.com/gdrive-org/gdrive"
  url "https://github.com/gdrive-org/gdrive/archive/2.1.1.tar.gz"
  sha256 "9092cb356acf58f2938954784605911e146497a18681199d0c0edc65b833a672"
  license "MIT"
  head "https://github.com/gdrive-org/gdrive.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gdrive"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "d80034952d1a608ab567b4307e566688c8514d3bb86435c156b5913f0f2d16f8"
  end

  depends_on "go" => :build

  patch do
    url "https://github.com/prasmussen/gdrive/commit/faa6fc3dc104236900caa75eb22e9ed2e5ecad42.patch?full_index=1"
    sha256 "ee7ebe604698aaeeb677c60d973d5bd6c3aca0a5fb86f6f925c375a90fea6b95"
  end

  def install
    system "go", "build", *std_go_args, "-mod=readonly"
    doc.install "README.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gdrive version")
  end
end

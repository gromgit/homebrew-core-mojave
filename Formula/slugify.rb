class Slugify < Formula
  desc "Convert filenames and directories to a web friendly format"
  homepage "https://github.com/benlinton/slugify"
  url "https://github.com/benlinton/slugify/archive/v1.0.1.tar.gz"
  sha256 "f6873b062119d3eaa7d89254fc6e241debf074da02e3189f12e08b372af096e5"
  license "MIT"
  head "https://github.com/benlinton/slugify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "73fa2281dd5bc54549c488774feb2d262b0a4e80c4bedf2e017f90e74293076d"
  end

  def install
    bin.install "slugify"
    man1.install "slugify.1"
  end

  test do
    system "#{bin}/slugify", "-n", "dry_run.txt"
  end
end

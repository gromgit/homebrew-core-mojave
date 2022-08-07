class Nomino < Formula
  desc "Batch rename utility"
  homepage "https://github.com/yaa110/nomino"
  url "https://github.com/yaa110/nomino/archive/1.2.1.tar.gz"
  sha256 "5814b18ce9a10bc955154b1cab96422e0c1fcb8b13169026198a78c07fbe3ed4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/yaa110/nomino.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nomino"
    sha256 cellar: :any_skip_relocation, mojave: "d89ce511bcb24347a0e754661d5a1c48675972850a1b03ce8b3e862f05c826eb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (1..9).each do |n|
      (testpath/"Homebrew-#{n}.txt").write n.to_s
    end

    system bin/"nomino", "-e", ".*-(\\d+).*", "{}"

    (1..9).each do |n|
      assert_equal n.to_s, (testpath/"#{n}.txt").read
      refute_predicate testpath/"Homebrew-#{n}.txt", :exist?
    end
  end
end

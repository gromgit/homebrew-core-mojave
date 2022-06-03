class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4/archive/v4.5.0.tar.gz"
  sha256 "8fa72c3630409d08b811654c288f32bb61dd2a8ae3c7ce101a0fb2d45e6df9d1"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/geph4"
    sha256 cellar: :any_skip_relocation, mojave: "8767bf3d38891df9d5810c84a1d525acc46d82949404f2a996ad14f47fb8c4a4"
  end

  depends_on "rust" => :build

  def install
    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "{\"error\":\"wrong password\"}",
     shell_output("#{bin}/geph4-client sync --username 'test' --password 'test' --credential-cache ~/test.db")
       .lines.last.strip
  end
end

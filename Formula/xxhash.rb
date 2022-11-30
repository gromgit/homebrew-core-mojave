class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https://github.com/Cyan4973/xxHash"
  url "https://github.com/Cyan4973/xxHash/archive/v0.8.1.tar.gz"
  sha256 "3bb6b7d6f30c591dd65aaaff1c8b7a5b94d81687998ca9400082c739a690436c"
  license all_of: [
    "BSD-2-Clause", # library
    "GPL-2.0-or-later", # `xxhsum` command line utility
  ]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xxhash"
    rebuild 4
    sha256 cellar: :any, mojave: "16215f86d4e2b6a39b6b5783a5e43432b43409ea64ae68d3e3167aac01c14160"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    prefix.install "cli/COPYING"
  end

  test do
    (testpath/"leaflet.txt").write "No computer should be without one!"
    assert_match(/^67bc7cc242ebc50a/, shell_output("#{bin}/xxhsum leaflet.txt"))
  end
end

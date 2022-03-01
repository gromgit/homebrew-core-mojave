class GoogleSparsehash < Formula
  desc "Extremely memory-efficient hash_map implementation"
  homepage "https://github.com/sparsehash/sparsehash"
  url "https://github.com/sparsehash/sparsehash/archive/sparsehash-2.0.4.tar.gz"
  sha256 "8cd1a95827dfd8270927894eb77f62b4087735cbede953884647f16c521c7e58"
  license "BSD-3-Clause"
  head "https://github.com/sparsehash/sparsehash.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/google-sparsehash"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "6e3cef5e4fc93c4cabcacbb8fbd44f08173608e875a6a8ec72f459f78dbfe32a"
  end


  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end
end

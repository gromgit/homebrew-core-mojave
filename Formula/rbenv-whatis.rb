class RbenvWhatis < Formula
  desc "Resolves abbreviations and aliases to Ruby versions"
  homepage "https://github.com/rkh/rbenv-whatis"
  url "https://github.com/rkh/rbenv-whatis/archive/v1.0.0.tar.gz"
  sha256 "1a09f824d1dcbca360565930fa66e93a9a2840c1bb45935e2ee989ce57d1f6e6"
  revision 1

  bottle do
    sha256 mojave: "f27baf8ae2f171b8f7236ee399bb9df7da423c4ef81b68d7e0ece78df850d204" # fake mojave
  end

  # https://github.com/rkh/rbenv-whatis/issues/4
  disable! date: "2021-06-19", because: :no_license

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    system "rbenv", "whatis", "2.0"
  end
end

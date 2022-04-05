class Libmonome < Formula
  include Language::Python::Shebang

  desc "Library for easy interaction with monome devices"
  homepage "https://monome.org/"
  url "https://github.com/monome/libmonome/archive/v1.4.6.tar.gz"
  sha256 "dbb886eacb465ea893465beb7b5ed8340ae77c25b24098ab36abcb69976ef748"
  license "ISC"
  head "https://github.com/monome/libmonome.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libmonome"
    sha256 cellar: :any, mojave: "7b703a00801f7835eeef94e887652510e8a2c7ab8392ab658fbdeb49a2328511"
  end

  depends_on "python@3.10" => :build
  depends_on "liblo"

  def install
    rewrite_shebang detected_python_shebang, *Dir.glob("**/{waf,wscript}")

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"

    pkgshare.install Dir["examples/*.c"]
  end

  test do
    assert_match "failed to open", shell_output("#{bin}/monomeserial", 1)
  end
end

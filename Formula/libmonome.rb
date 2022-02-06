class Libmonome < Formula
  include Language::Python::Shebang

  desc "Library for easy interaction with monome devices"
  homepage "https://monome.org/"
  url "https://github.com/monome/libmonome/archive/v1.4.4.tar.gz"
  sha256 "466acc432b023e6c0bfa8dfb46d79abb1fb8c870f16279ffca7cf5286a63a823"
  license "ISC"
  revision 1
  head "https://github.com/monome/libmonome.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libmonome"
    sha256 cellar: :any, mojave: "b5974c1e7922f9b4cd59dfbec538a25d543777e455cb8a9652e56bf1bb1da22a"
  end

  depends_on "python@3.10" => :build
  depends_on "liblo"

  def install
    # Fix build on Mojave
    # https://github.com/monome/libmonome/issues/62
    inreplace "wscript", /conf.env.append_unique.*-mmacosx-version-min=10.5.*/,
                         "pass"

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

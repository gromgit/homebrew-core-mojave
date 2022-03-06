class EchoprintCodegen < Formula
  desc "Codegen for Echoprint"
  homepage "https://github.com/spotify/echoprint-codegen"
  url "https://github.com/echonest/echoprint-codegen/archive/v4.12.tar.gz"
  sha256 "dc80133839195838975757c5f6cada01d8e09d0aac622a8a4aa23755a5a9ae6d"
  license "MIT"
  revision 2
  head "https://github.com/echonest/echoprint-codegen.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/echoprint-codegen"
    rebuild 3
    sha256 cellar: :any, mojave: "246566e76c298e47e95f3c18db06a4077f51483310068dd5eb211200ae47bde0"
  end

  deprecate! date: "2021-02-09", because: :unmaintained

  depends_on "boost"
  depends_on "ffmpeg"
  depends_on "taglib"

  # Removes unnecessary -framework vecLib; can be removed in the next release
  patch do
    url "https://github.com/echonest/echoprint-codegen/commit/5ac72c40ae920f507f3f4da8b8875533bccf5e02.patch?full_index=1"
    sha256 "1c7ffdfa498bde0da8b1b20ace5c67238338648175a067f1b129d2c726ab0fd1"
  end

  def install
    # Further Makefile fixes for https://github.com/spotify/echoprint-codegen/issues/97#issuecomment-776068938
    inreplace "src/Makefile", "-lSystem", ""
    inreplace "src/Makefile", "-framework Accelerate", ""
    system "make", "-C", "src", "install", "PREFIX=#{prefix}"
  end
end

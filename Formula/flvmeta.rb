class Flvmeta < Formula
  desc "Manipulate Adobe flash video files (FLV)"
  homepage "https://www.flvmeta.com/"
  url "https://flvmeta.com/files/flvmeta-1.2.2.tar.gz"
  sha256 "a51a2f18d97dfa1d09729546ce9ac690569b4ce6f738a75363113d990c0e5118"
  license "GPL-2.0"
  head "https://github.com/noirotm/flvmeta.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?flvmeta[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/flvmeta"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "a09788edaf87db76665a567308fbec9c95d7a976385b5d842cf368502ebe6208"
  end


  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"flvmeta", "-V"
  end
end

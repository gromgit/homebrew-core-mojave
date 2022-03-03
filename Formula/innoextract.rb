class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  url "https://constexpr.org/innoextract/files/innoextract-1.9.tar.gz"
  sha256 "6344a69fc1ed847d4ed3e272e0da5998948c6b828cb7af39c6321aba6cf88126"
  license "Zlib"
  revision 1
  head "https://github.com/dscharrer/innoextract.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?innoextract[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/innoextract"
    rebuild 1
    sha256 cellar: :any, mojave: "e3b543af83b88031bc10fb19caa894fcc93a765c3b54593eaa32079a7c09853c"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "xz"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/innoextract", "--version"
  end
end

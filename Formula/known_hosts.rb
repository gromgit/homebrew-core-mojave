class KnownHosts < Formula
  desc "Command-line manager for known hosts"
  homepage "https://github.com/markmcconachie/known_hosts"
  url "https://github.com/markmcconachie/known_hosts/archive/1.0.0.tar.gz"
  sha256 "80a080aa3850af927fd332e5616eaf82e6226d904c96c6949d6034deb397ac63"
  head "https://github.com/markmcconachie/known_hosts.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/known_hosts"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "a405195678bf642afa273667ebe54737bee515c98266c894505cd8e167d96029"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/known_hosts", "version"
  end
end

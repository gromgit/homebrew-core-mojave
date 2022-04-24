class Spack < Formula
  desc "Package manager that builds multiple versions and configurations of software"
  homepage "https://spack.io"
  url "https://github.com/spack/spack/archive/v0.17.2.tar.gz"
  sha256 "3c3c0eccc5c0a1fa89223cbdfd48c71c5be8b4645f5fa4e921426062a9b32d51"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/spack/spack.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/spack"
    sha256 cellar: :any_skip_relocation, mojave: "95a2cbb2613984184312837655cc4a1a85e53084f5e7aafcab88ad4a380a532b"
  end

  depends_on "python@3.10"

  def install
    prefix.install Dir["*"]
  end

  def post_install
    mkdir_p prefix/"var/spack/junit-report" unless (prefix/"var/spack/junit-report").exist?
  end

  test do
    system bin/"spack", "--version"
    assert_match "zlib", shell_output("#{bin}/spack info zlib")
    expected = if OS.mac?
      "clang"
    else
      "gcc"
    end
    assert_match expected, shell_output("spack compiler list")
  end
end

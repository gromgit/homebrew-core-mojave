class Gssh < Formula
  desc "SSH automation tool based on Groovy DSL"
  homepage "https://github.com/int128/groovy-ssh"
  url "https://github.com/int128/groovy-ssh/archive/2.10.1.tar.gz"
  sha256 "d1a6e2293e4f23f3245ede7d473a08d4fb6019bf18efbef1a74c894d5c50d6a1"
  license "Apache-2.0"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gssh"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "b80c5893bf2352a621866f5abdba12781553b1d76738e3b43d3385f3873ce6b5"
  end

  depends_on "openjdk@11"

  def install
    ENV["CIRCLE_TAG"] = version
    system "./gradlew", "shadowJar"
    libexec.install "cli/build/libs/gssh.jar"
    bin.write_jar_script libexec/"gssh.jar", "gssh"
  end

  test do
    system bin/"gssh"
  end
end

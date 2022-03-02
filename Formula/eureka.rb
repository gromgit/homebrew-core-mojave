class Eureka < Formula
  desc "CLI tool to input and store your ideas without leaving the terminal"
  homepage "https://github.com/simeg/eureka"
  url "https://github.com/simeg/eureka/archive/v1.8.1.tar.gz"
  sha256 "d10d412c71dea51b4973c3ded5de1503a4c5de8751be5050de989ac08eb0455e"
  license "MIT"
  head "https://github.com/simeg/eureka.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/eureka"
    rebuild 2
    sha256 cellar: :any, mojave: "09c3589b021ae34f5de8eedf8e23b98c4a8cb64f32beaf77b74be390e2dd1d87"
  end


  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "eureka [FLAGS]", shell_output("#{bin}/eureka --help 2>&1")

    (testpath/".eureka/repo_path").write <<~EOS
      homebrew
    EOS

    assert_match "homebrew/README.md: No such file or directory", pipe_output("#{bin}/eureka --view 2>&1")
  end
end

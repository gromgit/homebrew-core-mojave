class Eureka < Formula
  desc "CLI tool to input and store your ideas without leaving the terminal"
  homepage "https://github.com/simeg/eureka"
  url "https://github.com/simeg/eureka/archive/v2.0.0.tar.gz"
  sha256 "e874549e1447ee849543828f49c4c1657f7e6cfe787deea13d44241666d4aaa0"
  license "MIT"
  head "https://github.com/simeg/eureka.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/eureka"
    rebuild 1
    sha256 cellar: :any, mojave: "85138ad6eed5cb572153d878ab31b974ef1ba5cfc600349bb9edd1fd46ac5ff7"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "eureka [OPTIONS]", shell_output("#{bin}/eureka --help 2>&1")

    (testpath/".eureka/repo_path").write <<~EOS
      homebrew
    EOS

    assert_match "ERROR eureka > No such file or directory", pipe_output("#{bin}/eureka --view 2>&1")
  end
end

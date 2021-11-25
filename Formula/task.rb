class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v2.6.1/task-2.6.1.tar.gz"
  sha256 "00aa6032b3d8379a5cfa29afb66d2b0703a69e3d1fea733d225d654dbcb0084f"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/taskwarrior.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/task"
    rebuild 1
    sha256 mojave: "b263ec231b6c7ed1b6a4122283d7aa1ab911a890960066ec7aa07764ac0d8467"
  end

  depends_on "cmake" => :build
  depends_on "gnutls"

  on_linux do
    depends_on "gcc"
    depends_on "linux-headers@4.4"
    depends_on "readline"
    depends_on "util-linux"
  end

  fails_with gcc: "5"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    bash_completion.install "scripts/bash/task.sh"
    zsh_completion.install "scripts/zsh/_task"
    fish_completion.install "scripts/fish/task.fish"
  end

  test do
    touch testpath/".taskrc"
    system "#{bin}/task", "add", "Write", "a", "test"
    assert_match "Write a test", shell_output("#{bin}/task list")
  end
end

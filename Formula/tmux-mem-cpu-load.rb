class TmuxMemCpuLoad < Formula
  desc "CPU, RAM memory, and load monitor for use with tmux"
  homepage "https://github.com/thewtex/tmux-mem-cpu-load"
  url "https://github.com/thewtex/tmux-mem-cpu-load/archive/v3.6.0.tar.gz"
  sha256 "7f63e12052acda9c827959a7098c11c6da60b609b30735701977bdb799a43c42"
  license "Apache-2.0"
  head "https://github.com/thewtex/tmux-mem-cpu-load.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tmux-mem-cpu-load"
    sha256 cellar: :any_skip_relocation, mojave: "ecf247d82584740b8ef73b904ec05cd09174bd85e6a17f962a8748bc5be67bf0"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"tmux-mem-cpu-load"
  end
end

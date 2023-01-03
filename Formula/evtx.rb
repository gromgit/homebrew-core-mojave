class Evtx < Formula
  desc "Windows XML Event Log parser"
  homepage "https://github.com/omerbenamram/evtx"
  url "https://github.com/omerbenamram/evtx/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "910c6062696c8748256d6afc90983ef802026e291a241f376e1bd74352218620"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/omerbenamram/evtx.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/evtx"
    sha256 cellar: :any_skip_relocation, mojave: "6f1baffd075be0aab989f222cb91051bfcc434728c0b999f943089d3d1ce2ed5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "samples"
  end

  test do
    cp pkgshare/"samples/issue_201.evtx", testpath
    assert_match "Remote-ManagementShell-Unknown",
      shell_output("#{bin}/evtx_dump #{pkgshare}/samples/issue_201.evtx")

    assert_match "EVTX Parser #{version}", shell_output("#{bin}/evtx_dump --version")
  end
end

class ChooseRust < Formula
  desc "Human-friendly and fast alternative to cut and (sometimes) awk"
  homepage "https://github.com/theryangeary/choose"
  url "https://github.com/theryangeary/choose/archive/v1.3.4.tar.gz"
  sha256 "6c711901bb094a1241a2cd11951d5b7c96f337971f8d2eeff33f38dfa6ffb6ed"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/choose-rust"
    sha256 cellar: :any_skip_relocation, mojave: "c8853dba61b76574c3c905af3a5c3229bbbe49d395b9e732db7c444030848f03"
  end

  depends_on "rust" => :build

  conflicts_with "choose", because: "both install a `choose` binary"
  conflicts_with "choose-gui", because: "both install a `choose` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input = "foo,  foobar,bar, baz"
    assert_equal "foobar bar", pipe_output("#{bin}/choose -f ',\\s*' 1..=2", input).strip
  end
end

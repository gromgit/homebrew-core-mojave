class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://github.com/alda-lang/alda/archive/refs/tags/release-2.2.1.tar.gz"
  sha256 "ec407e58ae0dd537021cf98bd65411114c58e7a3639201442d0a94d98cbcb43c"
  license "EPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/alda"
    sha256 cellar: :any_skip_relocation, mojave: "a7e8e7f5956e47c1b45119569512303aa8c48a28059cd63996f90bed001f1725"
  end

  depends_on "go" => :build
  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    pkgshare.install "examples"
    cd "client" do
      system "go", "generate"
      system "go", "build", *std_go_args
    end
    cd "player" do
      system "gradle", "build"
      libexec.install "build/libs/alda-player-fat.jar"
      bin.write_jar_script libexec/"alda-player-fat.jar", "alda-player"
    end
  end

  test do
    (testpath/"hello.alda").write "piano: c8 d e f g f e d c2."
    json_output = JSON.parse(shell_output("#{bin}/alda parse -f hello.alda 2>/dev/null"))
    midi_notes = json_output["events"].map { |event| event["midi-note"] }
    assert_equal [60, 62, 64, 65, 67, 65, 64, 62, 60], midi_notes
  end
end

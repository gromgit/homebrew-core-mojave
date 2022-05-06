class Quran < Formula
  desc "Print Qur'an chapters and verses right in the terminal"
  homepage "https://git.hanabi.in/quran-go"
  url "https://git.hanabi.in/repos/quran-go.git",
      tag:      "v1.0.0",
      revision: "2558e37fc5be4904a963cea119bb6c836217c27b"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/quran"
    sha256 cellar: :any_skip_relocation, mojave: "c7af1be0577acbb6613595023847746375a224c91f2bbc50a709cbd4c3bb7d28"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "src/main.go"
  end

  test do
    op = shell_output("#{bin}/quran 1:1").strip
    assert_equal "In the Name of Allah—the Most Compassionate, Most Merciful.", op
  end
end

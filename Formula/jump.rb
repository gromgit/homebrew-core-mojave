class Jump < Formula
  desc "Helps you navigate your file system faster by learning your habits"
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/v0.41.0.tar.gz"
  sha256 "833151da3e9dc09190588c0a381116e3dfdf5b728869cb7b96681eb59c452b4c"
  license "MIT"
  head "https://github.com/gsamokovarov/jump.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jump"
    sha256 cellar: :any_skip_relocation, mojave: "e4342881db825ebf0a5a50bc02c9099917cb77632db0734250bf634e5ce8af4f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", "#{bin}/jump"
    man1.install "man/jump.1"
    man1.install "man/j.1"
  end

  test do
    (testpath/"test_dir").mkpath
    ENV["JUMP_HOME"] = testpath.to_s
    system "#{bin}/jump", "chdir", "#{testpath}/test_dir"

    assert_equal (testpath/"test_dir").to_s, shell_output("#{bin}/jump cd tdir").chomp
  end
end

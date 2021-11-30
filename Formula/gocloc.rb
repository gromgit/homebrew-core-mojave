class Gocloc < Formula
  desc "Little fast LoC counter"
  homepage "https://github.com/hhatto/gocloc"
  url "https://github.com/hhatto/gocloc/archive/v0.4.2.tar.gz"
  sha256 "4b3c092b405d9bd50b49d1aee1c3fa284445812b3fcfae95989a0dd2b75a25c0"
  license "MIT"
  head "https://github.com/hhatto/gocloc.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gocloc"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "ae8de3dfa4b60ba016ab838f21a99b1d772cf5fc1d8e215402d4550689a5a56b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/gocloc"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    assert_equal "{\"languages\":[{\"name\":\"C\",\"files\":1,\"code\":4,\"comment\":0," \
                 "\"blank\":0}],\"total\":{\"files\":1,\"code\":4,\"comment\":0,\"blank\":0}}",
                 shell_output("#{bin}/gocloc --output-type=json .")
  end
end

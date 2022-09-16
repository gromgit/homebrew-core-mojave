class Gocloc < Formula
  desc "Little fast LoC counter"
  homepage "https://github.com/hhatto/gocloc"
  url "https://github.com/hhatto/gocloc/archive/v0.4.3.tar.gz"
  sha256 "b96a3da5c5ec084107f29c339414774a7bf0c3c71e41ae5101cc48824ab9ecb2"
  license "MIT"
  head "https://github.com/hhatto/gocloc.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gocloc"
    sha256 cellar: :any_skip_relocation, mojave: "4615dd213e99a331ca801918c4f194d2508f1b4e32661c7b28585b0286e92ec4"
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

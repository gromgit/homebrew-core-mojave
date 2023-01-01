class D2 < Formula
  desc "Modern diagram scripting language that turns text to diagrams"
  homepage "https://d2lang.com/"
  url "https://github.com/terrastruct/d2/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "5aeeca3dcdc417b1756b6e92cbdbf8dd61214b880d2bf8586b6da5230338b091"
  license "MPL-2.0"
  head "https://github.com/terrastruct/d2.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/d2"
    sha256 cellar: :any_skip_relocation, mojave: "202a42e510273534eac57ace0a416cb09fa88e5e0cd9753974844cbca7eee687"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X oss.terrastruct.com/d2/lib/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "ci/release/template/man/d2.1"
  end

  test do
    test_file = testpath/"test.d2"
    test_file.write <<~EOS
      homebrew-core -> brew: depends
    EOS

    system bin/"d2", test_file
    assert_predicate testpath/"test.svg", :exist?

    assert_match "dagre is a directed graph layout library for JavaScript",
      shell_output("#{bin}/d2 layout dagre")

    assert_match version.to_s, shell_output("#{bin}/d2 version")
  end
end

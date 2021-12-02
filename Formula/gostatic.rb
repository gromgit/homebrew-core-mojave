class Gostatic < Formula
  desc "Fast static site generator"
  homepage "https://github.com/piranha/gostatic"
  url "https://github.com/piranha/gostatic/archive/2.32.tar.gz"
  sha256 "857de1667660e71f890de019a230ce6c0ab5fdb2420511c4cf74d5f73a5a224a"
  license "ISC"
  head "https://github.com/piranha/gostatic.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gostatic"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "ba0e19bdd013c4f74ffac9c2c354d5724ecc64e07ca5916b9a4623af63bc7f8c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"config").write <<~EOS
      TEMPLATES = site.tmpl
      SOURCE = src
      OUTPUT = out
      TITLE = Hello from Homebrew

      index.md:
      \tconfig
      \text .html
      \tmarkdown
      \ttemplate site
    EOS

    (testpath/"site.tmpl").write <<~EOS
      {{ define "site" }}
      <html><head><title>{{ .Title }}</title></head><body>{{ .Content }}</body></html>
      {{ end }}
    EOS

    (testpath/"src/index.md").write "Hello world!"

    system bin/"gostatic", testpath/"config"
    assert_predicate testpath/"out/index.html", :exist?
  end
end

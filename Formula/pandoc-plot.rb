class PandocPlot < Formula
  desc "Render and include figures in Pandoc documents using many plotting toolkits"
  homepage "https://github.com/LaurentRDC/pandoc-plot"
  url "https://hackage.haskell.org/package/pandoc-plot-1.5.2/pandoc-plot-1.5.2.tar.gz"
  sha256 "2d16d4d91d83ebb2081ec97aee3729beb7df435236f1288fc5ee96694bb3a1d0"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pandoc-plot"
    sha256 cellar: :any_skip_relocation, mojave: "c35d5bf2b4bcd7793c99316c220ac0f98825639b3a17df33ba1306592830366c"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "graphviz" => :test
  depends_on "pandoc"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    input_markdown_1 = <<~EOS
      # pandoc-plot demo

      ```{.graphviz}
      digraph {
        pandoc -> plot
      }
      ```
    EOS

    input_markdown_2 = <<~EOS
      # repeat the same thing

      ```{.graphviz}
      digraph {
        pandoc -> plot
      }
      ```
    EOS

    output_html_1 = pipe_output("pandoc --filter #{bin}/pandoc-plot -f markdown -t html5", input_markdown_1)
    output_html_2 = pipe_output("pandoc --filter #{bin}/pandoc-plot -f markdown -t html5", input_markdown_2)
    filename = output_html_1.match(%r{(plots/[\da-z]+\.png)}i)

    expected_html_2 = <<~EOS
      <h1 id="repeat-the-same-thing">repeat the same thing</h1>
      <p><img src="#{filename}" /></p>
    EOS

    assert_equal expected_html_2, output_html_2
  end
end

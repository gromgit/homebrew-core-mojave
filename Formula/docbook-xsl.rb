class DocbookXsl < Formula
  desc "XML vocabulary to create presentation-neutral documents"
  homepage "https://github.com/docbook/xslt10-stylesheets"
  url "https://github.com/docbook/xslt10-stylesheets/releases/download/release%2F1.79.2/docbook-xsl-nons-1.79.2.tar.bz2"
  sha256 "ee8b9eca0b7a8f89075832a2da7534bce8c5478fc8fc2676f512d5d87d832102"
  # Except as otherwise noted, for example, under some of the /contrib/
  # directories, the DocBook XSLT 1.0 Stylesheets use The MIT License.
  license "MIT"
  revision 1

  livecheck do
    url :homepage
    regex(%r{^(?:release/)?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3c4423c37cd6fbe99b9e1a78a294036805bfc5291a4ff5b8a3b8b52ea50e3a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9604b8989c3cc180c641b00f595e59d887aa85fbd410fb85bf4d459c6fb9f823"
    sha256 cellar: :any_skip_relocation, monterey:       "b3c4423c37cd6fbe99b9e1a78a294036805bfc5291a4ff5b8a3b8b52ea50e3a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfdfee3ff9db24a542cd8afd72cd05e67dffd88105b6af3bb1aabd9d48811dd2"
    sha256 cellar: :any_skip_relocation, catalina:       "65a5442556a88a865ef377cb73df0b3edf9ab2240e6f4bb2d71a71eabc74fa26"
    sha256 cellar: :any_skip_relocation, mojave:         "65a5442556a88a865ef377cb73df0b3edf9ab2240e6f4bb2d71a71eabc74fa26"
    sha256 cellar: :any_skip_relocation, high_sierra:    "65a5442556a88a865ef377cb73df0b3edf9ab2240e6f4bb2d71a71eabc74fa26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3c4423c37cd6fbe99b9e1a78a294036805bfc5291a4ff5b8a3b8b52ea50e3a5"
  end

  depends_on "docbook"

  resource "ns" do
    url "https://github.com/docbook/xslt10-stylesheets/releases/download/release%2F1.79.2/docbook-xsl-1.79.2.tar.bz2"
    sha256 "316524ea444e53208a2fb90eeb676af755da96e1417835ba5f5eb719c81fa371"
  end

  resource "doc" do
    url "https://github.com/docbook/xslt10-stylesheets/releases/download/release%2F1.79.2/docbook-xsl-doc-1.79.2.tar.bz2"
    sha256 "9bc38a3015717279a3a0620efb2d4bcace430077241ae2b0da609ba67d8340bc"
  end

  # see https://www.linuxfromscratch.org/blfs/view/9.1/pst/docbook-xsl.html for this patch
  patch do
    url "https://www.linuxfromscratch.org/patches/blfs/9.1/docbook-xsl-nons-1.79.2-stack_fix-1.patch"
    mirror "https://raw.githubusercontent.com/Homebrew/formula-patches/5f2d6c1/docbook-xsl/docbook-xsl-nons-1.79.2-stack_fix-1.patch"
    sha256 "a92c39715c54949ba9369add1809527b8f155b7e2a2b2e30cb4b39ee715f2e30"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    doc_files = %w[AUTHORS BUGS COPYING NEWS README RELEASE-NOTES.txt TODO VERSION VERSION.xsl]
    xsl_files = %w[assembly catalog.xml common docsrc eclipse epub epub3 extensions
                   fo highlighting html htmlhelp images javahelp lib log manpages
                   params profiling roundtrip slides template tests tools webhelp
                   website xhtml xhtml-1_1 xhtml5]
    touch "log"
    (prefix/"docbook-xsl").install xsl_files + doc_files
    resource("ns").stage do
      touch "log"
      (prefix/"docbook-xsl-ns").install xsl_files + doc_files
    end
    resource("doc").stage do
      doc.install "doc" => "reference"
    end

    bin.write_exec_script "#{prefix}/docbook-xsl/epub/bin/dbtoepub"
  end

  def post_install
    etc_catalog = etc/"xml/catalog"
    ENV["XML_CATALOG_FILES"] = etc_catalog

    {
      "xsl"    => "xsl-nons",
      "xsl-ns" => "xsl",
    }.each do |old_name, new_name|
      loc = "file://#{opt_prefix}/docbook-#{old_name}"

      # add/replace catalog entries
      cat_loc = "#{loc}/catalog.xml"
      system "xmlcatalog", "--noout", "--del", cat_loc, etc_catalog
      system "xmlcatalog", "--noout", "--add", "nextCatalog", "", cat_loc, etc_catalog

      # add rewrites for the new and old catalog URLs
      rewrites = ["rewriteSystem", "rewriteURI"]
      [
        "https://cdn.docbook.org/release/#{new_name}",
        "http://docbook.sourceforge.net/release/#{old_name}",
      ].each do |url_prefix|
        [version.to_s, "current"].each do |ver|
          system "xmlcatalog", "--noout", "--del", "#{url_prefix}/#{ver}", etc_catalog
          rewrites.each do |rewrite|
            system "xmlcatalog", "--noout", "--add", rewrite, "#{url_prefix}/#{ver}", loc, etc_catalog
          end
        end
      end
    end
  end

  test do
    system "xmlcatalog", "#{etc}/xml/catalog", "https://cdn.docbook.org/release/xsl-nons/current/"
    system "xmlcatalog", "#{etc}/xml/catalog", "https://cdn.docbook.org/release/xsl-nons/#{version}/"
    system "xmlcatalog", "#{etc}/xml/catalog", "https://cdn.docbook.org/release/xsl/current/"
    system "xmlcatalog", "#{etc}/xml/catalog", "https://cdn.docbook.org/release/xsl/#{version}/"
    system "xmlcatalog", "#{etc}/xml/catalog", "http://docbook.sourceforge.net/release/xsl/current/"
    system "xmlcatalog", "#{etc}/xml/catalog", "http://docbook.sourceforge.net/release/xsl/#{version}/"
    system "xmlcatalog", "#{etc}/xml/catalog", "http://docbook.sourceforge.net/release/xsl-ns/current/"
    system "xmlcatalog", "#{etc}/xml/catalog", "http://docbook.sourceforge.net/release/xsl-ns/#{version}/"
  end
end

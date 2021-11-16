class Docbook < Formula
  desc "Standard SGML representation system for technical documents"
  homepage "https://docbook.org/"
  url "https://docbook.org/xml/5.1/docbook-v5.1-os.zip"
  sha256 "b3f3413654003c1e773360d7fc60ebb8abd0e8c9af8e7d6c4b55f124f34d1e7f"
  license :cannot_represent
  revision 1

  livecheck do
    url "https://docbook.org/xml/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcab543bb0e0ae56e0aa106b61f77a111d52aa002c0418aae93f9fe6ac3cb332"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53a9dc79db8b2d06dc75009d5d09fc797ddcd5eb4ca040d606efd35ae4fa3829"
    sha256 cellar: :any_skip_relocation, monterey:       "dcab543bb0e0ae56e0aa106b61f77a111d52aa002c0418aae93f9fe6ac3cb332"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c4e8398b5548cef2830169aadaf6221ac9ee7e6733547642ccee1ea81e07e99"
    sha256 cellar: :any_skip_relocation, catalina:       "8152e5356c47a7b8282f3ed84ee3f29565e8ce620bddeaeaf23dfd1f5ef111a3"
    sha256 cellar: :any_skip_relocation, mojave:         "8152e5356c47a7b8282f3ed84ee3f29565e8ce620bddeaeaf23dfd1f5ef111a3"
    sha256 cellar: :any_skip_relocation, high_sierra:    "8152e5356c47a7b8282f3ed84ee3f29565e8ce620bddeaeaf23dfd1f5ef111a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcab543bb0e0ae56e0aa106b61f77a111d52aa002c0418aae93f9fe6ac3cb332"
  end

  uses_from_macos "libxml2"

  resource "xml412" do
    url "https://docbook.org/xml/4.1.2/docbkx412.zip"
    sha256 "30f0644064e0ea71751438251940b1431f46acada814a062870f486c772e7772"
    version "4.1.2"
  end

  resource "xml42" do
    url "https://docbook.org/xml/4.2/docbook-xml-4.2.zip"
    sha256 "acc4601e4f97a196076b7e64b368d9248b07c7abf26b34a02cca40eeebe60fa2"
  end

  resource "xml43" do
    url "https://docbook.org/xml/4.3/docbook-xml-4.3.zip"
    sha256 "23068a94ea6fd484b004c5a73ec36a66aa47ea8f0d6b62cc1695931f5c143464"
  end

  resource "xml44" do
    url "https://docbook.org/xml/4.4/docbook-xml-4.4.zip"
    sha256 "02f159eb88c4254d95e831c51c144b1863b216d909b5ff45743a1ce6f5273090"
  end

  resource "xml45" do
    url "https://docbook.org/xml/4.5/docbook-xml-4.5.zip"
    sha256 "4e4e037a2b83c98c6c94818390d4bdd3f6e10f6ec62dd79188594e26190dc7b4"
  end

  resource "xml50" do
    url "https://docbook.org/xml/5.0/docbook-5.0.zip"
    sha256 "3dcd65e1f5d9c0c891b3be204fa2bb418ce485d32310e1ca052e81d36623208e"
  end

  resource "xml51" do
    url "https://docbook.org/xml/5.1/docbook-v5.1-os.zip"
    sha256 "b3f3413654003c1e773360d7fc60ebb8abd0e8c9af8e7d6c4b55f124f34d1e7f"
  end

  def install
    (etc/"xml").mkpath

    %w[42 412 43 44 45 50 51].each do |version|
      resource("xml#{version}").stage do |r|
        if version == "412"
          cp prefix/"docbook/xml/4.2/catalog.xml", "catalog.xml"

          inreplace "catalog.xml" do |s|
            s.gsub! "V4.2 ..", "V4.1.2 "
            s.gsub! "4.2", "4.1.2"
          end
        end

        rm_rf "docs"
        (prefix/"docbook/xml"/r.version).install Dir["*"]
      end
    end
  end

  def post_install
    etc_catalog = etc/"xml/catalog"
    ENV["XML_CATALOG_FILES"] = etc_catalog

    # only create catalog file if it doesn't exist already to avoid content added
    # by other formulae to be removed
    system "xmlcatalog", "--noout", "--create", etc_catalog unless File.file?(etc_catalog)

    %w[4.2 4.1.2 4.3 4.4 4.5 5.0 5.1].each do |version|
      catalog = opt_prefix/"docbook/xml/#{version}/catalog.xml"

      system "xmlcatalog", "--noout", "--del",
             "file://#{catalog}", etc_catalog
      system "xmlcatalog", "--noout", "--add", "nextCatalog",
             "", "file://#{catalog}", etc_catalog
    end
  end

  def caveats
    <<~EOS
      To use the DocBook package in your XML toolchain,
      you need to add the following to your ~/.bashrc:

      export XML_CATALOG_FILES="#{etc}/xml/catalog"
    EOS
  end

  test do
    assert_predicate etc/"xml/catalog", :exist?
  end
end

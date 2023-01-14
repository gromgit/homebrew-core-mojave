class Epubcheck < Formula
  desc "Validate EPUB files, version 2.0 and later"
  homepage "https://github.com/w3c/epubcheck"
  url "https://github.com/w3c/epubcheck/releases/download/v5.0.0/epubcheck-5.0.0.zip"
  sha256 "98c5ecce0a6a6bf37034f73465613c4088916b3ef3489f50a7f6897a37a9725a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "942d5ff8e4985575d7e089ee2a3690ba02450f26289c754f8011d8bc044566b0"
  end

  depends_on "openjdk"

  def install
    jarname = "epubcheck.jar"
    libexec.install jarname, "lib"
    bin.write_jar_script libexec/jarname, "epubcheck"
  end
end

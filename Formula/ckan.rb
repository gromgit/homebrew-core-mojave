class Ckan < Formula
  desc "Comprehensive Kerbal Archive Network"
  homepage "https://github.com/KSP-CKAN/CKAN/"
  url "https://github.com/KSP-CKAN/CKAN/releases/download/v1.30.4/ckan.exe"
  sha256 "2203ea5040e9688b86a1a1a81f61821338772b1177a64242dd58d3617c128901"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ckan"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "8ea05277625e1a8266fd3b2116108f87c774777e991036c6fbfb3b0f4fbe6a40"
  end


  depends_on "mono"

  def install
    (libexec/"bin").install "ckan.exe"
    (bin/"ckan").write <<~EOS
      #!/bin/sh
      exec mono "#{libexec}/bin/ckan.exe" "$@"
    EOS
  end

  def caveats
    <<~EOS
      To use the CKAN GUI, install the ckan-app cask.
    EOS
  end

  test do
    system bin/"ckan", "version"
  end
end

class Montage < Formula
  desc "Toolkit for assembling FITS images into custom mosaics"
  homepage "http://montage.ipac.caltech.edu"
  url "http://montage.ipac.caltech.edu/download/Montage_v4.0.tar.gz"
  sha256 "de143e4d4b65086f04bb75cf482dfa824965a5a402f3431f9bceb395033df5fe"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "304f02cffd94ee9e118026fda40db0f27d4ae25c2d42c74e45b3426d11f1ed3d"
    sha256 cellar: :any_skip_relocation, catalina:    "0335521dd15d7debbfb5db21efbf5f751c571d406fd91aeaa9996226cca63d33"
    sha256 cellar: :any_skip_relocation, mojave:      "ee1b94e776a2ad68ea41b1edb6a3fb549c43bb373f3f7b9fb3709e4e4fbbb4e8"
    sha256 cellar: :any_skip_relocation, high_sierra: "3a8fab4097bd0dd0524a5a482065284d35ea0fdd946fb1f5d5ea1e103f5d4443"
    sha256 cellar: :any_skip_relocation, sierra:      "70b1769202095b84da05fe00a1934d8e8da3fd08b7ddb7135937f4cdc0107f07"
    sha256 cellar: :any_skip_relocation, el_capitan:  "503c3e946aa0d8f277b5e4a5aab75086d5c895551fa679a3129183b95f89b236"
    sha256 cellar: :any_skip_relocation, yosemite:    "7f9bb66eff925f20099f11ee247e4ba4c8b4821b74c7f2a3efd93d474e9a1b3f"
  end

  conflicts_with "wdiff", because: "both install an `mdiff` executable"

  def install
    system "make"
    bin.install Dir["bin/m*"]
  end

  def caveats
    <<~EOS
      Montage is under the Caltech/JPL non-exclusive, non-commercial software
      licence agreement available at:
        http://montage.ipac.caltech.edu/docs/download.html
    EOS
  end

  test do
    system bin/"mHdr", "m31", "1", "template.hdr"
  end
end

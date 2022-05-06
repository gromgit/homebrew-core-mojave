class MdaLv2 < Formula
  desc "LV2 port of the MDA plugins"
  homepage "https://drobilla.net/software/mda-lv2.html"
  url "https://download.drobilla.net/mda-lv2-1.2.6.tar.bz2"
  sha256 "cd66117024ae049cf3aca83f9e904a70277224e23a969f72a9c5d010a49857db"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://download.drobilla.net"
    regex(/href=.*?mda-lv2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mda-lv2"
    sha256 cellar: :any, mojave: "e38c6d6fa0302adcf4c5a2a4afe2a8e7ed30942f47b52298e8f263a5af93cdb2"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "sord" => :test
  depends_on "lv2"

  def install
    ENV.cxx11
    system "python3", "./waf", "configure", "--prefix=#{prefix}", "--lv2dir=#{lib}/lv2"
    system "python3", "./waf"
    system "python3", "./waf", "install"
  end

  test do
    # Validate mda.lv2 plugin metadata (needs definitions included from lv2)
    system Formula["sord"].opt_bin/"sord_validate",
           *Dir[Formula["lv2"].opt_lib/"**/*.ttl"],
           *Dir[lib/"lv2/mda.lv2/*.ttl"]
  end
end

class Pax < Formula
  desc "Portable Archive Interchange archive tool"
  homepage "https://www.mirbsd.org/pax.htm"
  url "http://www.mirbsd.org/MirOS/dist/mir/cpio/paxmirabilis-20201030.tgz"
  sha256 "1cc892c9c8ce265d28457bab4225eda71490d93def0a1d2271430c2863b728dc"
  license "MirOS"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pax"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "1ee6b0840ec0b2f9d64decc61b302066c8b317e10a38b507f816833ad218dd82"
  end

  on_macos do
    keg_only "provided by macOS"
  end

  def install
    mkdir "build" do
      system "sh", "../Build.sh", "-r", "-tpax"
      bin.install "pax"
    end
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/pax", "-f", "#{testpath}/foo.pax", "-w", "#{testpath}/foo"
    rm testpath/"foo"
    system "#{bin}/pax", "-f", testpath/"foo.pax", "-r"
    assert_predicate testpath/"foo", :exist?
  end
end

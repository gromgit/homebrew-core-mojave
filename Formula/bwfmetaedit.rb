class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/22.11/BWFMetaEdit_CLI_22.11_GNU_FromSource.tar.bz2"
  sha256 "82ddb459b5c624dd1debf03e2a21758c514fbcebdea69cdd94364f777751f897"
  license "0BSD"

  livecheck do
    url "https://mediaarea.net/BWFMetaEdit/Download/Source"
    regex(/href=.*?bwfmetaedit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bwfmetaedit"
    sha256 cellar: :any_skip_relocation, mojave: "0b828a6584298e5c10ebffd6f2c9d9e5b1c2c1400ccb03530392eff861e9f312"
  end

  def install
    cd "Project/GNU/CLI" do
      system "./configure",  "--disable-debug", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/bwfmetaedit --out-tech", test_fixtures("test.wav"))
  end
end

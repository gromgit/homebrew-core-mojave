class Jo < Formula
  desc "JSON output from a shell"
  homepage "https://github.com/jpmens/jo"
  url "https://github.com/jpmens/jo/releases/download/1.9/jo-1.9.tar.gz"
  sha256 "0195cd6f2a41103c21544e99cd9517b0bce2d2dc8cde31a34867977f8a19c79f"
  license all_of: ["GPL-2.0-or-later", "MIT"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jo"
    sha256 cellar: :any_skip_relocation, mojave: "a6304a6076953553b7a3596c631143ab0b484a9c273688e4089c867c2d8c4af9"
  end

  head do
    url "https://github.com/jpmens/jo.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?

    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal %Q({"success":true,"result":"pass"}\n), pipe_output("#{bin}/jo success=true result=pass")
  end
end

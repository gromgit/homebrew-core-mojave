class When < Formula
  desc "Tiny personal calendar"
  homepage "https://www.lightandmatter.com/when/when.html"
  url "https://github.com/bcrowell/when/archive/1.1.44.tar.gz"
  sha256 "de8334d97a106b9e3aad42d0a169e46e276db0935b3e4239403730eadcb41cbb"
  license "GPL-2.0-only"
  head "https://github.com/bcrowell/when.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/when"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "dfecfbb0b3406bffc885574f3bb6328d3a586295d36bc889ed2ea57a97417ad6"
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/".when/preferences").write <<~EOS
      calendar = #{testpath}/calendar
    EOS

    (testpath/"calendar").write "2015 April 1, stay off the internet"
    system bin/"when", "i"
  end
end

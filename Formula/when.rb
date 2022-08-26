class When < Formula
  desc "Tiny personal calendar"
  homepage "https://www.lightandmatter.com/when/when.html"
  url "https://github.com/bcrowell/when/archive/1.1.43.tar.gz"
  sha256 "ddc3332aeadb4b786182128d3b04db38176b59969ae6980a7187d40b14528576"
  license "GPL-2.0-only"
  head "https://github.com/bcrowell/when.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/when"
    sha256 cellar: :any_skip_relocation, mojave: "87866e4e15dcd604cb631fe6a89b6517d9b92bba2071b3caa396a8c79a709f54"
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

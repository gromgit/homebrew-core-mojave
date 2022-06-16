class Jpegrescan < Formula
  desc "Losslessly shrink any JPEG file"
  homepage "https://github.com/kud/jpegrescan"
  url "https://github.com/kud/jpegrescan/archive/1.1.0.tar.gz"
  sha256 "a8522e971d11c904f4b61af665c3be800f26404e2b14f5f80c675b4a72a42b32"
  license :public_domain
  revision 1
  head "https://github.com/kud/jpegrescan.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jpegrescan"
    sha256 cellar: :any_skip_relocation, mojave: "b7e337050c5026743c9ef33c6b49423de22348cbac8f28f2a49f4635a52232d5"
  end

  depends_on "jpeg-turbo"

  uses_from_macos "perl"

  on_linux do
    resource "File::Slurp" do
      url "https://cpan.metacpan.org/authors/id/C/CA/CAPOEIRAB/File-Slurp-9999.32.tar.gz"
      sha256 "4c3c21992a9d42be3a79dd74a3c83d27d38057269d65509a2f555ea0fb2bc5b0"
    end
  end

  def install
    env = { PATH: "#{Formula["jpeg-turbo"].opt_bin}:$PATH" }
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      env["PERL5LIB"] = ENV["PERL5LIB"]
      resource("File::Slurp").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end
    bin.install "jpegrescan"
    bin.env_script_all_files libexec/"bin", env
  end

  test do
    system bin/"jpegrescan", "-v", test_fixtures("test.jpg"), testpath/"out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end

class Readline < Formula
  desc "Library for command-line editing"
  homepage "https://tiswww.case.edu/php/chet/readline/rltop.html"
  url "https://ftp.gnu.org/gnu/readline/readline-8.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/readline/readline-8.2.tar.gz"
  version "8.2.1"
  sha256 "3feb7171f16a84ee82ca18a36d7b9be109a52c04f492a053331d7d1095007c35"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/readline"
    sha256 cellar: :any, mojave: "65c82c7903044d66eab8542351566359361401f308568975fb326ee4f81fe7df"
  end

  %w[
    001 bbf97f1ec40a929edab5aa81998c1e2ef435436c597754916e6a5868f273aff7
  ].each_slice(2) do |p, checksum|
    patch :p0 do
      url "https://ftp.gnu.org/gnu/readline/readline-8.2-patches/readline82-#{p}"
      mirror "https://ftpmirror.gnu.org/readline/readline-8.2-patches/readline82-#{p}"
      sha256 checksum
    end
  end

  # We're not using `url :stable` here because we need `url` to be a string
  # when we use it in the `strategy` block.
  livecheck do
    url "https://ftp.gnu.org/gnu/readline/"
    regex(/href=.*?readline[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :gnu do |page, regex|
      # Match versions from files
      versions = page.scan(regex)
                     .flatten
                     .uniq
                     .map { |v| Version.new(v) }
                     .sort
      next versions if versions.blank?

      # Assume the last-sorted version is newest
      newest_version = versions.last

      # Simply return the found versions if there isn't a patches directory
      # for the "newest" version
      patches_directory = page.match(%r{href=.*?(readline[._-]v?#{newest_version.major_minor}[._-]patches/?)["' >]}i)
      next versions if patches_directory.blank?

      # Fetch the page for the patches directory
      patches_page = Homebrew::Livecheck::Strategy.page_content(URI.join(@url, patches_directory[1]).to_s)
      next versions if patches_page[:content].blank?

      # Generate additional major.minor.patch versions from the patch files in
      # the directory and add those to the versions array
      patches_page[:content].scan(/href=.*?readline[._-]?v?\d+(?:\.\d+)*[._-]0*(\d+)["' >]/i).each do |match|
        versions << "#{newest_version.major_minor}.#{match[0]}"
      end

      versions
    end
  end

  keg_only :shadowed_by_macos, "macOS provides BSD libedit"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-curses"
    # FIXME: Setting `SHLIB_LIBS` should not be needed, but, on Linux,
    #        many dependents expect readline to link with ncurses and
    #        are broken without it. Readline should be agnostic about
    #        the terminfo library on Linux.
    system "make", "install", "SHLIB_LIBS=-lcurses"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <readline/readline.h>

      int main()
      {
        printf("%s\\n", readline("test> "));
        return 0;
      }
    EOS

    system ENV.cc, "-L", lib, "test.c", "-L#{lib}", "-lreadline", "-o", "test"
    assert_equal "test> Hello, World!\nHello, World!", pipe_output("./test", "Hello, World!\n").strip
  end
end

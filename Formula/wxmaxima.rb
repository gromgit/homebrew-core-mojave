class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://wxmaxima-developers.github.io/wxmaxima/"
  url "https://github.com/wxMaxima-developers/wxmaxima/archive/Version-21.11.0.tar.gz"
  sha256 "167e412708e1ef6f68fe934e55844af25a6d4e6f176eb26d46858576b17a90dd"
  license "GPL-2.0-or-later"
  head "https://github.com/wxMaxima-developers/wxmaxima.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "ninja" => :build
  depends_on "maxima"
  depends_on "wxwidgets"

  def install
    mkdir "build-wxm" do
      system "cmake", "..", "-GNinja", *std_cmake_args
      system "ninja"
      system "ninja", "install"

      prefix.install "src/wxMaxima.app" if OS.mac?
    end

    bash_completion.install "data/wxmaxima"

    bin.write_exec_script "#{prefix}/wxMaxima.app/Contents/MacOS/wxmaxima" if OS.mac?
  end

  def caveats
    <<~EOS
      When you start wxMaxima the first time, set the path to Maxima
      (e.g. #{HOMEBREW_PREFIX}/bin/maxima) in the Preferences.

      Enable gnuplot functionality by setting the following variables
      in ~/.maxima/maxima-init.mac:
        gnuplot_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
        draw_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
    EOS
  end

  test do
    on_linux do
      # Error: Unable to initialize GTK+, is DISPLAY set properly
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    assert_match "algebra", shell_output("#{bin}/wxmaxima --help 2>&1")
  end
end

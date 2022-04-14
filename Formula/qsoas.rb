class Qsoas < Formula
  desc "Versatile software for data analysis"
  homepage "https://bip.cnrs.fr/groups/bip06/software/"
  url "https://bip.cnrs.fr/wp-content/uploads/qsoas/qsoas-3.0.tar.gz"
  sha256 "54b54f54363f69a9845b3e9aa4da7dae9ceb7bb0f3ed59ba92ffa3b408163850"
  license "GPL-2.0-only"
  revision 2

  livecheck do
    url "https://github.com/fourmond/QSoas.git"
    regex(/(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/qsoas"
    rebuild 2
    sha256 cellar: :any, mojave: "307ed10be77c41b2cdccf99b15c45f74036784322e350828fcc751d5e10ee47d"
  end

  depends_on "bison" => :build
  depends_on "gsl"
  depends_on "qt@5"

  uses_from_macos "ruby"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  # Needs mruby 2, see https://github.com/fourmond/QSoas/issues/2
  resource "mruby2" do
    url "https://github.com/mruby/mruby/archive/2.1.2.tar.gz"
    sha256 "4dc0017e36d15e81dc85953afb2a643ba2571574748db0d8ede002cefbba053b"
  end

  def install
    resource("mruby2").stage do
      inreplace "build_config.rb", /default/, "full-core"
      system "make"

      cd "build/host/" do
        libexec.install %w[bin lib mrbgems mrblib]
      end

      libexec.install "include"
    end

    gsl = Formula["gsl"].opt_prefix
    qt5 = Formula["qt@5"].opt_prefix

    system "#{qt5}/bin/qmake", "MRUBY_DIR=#{libexec}", "GSL_DIR=#{gsl}/include",
                    "QMAKE_LFLAGS=-L#{libexec}/lib -L#{gsl}/lib"
    system "make"

    if OS.mac?
      prefix.install "QSoas.app"
      bin.write_exec_script "#{prefix}/QSoas.app/Contents/MacOS/QSoas"
    else
      bin.install "QSoas"
    end
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error "qt.qpa.xcb: could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_match "mfit-linear-kinetic-system",
                 shell_output("#{bin}/QSoas --list-commands")
  end
end

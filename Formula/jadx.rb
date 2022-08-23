class Jadx < Formula
  desc "Dex to Java decompiler"
  homepage "https://github.com/skylot/jadx"
  url "https://github.com/skylot/jadx/releases/download/v1.4.4/jadx-1.4.4.zip"
  sha256 "8385766824fa4f32f468c52d7b9729e7a5d153fd9902cd6943c27d0b040a2b57"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b822e655e25cf91d01baf922940b79ece90b40f774c045126fd4e1653d7dd776"
  end

  head do
    url "https://github.com/skylot/jadx.git"
    depends_on "gradle" => :build
  end

  depends_on "openjdk"

  resource "homebrew-sample.apk" do
    url "https://github.com/downloads/stephanenicolas/RoboDemo/robodemo-sample-1.0.1.apk"
    sha256 "bf3ec04631339538c8edb97ebbd5262c3962c5873a2df9022385156c775eb81f"
  end

  def install
    if build.head?
      system "gradle", "clean", "dist"
      libexec.install Dir["build/jadx/*"]
    else
      libexec.install Dir["*"]
    end
    bin.install libexec/"bin/jadx"
    bin.install libexec/"bin/jadx-gui"
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    resource("homebrew-sample.apk").stage do
      system "#{bin}/jadx", "-d", "out", "robodemo-sample-1.0.1.apk"
    end
  end
end

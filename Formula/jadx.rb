class Jadx < Formula
  desc "Dex to Java decompiler"
  homepage "https://github.com/skylot/jadx"
  url "https://github.com/skylot/jadx/releases/download/v1.3.2/jadx-1.3.2.zip"
  sha256 "56a1c0c7084d2033a68eef76058ee0cb7daec0cb5233120a4bceb0fdd7960e39"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "50de5d4c316431e7847da37f412963fbd61588c25f457ccf700c031dcd8ea459"
  end

  head do
    url "https://github.com/skylot/jadx.git"
    depends_on "gradle" => :build
  end

  depends_on "openjdk"

  resource "sample.apk" do
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
    resource("sample.apk").stage do
      system "#{bin}/jadx", "-d", "out", "robodemo-sample-1.0.1.apk"
    end
  end
end

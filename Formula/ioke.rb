class Ioke < Formula
  desc "Dynamic language targeted at virtual machines"
  homepage "https://ioke.org/"
  url "https://ioke.org/dist/ioke-P-ikj-0.4.0.tar.gz"
  sha256 "701d24d8a8d0901cde64f11c79605c21d43cafbfb2bdd86765b664df13daec7c"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "952a64519aebf02d5c58f64414703741267651dde48243f8a77629434a77e702"
  end

  deprecate! date: "2021-11-24", because: :unmaintained

  depends_on "openjdk"

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    # Install jars in libexec to avoid conflicts
    libexec.install Dir["*"]

    # Point IOKE_HOME to libexec
    inreplace libexec/"bin/ioke" do |s|
      s.change_make_var! "IOKE_HOME", libexec
    end

    (bin/"ioke").write_env_script libexec/"bin/ioke", Language::Java.overridable_java_home_env
    bin.install_symlink libexec/"bin/ispec",
                        libexec/"bin/dokgen"
  end

  test do
    system "#{bin}/ioke", "-e", '"test" println'
  end
end

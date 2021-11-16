class Publish < Formula
  desc "Static site generator for Swift developers"
  homepage "https://github.com/JohnSundell/Publish"
  url "https://github.com/JohnSundell/Publish/archive/0.8.0.tar.gz"
  sha256 "c807030d86490ebb633f8326319dac4036d41297598709670284e4f7044d7883"
  license "MIT"
  head "https://github.com/JohnSundell/Publish.git", branch: "master"


  # https://github.com/JohnSundell/Publish#system-requirements
  depends_on xcode: ["12.5", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/publish-cli" => "publish"
  end

  test do
    mkdir testpath/"test" do
      system "#{bin}/publish", "new"
      assert_predicate testpath/"test"/"Package.swift", :exist?
    end
  end
end

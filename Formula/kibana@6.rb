class KibanaAT6 < Formula
  desc "Analytics and search dashboard for Elasticsearch"
  homepage "https://www.elastic.co/products/kibana"
  url "https://github.com/elastic/kibana.git",
      tag:      "v6.8.20",
      revision: "d872739e24c6cdac75501f19bf4fe0a1b198c524"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kibana@6"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "c8eda63e854352020cedbfe328928b69a233fae25c7164aa01a8031c8e65543b"
  end

  keg_only :versioned_formula

  deprecate! date: "2022-02-10", because: :unsupported

  depends_on "yarn" => :build
  depends_on :macos # Due to Python 2
  depends_on "node@10"

  def install
    # remove non open source files
    rm_rf "x-pack"
    inreplace "package.json", /"x-pack":.*/, ""

    # patch build to not try to read tsconfig.json's from the removed x-pack folder
    inreplace "src/dev/typescript/projects.ts" do |s|
      s.gsub! "new Project(resolve(REPO_ROOT, 'x-pack/tsconfig.json')),", ""
      s.gsub! "new Project(resolve(REPO_ROOT, 'x-pack/test/tsconfig.json'), 'x-pack/test'),", ""
    end

    inreplace "package.json", /"node": "10\.\d+\.\d+"/, %Q("node": "#{Formula["node@10"].version}")
    system "yarn", "kbn", "bootstrap"
    system "yarn", "build", "--oss", "--release", "--skip-os-packages", "--skip-archives"

    prefix.install Dir
      .glob("build/oss/kibana-#{version}-darwin-x86_64/**")
      .reject { |f| File.fnmatch("build/oss/kibana-#{version}-darwin-x86_64/{node, data, plugins}", f) }
    mv "licenses/APACHE-LICENSE-2.0.txt", "LICENSE.txt" # install OSS license

    cd prefix do
      inreplace "config/kibana.yml", "/var/run/kibana.pid", var/"run/kibana.pid"
      (etc/"kibana").install Dir["config/*"]
      rm_rf "config"
    end
  end

  def post_install
    ln_s etc/"kibana", prefix/"config"
    (prefix/"data").mkdir
    (prefix/"plugins").mkdir
  end

  def caveats
    <<~EOS
      Config: #{etc}/kibana/
      If you wish to preserve your plugins upon upgrade, make a copy of
      #{opt_prefix}/plugins before upgrading, and copy it into
      the new keg location after upgrading.
    EOS
  end

  plist_options manual: "kibana"

  service do
    run opt_bin/"kibana"
    run_type :immediate
  end

  test do
    ENV["BABEL_CACHE_PATH"] = testpath/".babelcache.json"
    assert_match version.to_s, shell_output("#{bin}/kibana -V")
  end
end

class Iraf < Formula
  desc "Image Reduction and Analysis Facility"
  homepage "https://github.com/iraf-community/iraf"
  url "https://github.com/iraf-community/iraf/archive/refs/tags/v2.18.1.tar.gz"
  sha256 "d4e0859088459622625d27b5c025524dc70fbf334e8df5e59dd32b65630e7981"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-2.18.1"
    rebuild 5
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3d9bbdbdf55d3eb3930f8cea896bbe6384c17f80a0bf1282f3bca49e64ad433"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f10d3e3799931adfae4bdb35839f98d30340f45135889194456d27ef6d3cd55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c397d9d4e677b1a4c19d404a9c58742ee8680e9bf1cfb078688f7f61092ca07b"
    sha256 cellar: :any_skip_relocation, sequoia:       "1b362b85e25fff0d55634f1ffdf00d3583596eeb8bd521d962ae0dd3b8199a95"
  end

  def install
    system "make", "IRAFARCH="
    system "make", "install", "DESTDIR=build", "prefix=/usr"

    libexec.install Dir["build/usr/lib/iraf/*"]
    share.install Dir["build/usr/share/*"]

    env = { "iraf" => "#{libexec}/" }
    (bin/"irafcl").write_env_script libexec/"unix/hlib/irafcl.sh", env
    (bin/"cl").write_env_script libexec/"unix/hlib/irafcl.sh", env
    (bin/"ecl").write_env_script libexec/"unix/hlib/irafcl.sh", env
    (bin/"mkiraf").write_env_script libexec/"unix/hlib/mkiraf.sh", env
    (bin/"mkpkg").write_env_script libexec/"unix/bin/mkpkg.e", env
    (bin/"rmbin").write_env_script libexec/"unix/bin/rmbin.e", env
    (bin/"rmfiles").write_env_script libexec/"unix/bin/rmfiles.e", env
    (bin/"rtar").write_env_script libexec/"unix/bin/rtar.e", env
    (bin/"wtar").write_env_script libexec/"unix/bin/wtar.e", env
    (bin/"xc").write_env_script libexec/"unix/bin/xc.e", env
    (bin/"xyacc").write_env_script libexec/"unix/bin/xyacc.e", env
    (bin/"sgidispatch").write_env_script libexec/"unix/bin/sgidispatch.e", env
    rm_r libexec/"extern"
    iraf_extern = HOMEBREW_PREFIX/"lib/iraf/extern"
    libexec.install_symlink iraf_extern => "extern"
  end

  def post_install
    iraf_extern = HOMEBREW_PREFIX/"lib/iraf/extern"
    mkdir_p iraf_extern
  end

  test do
    (testpath/"version.cl").write <<~EOF
      =version
      logout
    EOF
    assert_match "IRAF V2.18.1 2025", shell_output("#{HOMEBREW_PREFIX}/bin/irafcl -f version.cl")
  end
end

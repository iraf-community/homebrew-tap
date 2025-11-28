class Iraf < Formula
  desc "Image Reduction and Analysis Facility"
  homepage "https://github.com/iraf-community/iraf"
  url "https://github.com/iraf-community/iraf/archive/refs/tags/v2.18.1.tar.gz"
  sha256 "d4e0859088459622625d27b5c025524dc70fbf334e8df5e59dd32b65630e7981"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-2.18.1"
    rebuild 6
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "268fd19830074fb220eb392175705f43c8b7f5255d68cd75c8e853bef1d96df3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99d939886aa7be7ac6d4d7143a282df41f5f5718e6bb198f0f1dce149fded71e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a45507b70cebe1d23e54ee8b3243cfd76a5d0f7ae86baa7a1f066a83df43024d"
    sha256 cellar: :any_skip_relocation, sequoia:       "cfdcaa2caaa47e89b8918777ec46a70151dfe4b6e6dcecd7afc2e394a27fda54"
  end

  patch do
    # Add command line execution to IRAF cl
    url "https://github.com/iraf-community/iraf/commit/fee0c080deb91b91543b0750cda62662e3744ea0.patch?full_index=1"
  end

  patch do
    # Add helpdb compilation to Makefile
    url "https://github.com/iraf-community/iraf/commit/f905ce0ccaf39e6a29d238b910b3ae75caf716e6.patch?full_index=1"
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
    assert_match "IRAF V2.18.1 2025", shell_output("#{HOMEBREW_PREFIX}/bin/irafcl -c =version")
  end
end

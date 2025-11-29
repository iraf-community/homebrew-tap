class Iraf < Formula
  desc "Image Reduction and Analysis Facility"
  homepage "https://github.com/iraf-community/iraf"
  url "https://github.com/iraf-community/iraf/archive/refs/tags/v2.18.1.tar.gz"
  sha256 "d4e0859088459622625d27b5c025524dc70fbf334e8df5e59dd32b65630e7981"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-2.18.1"
    rebuild 7
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff9d96de0044d1b1835761d65640d627b56a11a0c97faaa2f2c49433490ead6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c442572e31cd703df3b992bf2b00f07d9cadce4ff05eafb2c6d4d969d701c2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ffd8976918deae15a92a254d5175170031a12bd6e0ebed2b6073a5328b610b0"
    sha256 cellar: :any_skip_relocation, sequoia:       "30a10d80ee364aab464f950dfab08dbe6c55bb0dd0ad6b17866c44f7f9bc438e"
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

  def caveats
    <<~EOS
      If x11iraf is installed, IRAF can be started with "irafcl -x"
      within a newly started X11 xgterm.  External software may
      require to set the "iraf" environment variable to:

        export iraf=#{opt_libexec}/

      You may want to add this line to your startup script.
    EOS
  end

  test do
    # Extract the version string of the package directly from the .par
    # file and check whether it can be reproduced from the
    # corresponding IRAF variable.
    ref = shell_output("grep ^version, #{opt_libexec}/pkg/ecl/cl.par  | cut -d\\\" -f2")
    ver = shell_output("#{bin}/irafcl -c =version")
    puts "'#{ref}' == '#{ver}'?"
    assert_match ref, ver
  end
end

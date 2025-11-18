class Iraf < Formula
  desc "Image Reduction and Analysis Facility"
  homepage "https://github.com/iraf-community/iraf"
  url "https://github.com/iraf-community/iraf/archive/refs/tags/v2.18.1.tar.gz"
  sha256 "d4e0859088459622625d27b5c025524dc70fbf334e8df5e59dd32b65630e7981"

  def install
    system "make"
    system "make", "install", "DESTDIR=build", "prefix=/usr"

    rm_r "build/usr/lib/iraf/extern"
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
  end

  def post_install
    iraf_extern = HOMEBREW_PREFIX/"lib/iraf-extern"
    mkdir_p iraf_extern
    iraf_extern.install_symlink libexec/"extern"
  end
end

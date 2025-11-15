class X11iraf < Formula
  desc "X11 support for IRAF"
  homepage "https://iraf-community.github.io/x11iraf"
  url "https://github.com/iraf-community/x11iraf/archive/refs/tags/v2.2.tar.gz"
  sha256 "f5c6e0b56a1f68e8c15a766d8521ec47176c4f4cb3d38e48f142dd0261746f91"

  depends_on "libxaw"
  depends_on "libxaw3d"
  depends_on "libxmu"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "ncurses"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
    system "tic", "-v", "-o", "#{share}/terminfo", "xgterm/xgterm.terminfo"
    libexec.install bin/"xgterm"
    (bin/"xgterm").write_env_script(libexec/"xgterm", TERMINFO: "#{opt_prefix}/share/terminfo")
  end
end

class IrafSt4gem < Formula
  desc "IRAF external package for tabular spectra"
  homepage "https://github.com/iraf-community/iraf-st4gem"
  url "https://gitlab.com/nsf-noirlab/csdc/usngo/iraf/st4gem.git",
      tag: "v1.2.1", revision: "e61f8c2f69265feb849fe065d409cf41bd635473"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-st4gem-1.2.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "eb775d4d152462608e6516951e0dd9ad22b417127db978473e75f78bc3db4202"
    sha256 cellar: :any_skip_relocation, sequoia:     "42f52038be1620326303a04e91cc828dd687143dd096f46bb05ba51cb09dcd1c"
  end

  depends_on "iraf"

  def install
    rm_r Dir["bin*"]
    mkdir_p buildpath/"bin"
    ENV["st4gem"] = "#{buildpath}/"
    system "mkpkg", "-p", "st4gem"

    iraf_extern = lib/"iraf/extern"
    (iraf_extern/"st4gem").install Dir["*"]
  end

  test do
    (testpath/"version.cl").write <<~EOF
      st4gem
      =version
      logout
    EOF
    assert_match "V1.2.1", shell_output("#{HOMEBREW_PREFIX}/bin/irafcl -f version.cl")
  end
end

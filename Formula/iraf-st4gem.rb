class IrafSt4gem < Formula
  desc "IRAF external package for tabular spectra"
  homepage "https://github.com/iraf-community/iraf-st4gem"
  url "https://gitlab.com/nsf-noirlab/csdc/usngo/iraf/st4gem/-/archive/20251102/st4gem-20251102.tar.gz"
  sha256 "e413f61ba85fe7e1319e6874ddee3c891da1bd5f5c5c8a2898e87a36ced790e3"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-st4gem-20251102"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "e15219c43deb281ff5bbde6d4e03b03cdc89f2ef5d5063faf4ce7a0e6213780e"
    sha256 cellar: :any_skip_relocation, sequoia:     "f7679cbc575b1283e5cce614373b16d6d85847b29f5ebad8cd82c80af5454122"
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

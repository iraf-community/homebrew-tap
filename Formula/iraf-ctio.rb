class IrafCtio < Formula
  desc "Tools for the Cerro Tololo Inter-American Observatory"
  homepage "https://github.com/iraf-community/iraf-ctio"
  url "https://github.com/iraf-community/iraf-ctio.git", revision: "a6113fe"
  version "202.11.12"
  sha256 "987dbc80e2df98624b192a03d7829f717f51aa70580ea7a8ed3ef24f09aa2708"

  bottle do
    root_url "https://github.com/iraf-community/homebrew-tap/releases/download/iraf-ctio-202.11.12"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4e1fdd98549f717ead3bd7ae25e33e06b21696eafd9983c18af6fb8841e07c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24a8e7a4471cea607ed47b596e77b66ddbb63e54fc22fc40636395dd2c11cbff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a7d4ee76f88c6ec75df07de2eb2607fa65b294add7ee122fd51d75a7edd6b05"
    sha256 cellar: :any_skip_relocation, sequoia:       "02804f6c91ecaf7bf50b6a1c7efcc74c0530246f2d06db7607c0333f4faa8ca1"
  end

  IRAF_PACKAGE = "ctio".freeze

  depends_on "iraf"

  def install
    rm "bin"
    mkdir_p "bin"
    ENV[IRAF_PACKAGE] = "#{buildpath}/"
    system "mkpkg", "-p", IRAF_PACKAGE
    system "irafcl", "-c", "softools; mkhelpdb helpdir=lib$root.hd helpdb=lib$helpdb.mip"

    iraf_extern = lib/"iraf/extern"
    (iraf_extern/IRAF_PACKAGE).install Dir["*"]
  end

  test do
    # Extract the version string of the package directly from the .par
    # file and check whether it can be reproduced from the
    # corresponding IRAF variable.
    ref = shell_output("grep ^version, #{lib}/iraf/extern/#{IRAF_PACKAGE}/#{IRAF_PACKAGE}.par  | cut -d\\\" -f2")
    ver = shell_output("irafcl -c #{IRAF_PACKAGE} -c =version")
    puts "'#{ref}' == '#{ver}'?"
    assert_match ref, ver
  end
end

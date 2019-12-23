{ stdenv, fetchurl, makeWrapper, jre, ncurses }:

stdenv.mkDerivation rec {
  version = "0.20.0";
  pname = "dotty-bare";

  src = fetchurl {
    url = "https://github.com/lampepfl/dotty/releases/download/${version}/dotty-${version}.tar.gz";
    sha256 = "8ad901acdbe76262f4b264b98b88d71f5c6e659b2923086b6a6d41ce1d09d43c";
  };

  propagatedBuildInputs = [ jre ncurses.dev ] ;
  buildInputs = [ makeWrapper ] ;

  installPhase = ''
    mkdir -p $out
    mv * $out
  '';

  fixupPhase = ''
        bin_files=$(find $out/bin -type f ! -name common)
        for f in $bin_files ; do
          wrapProgram $f --set JAVA_HOME ${jre} --prefix PATH : '${ncurses.dev}/bin'
        done
  '';

  meta = with stdenv.lib; {
    description = "Research platform for new language concepts and compiler technologies for Scala.";
    longDescription = ''
       Dotty is a platform to try out new language concepts and compiler technologies for Scala.
       The focus is mainly on simplification. We remove extraneous syntax (e.g. no XML literals),
       and try to boil down Scala’s types into a smaller set of more fundamental constructs.
       The theory behind these constructs is researched in DOT, a calculus for dependent object types.
    '';
    homepage = http://dotty.epfl.ch/;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = [maintainers.karolchmist maintainers.virusdave];
  };
}

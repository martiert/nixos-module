{ lib, buildGoModule, fetchFromGitHub, ... }:

buildGoModule rec {
  name = "threagile";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "Threagile";
    repo = "${name}";
    rev = "9c1d403638a1f7d83faa4c528531c6c5025885c8";
    hash = "sha256-V/ya4l4Mkw+za+kWOkLPbntv65AnrrYhyAOvyk4TGho=";
  };

  vendorHash = "sha256-VNy9izeFO0xqPUswWcto462SGAqeFHou417/Ef+JKPs=";

  preBuild = ''
    find . -name main.go
  '';

  subPackages = [ "cmd/threagile" ];
}

{ vimUtils, fetchFromGitHub, lib, ... }:

vimUtils.buildVimPlugin {
  name = "copilot.lua";
  src = fetchFromGitHub {
    owner = "zbirenbaum";
    repo = "copilot.lua";
    rev = "f8d8d872bb319f640d5177dad5fbf01f7a16d7d0";
    hash = "sha256-UY6N2Q+egh+Cn4REZXrSGH9ElWQBedl0n8tWJvGe7vs=";
  };
}

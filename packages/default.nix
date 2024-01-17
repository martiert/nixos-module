{ pkgs, ... }:

{
  generate_ssh_key = pkgs.callPackage ./generate_ssh_key {};
}

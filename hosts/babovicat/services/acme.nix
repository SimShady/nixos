{ config, lib, pkgs, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "cert+simon@babovic.at";
  };
}

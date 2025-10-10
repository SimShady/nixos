{ config, lib, pkgs, ... }:
{
  services.roundcube = {
    enable = true;
    maxAttachmentSize = 100;
    hostName = "webmail.babovic.at";
    extraConfig = ''
      $config['imap_host'] = 'ssl://imap.migadu.com';
      $config['smtp_host'] = 'tls://smtp.migadu.com';
      $config['smtp_user'] = '%u';
      $config['smtp_pass'] = '%p';
      $rcmail_config['product_name'] = 'babovic.at Webmail';
    '';
  };
}
{ pkgs, ... }:
{
  services.xserver.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      disableWhileTyping = true;
      clickMethod = "buttonareas";
      scrollMethod = "twofinger";
      accelProfile = "adaptive";
    };
  };

  environment.systemPackages = with pkgs; [
    libinput
  ];

  #services.xserver.synaptics = {
  #  enable = true;
  #  vertTwoFingerScroll = true;
  #};
}

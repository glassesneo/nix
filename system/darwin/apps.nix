{ pkgs, ... }:
{

  ##########################################################################
  # 
  #  Install all apps and packages here.
  #
  #  NOTE: Your can find all available options in:
  #    https://daiderd.com/nix-darwin/manual/index.html
  # 
  # TODO Fell free to modify this file to fit your needs.
  #
  ##########################################################################

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [ ];

  # services.yabai = {
  #   enable = true;
  #   config = {
  #     focus_follows_mouse = "on";
  #     mouse_follows_focus = "autoraise";
  #     window_origin_display = "default";
  #     window_placement = "second_child";
  #     window_topmost = "on";
  #     window_shadow = "off";
  #     window_opacity = "off";
  #     window_opacity_duration = 0.0;
  #     active_window_opacity = 1.0;
  #     normal_window_opacity = 0.9;
  #     window_border = "off";
  #     window_border_width = 6;
  #     active_window_border_color = "0xff775759";
  #     normal_window_border_color = "off";
  #     split_ratio = 0.5;
  #     auto_balance = "off";
  #     layout = "bsp";
  #     window_gap = 2.5;
  #   };
  #   extraConfig = ''
  #     yabai -m rule --add app='^System Settings$' manage=off
  #     yabai -m rule --add app='^Dictionary$' manage=off
  #     yabai -m rule --add app='^Proton Pass$' manage=off
  #     yabai -m rule --add app='^BetterTouchTool$' manage=off
  #     yabai -m rule --add app='^Raycast$' title='Raycast Settings' manage=off
  #     yabai -m rule --add app='^Discord$' title='Discord Updater' manage=off
  #   '';
  # };
  #
  # services.skhd = {
  #   enable = true;
  #   skhdConfig = ''
  #     # focus window
  #     alt - x : yabai -m window --focus recent
  #     alt - h : yabai -m window --focus west || yabai -m space --focus west
  #     alt - j : yabai -m window --focus south || yabai -m space --focus south
  #     alt - k : yabai -m window --focus north || yabai -m space --focus north
  #     alt - l : yabai -m window --focus east || yabai -m space --focus east
  #
  #     # swap window
  #     shift + alt - x : yabai -m window --swap recent
  #     shift + alt - h : yabai -m window --swap west
  #     shift + alt - j : yabai -m window --swap south
  #     shift + alt - k : yabai -m window --swap north
  #     shift + alt - l : yabai -m window --swap east
  #
  #     # move window
  #     shift + cmd - h : yabai -m window --warp west
  #     shift + cmd - j : yabai -m window --warp south
  #     shift + cmd - k : yabai -m window --warp north
  #     shift + cmd - l : yabai -m window --warp east
  #
  #     # move window between displays
  #     alt - left: yabai -m window --space prev --focus
  #     alt - right: yabai -m window --space next --focus || (yabai -m space --create && yabai -m window --space last --focus)
  #
  #     # change window size
  #     shift + alt - a : yabai -m window --resize left:-20:0 || yabai -m window --resize right:-20:0
  #     shift + alt - s : yabai -m window --resize bottom:0:20 || yabai -m window --resize top:0:20
  #     shift + alt - w : yabai -m window --resize top:0:-20 || yabai -m window --resize bottom:0:-20
  #     shift + alt - d : yabai -m window --resize right:20:0 || yabai -m window --resize left:20:0
  #
  #     # balance
  #     alt - b : yabai -m space --balance
  #
  #     # rotate tree
  #     alt - r : yabai -m space --rotate 90
  #
  #     # mirror tree y-axis
  #     alt - y : yabai -m space --mirror y-axis
  #
  #     # mirror tree x-axis
  #     alt - x : yabai -m space --mirror x-axis
  #
  #     # toggle window fullscreen zoom
  #     alt - f : yabai -m window --toggle zoom-fullscreen
  #
  #     # toggle window native fullscreen
  #     shift + alt - f : yabai -m window --toggle native-fullscreen
  #
  #     # toggle window split type
  #     alt - e : yabai -m window --toggle split
  #
  #     # float / unfloat window and restore position
  #     # alt - t : yabai -m window --toggle float && /tmp/yabai-restore/$(yabai -m query --windows --window | jq -re '.id').restore 2>/dev/null || true
  #     alt - t : yabai -m window --toggle float && yabai -m window --grid 4:4:1:1:2:2
  #
  #     # restart skhd
  #     shift + alt - r : skhd --restart-service
  #
  #     # Close app
  #     alt - q : yabai -m window --close
  #   '';
  # };

  # services.sketchybar = {
  #   enable = true;
  #   config = ''
  #     #!/Users/neo/.nix-profile/bin/lua

  #     sketchybar.add_item("hello", {
  #       position = "center",
  #       label = { text = "Hello, World!" }
  #     })

  #     sketchybar.update()
  #   '';
  #   extraPackages = [
  #     pkgs.lua5_4
  #     pkgs.jq
  #   ];
  # };

  # launchd.user.agents.sketchybar = {
  #   serviceConfig = {
  #     StandardOutPath = "/tmp/sketchybar.log";
  #     StandardErrorPath = "/tmp/sketchybar.log";
  #   };
  # };

  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      # 'zap': uninstalls all formulae(and related files) not listed here.
      cleanup = "zap";
    };

    taps = [ "homebrew/services" ];

    # `brew install`
    brews = [
      "mas"
      "emscripten"
    ];

    # `brew install --cask`
    casks = [
      # "amazon-q"
      "arc"
      "canva"
      "chatgpt"
      "discord"
      "hot"
      "karabiner-elements"
      "keycastr"
      "kitty"
      "monitorcontrol"
      "notion"
      "one-switch"
      "proton-drive"
      "proton-pass"
      "raycast"
      "slack"
      "warp"
      "wave"
      "zoom"
    ];

    masApps = {
      XCode = 497799835;
      LINE = 539883307;
      RunCat = 1429033973;
      # Perplexity = 6714467650;
    };
  };
}

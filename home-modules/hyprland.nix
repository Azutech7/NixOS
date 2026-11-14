{ inputs, config, lib, pkgs, ... }: {

	  imports = [
        inputs.hyprland.homeModules.default
    ];

	options.modules.hyprland.enable = lib.mkEnableOption "hyprland";

	config = lib.mkIf config.modules.hyprland.enable (

		let
		  terminal = "${pkgs.kitty}/bin/kitty";
		  menu = "${pkgs.fuzzel}/bin/fuzzel";
		  c = config.modules.theme.color;
		
		  lua = lib.generators.mkLuaInline;
		
		  dsp = {
		    exec = cmd: lua ''hl.dsp.exec_cmd("${cmd}")'';
		    close = lua "hl.dsp.window.close()";
		    exit = lua "hl.dsp.exit()";
		    float = lua ''hl.dsp.window.float({ action = "toggle" })'';
		    fullscreen = lua "hl.dsp.window.fullscreen()";
		    pseudo = lua "hl.dsp.window.pseudo()";
		    layout = msg: lua ''hl.dsp.layout("${msg}")'';
		    focus = dir: lua ''hl.dsp.focus({ direction = "${dir}" })'';
		    swap = dir: lua ''hl.dsp.window.swap({ direction = "${dir}" })'';
		    toggleSpecial = name: lua ''hl.dsp.workspace.toggle_special("${name}")'';
		    moveToSpecial = name: lua ''hl.dsp.window.move({ workspace = "special:${name}" })'';
		    focusWorkspace = ws: lua ''hl.dsp.focus({ workspace = "${toString ws}" })'';
		    moveToWorkspace = ws: lua ''hl.dsp.window.move({ workspace = "${toString ws}" })'';
		    drag = lua "hl.dsp.window.drag()";
		    resize = lua "hl.dsp.window.resize()";
		    sendshortcut = mod: key: lua ''hl.dsp.send_shortcut({ mods = "${mod}", key = "${key}" })'';
		  };
		
		  bind = keys: dispatcher: { _args = [keys dispatcher]; };
		  bindOpts = keys: dispatcher: opts: { _args = [keys dispatcher opts]; };
		
		  workspaceBinds = lib.concatMap (i:
		    let key = toString (lib.mod i 10);
		    in [
		      (bind "SUPER + ${key}" (dsp.focusWorkspace i))
		      (bind "SUPER + SHIFT + ${key}" (dsp.moveToWorkspace i))
		    ]
		  ) (lib.range 1 10);
		in
		{
		  wayland.windowManager.hyprland = {
		    enable = true;
		    configType = "lua";
		    xwayland.enable = true;
		
		    package = null;
		    portalPackage = null;
		
		    settings = {
		      mainMod = { _var = "SUPER"; };
		      terminal = { _var = terminal; };
		      menu = { _var = menu; };
		
		      colPrimary = { _var = "0xff${c.primary}"; };
		      colBackground = { _var = "0xff${c.background}"; };
		
		      config = {
		        general = {
		          gaps_in = 5;
		          gaps_out = 10;
		          border_size = 2;
		          "col.active_border" = lua "colPrimary";
		          "col.inactive_border" = lua "colPrimary";
		          resize_on_border = false;
		          allow_tearing = false;
		          layout = "dwindle";
		        };
		
		        decoration = {
		          active_opacity = 1.0;
		          inactive_opacity = 1.0;
		          fullscreen_opacity = 1.0;
		          rounding = 10;
		          rounding_power = 2;
		
		          shadow = {
		            enabled = false;
		            range = 4;
		            render_power = 3;
		            color = lua "colBackground";
		          };
		
		          blur = {
		            enabled = true;
		            size = 5;
		            passes = 2;
		            vibrancy = 0.1696;
		            noise = 0.0117;
		            new_optimizations = true;
		            ignore_opacity = true;
		          };
		        };
		
		        animations = {
		          enabled = true;
		          bezier = [
		            "easeOutQuint, 0.23, 1, 0.32, 1"
		            "easeInOutCubic, 0.65, 0.05, 0.36, 1"
		            "linear, 0, 0, 1, 1"
		            "almostLinear, 0.5, 0.5, 0.75, 1"
		            "quick, 0.15, 0, 0.1, 1"
		          ];
		          animation = [
		            "global, 1, 10, default"
		            "border, 1, 5.39, easeOutQuint"
		            "windows, 1, 4.79, easeOutQuint"
		            "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
		            "windowsOut, 1, 1.49, linear, popin 87%"
		            "fadeIn, 1, 1.73, almostLinear"
		            "fadeOut, 1, 1.46, almostLinear"
		            "fade, 1, 3.03, quick"
		            "layers, 1, 3.81, easeOutQuint"
		            "layersIn, 1, 4, easeOutQuint, fade"
		            "layersOut, 1, 1.5, linear, fade"
		            "fadeLayersIn, 1, 1.79, almostLinear"
		            "fadeLayersOut, 1, 1.39, almostLinear"
		            "workspaces, 1, 1.94, almostLinear, fade"
		            "workspacesIn, 1, 1.21, almostLinear, fade"
		            "workspacesOut, 1, 1.94, almostLinear, fade"
		            "zoomFactor, 1, 7, quick"
		          ];
		        };
		
		        dwindle = {
		          preserve_split = true;
		        };
		
		        master = {
		          new_status = "master";
		        };
		
		        misc = {
		          force_default_wallpaper = 0;
		          disable_hyprland_logo = true;
		        };
		
		        input = {
		          kb_layout = "us";
		          follow_mouse = 1;
		          mouse_refocus = false;
		          sensitivity = 0;
		          force_no_accel = 1;
		
		          touchpad = {
		            natural_scroll = false;
		          };
		        };
		
		        cursor = {
		          no_hardware_cursors = true;
		          enable_hyprcursor = false;
		        };
		
		        device = [
		          {
		            name = "epic-mouse-v1";
		            sensitivity = -0.5;
		          }
		        ];
		
		        monitor = lua ''
		                  (function()
		                    return {
		                      "DP-3, 1920x1080@144, 0x0, 1",
		                      "DP-2, 1920x1080@144, 1920x0, 1"
		                    }
		                  end)()
		                '';
		
		        xwayland = {
		          force_zero_scaling = true;
		        };
		      };
		
		      bind = [
		        (bind "SUPER + C" (dsp.exec terminal))
		        (bind "SUPER + Q" dsp.close)
		        (bind "SUPER + M" dsp.exit)
		        (bind "SUPER + V" dsp.float)
		        (bind "SUPER + R" (dsp.exec menu))
		        (bind "SUPER + F" dsp.fullscreen)
		
		        # Focus directions
		        (bind "SUPER + left" (dsp.focus "l"))
		        (bind "SUPER + right" (dsp.focus "r"))
		        (bind "SUPER + up" (dsp.focus "u"))
		        (bind "SUPER + down" (dsp.focus "d"))
		
		        # Special workspace
		        (bind "SUPER + S" (dsp.toggleSpecial "magic"))
		        (bind "SUPER + SHIFT + S" (dsp.moveToSpecial "magic"))
		
		        # Mouse scroll workspaces
		        (bind "SUPER + mouse_down" (dsp.focusWorkspace "e+1"))
		        (bind "SUPER + mouse_up" (dsp.focusWorkspace "e-1"))
		
		        # Extra utils & clipboard
		        (bind "CTRL + SHIFT + C" (dsp.exec "wl-paste --primary | wl-copy"))
		        (bind "CTRL + SHIFT + V" (dsp.exec "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"))
		        (bind "SUPER + P" (dsp.exec "hyprshot -m region"))
		
		        # Audio / Media function keys
		        (bindOpts "SUPER + F3" (dsp.exec "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+") { repeating = true; locked = true; })
		        (bindOpts "SUPER + F2" (dsp.exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-") { repeating = true; locked = true; })
		        (bindOpts "SUPER + F1" (dsp.exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") { locked = true; })
		        (bindOpts "SUPER + F4" (dsp.exec "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle") { locked = true; })
		        (bindOpts "SUPER + F6" (dsp.exec "brightnessctl -e4 -n2 set +5%") { repeating = true; locked = true; })
		        (bindOpts "SUPER + F5" (dsp.exec "brightnessctl -n2 set 5%-") { repeating = true; locked = true; })
		        (bindOpts "SUPER + F8" (dsp.exec "playerctl next") { locked = true; })
		        (bindOpts "SUPER + F10" (dsp.exec "playerctl play-pause") { locked = true; })
		        (bindOpts "SUPER + F9" (dsp.exec "playerctl play-pause") { locked = true; })
		        (bindOpts "SUPER + F7" (dsp.exec "playerctl previous") { locked = true; })
		
		        # Mouse window management bindings (bindm equivalents)
		        (bindOpts "SUPER + mouse:272" dsp.drag { mouse = true; })
		        (bindOpts "SUPER + mouse:273" dsp.resize { mouse = true; })
		      ] ++ workspaceBinds;
		
		      on = {
		        _args = [
		          "hyprland.start"
		          (lua ''
		            function()
		              hl.exec_cmd("hyprpaper")
		              hl.exec_cmd("hypridle")
		              hl.exec_cmd("waybar")
		              hl.exec_cmd("cliphist wipe")
		              hl.exec_cmd("wl-paste --type text --watch cliphist store")
		              hl.exec_cmd("wl-paste --type image --watch cliphist store")
		            end
		          '')
		        ];
		      };
		    };
		  };
		}
				
	);
}

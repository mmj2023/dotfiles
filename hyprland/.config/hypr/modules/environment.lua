-- # env = QT_QPA_PLATFORM,wayland
hl.env("ELECTRON_OZONE_PLATFORM_HINT","auto")
hl.env("TERMINAL","ghostty")
-- # See https://wiki.hyprland.org/Configuring/Environment-variables/
hl.env("HYPRCURSOR_THEME","cz-Hickson-black")
hl.env("XCURSOR_THEME","cz-Hickson-black")
hl.env("XCURSOR_SIZE","24")
hl.env("HYPRCURSOR_SIZE","24")
-- # https://wiki.hyprland.org/Configuring/Environment-variables/
hl.env("__GLX_VENDOR_LIBRARY_NAME","nvidia")
hl.env("LIBVA_DRIVER_NAME","nvidia")
hl.env("GBM_BACKEND","nvidia-drm")
hl.env("WLR_NO_HARDWARE_CURSORS","1")
hl.env("WLR_DRM_NO_ATOMIC","1")
hl.env("AQ_NO_HARDWARE_CURSORS","1")
-- # env = AQ_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1
hl.env("AQ_DRM_NO_ATOMIC","1")
hl.env("__GL_VRR_ALLOWED","1")
hl.env("NVD_BACKEND","direct")
-- # env = WLR_DRM_DEVICES,/dev/dri/card0
-- # env = AQ_DRM_DEVICES,/dev/dri/card1
-- # https://wiki.hyprland.org/hyprland-wiki/pages/Nvidia/

-- # XDG Specifications
hl.env("XDG_CURRENT_DESKTOP","Hyprland")
hl.env("XDG_SESSION_TYPE","wayland")
hl.env("XDG_SESSION_DESKTOP","Hyprland")

-- # Toolkit Backend
hl.env("GDK_BACKEND","wayland,x11")
hl.env("GDK_SCALE","1.25")
-- # env = GDK_DPI_SCALE,1.25
hl.env("SDL_VIDEODRIVER","wayland")
hl.env("CLUTTER_BACKEND","wayland")
-- # Qt
hl.env("QT_QPA_PLATFORM","wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME","qt6ct")
hl.env("QT_QPA_PLATFORMTHEME_QT6","qt6ct")
hl.env("QT_QPA_PLATFORMTHEME_QT5","qt6ct")
-- # env = QT_AUTO_SCREEN_SCALE_FACTOR,0
-- # env = QT_SCALE_FACTOR,1.25
-- # env = QT_QPA_PLATFORMTHEME,hyprqt6engine
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION","1")
-- # FF
hl.env("MOZ_ENABLE_WAYLAND","1")

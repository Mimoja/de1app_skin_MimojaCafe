
add_background "iconik_settings"
add_de1_text "iconik_settings" 1370 60 -text "Restart the app via system settings after making changes" -anchor w -justify center -font $::font_small -fill [::theme background_text]
add_de1_text "iconik_settings" 2550 1580 -text "$::version_string" -anchor "e" -justify center -font $::font_tiniest -fill [::theme background_text]
add_de1_variable "iconik_settings" 1370 1580 -justify center -anchor "w" -text "" -font $::font_tiniest  -fill  [::theme background_text]  -width [rescale_x_skin 520] -textvariable {Screensaver folder: $::iconik_settings(saver_dir)}


add_de1_text  "iconik_settings" 100 80 -text "General Settings:" -anchor w -justify center -font $::font_small_header -fill [::theme background_text]
add_de1_widget "iconik_settings" checkbutton 100 120 {} -text [translate "Reset to Primary Profile after shot"] -indicatoron true  -font $::font_tiny -bg [::theme background] -anchor nw -foreground [::theme background_text] -variable ::iconik_settings(reset_to_main_profile)  -borderwidth 0 -selectcolor [::theme background] -highlightthickness 0 -activebackground [::theme background]  -bd 0 -activeforeground [::theme background_text] -relief flat -bd 0
add_de1_widget "iconik_settings" checkbutton 100 180 {} -text [translate "Show water level indicator"] -indicatoron true  -font $::font_tiny -bg [::theme background] -anchor nw -foreground [::theme background_text] -variable ::iconik_settings(show_water_level_indicator)  -borderwidth 0 -selectcolor [::theme background] -highlightthickness 0 -activebackground [::theme background]  -bd 0 -activeforeground [::theme background_text] -relief flat -bd 0
add_de1_widget "iconik_settings" checkbutton 100 240 {} -text [translate "Show remaining water in mL instead of water level"] -indicatoron true  -font $::font_tiny -bg [::theme background] -anchor nw -foreground [::theme background_text] -variable ::iconik_settings(show_ml_instead_of_water_level)  -borderwidth 0 -selectcolor [::theme background] -highlightthickness 0 -activebackground [::theme background]  -bd 0 -activeforeground [::theme background_text] -relief flat -bd 0
add_de1_widget "iconik_settings" checkbutton 100 300 {} -text [translate "Show graph grid lines"] -indicatoron true  -font $::font_tiny -bg [::theme background] -anchor nw -foreground [::theme background_text] -variable ::iconik_settings(show_grid_lines)  -borderwidth 0 -selectcolor [::theme background] -highlightthickness 0 -activebackground [::theme background]  -bd 0 -activeforeground [::theme background_text] -relief flat -bd 0

add_de1_widget "iconik_settings" checkbutton 100 360 {} -text [translate "Have seperate flow axis"] -indicatoron true  -font $::font_tiny -bg [::theme background] -anchor nw -foreground [::theme background_text] -variable ::iconik_settings(seperate_flow_axis)  -borderwidth 0 -selectcolor [::theme background] -highlightthickness 0 -activebackground [::theme background]  -bd 0 -activeforeground [::theme background_text] -relief flat -bd 0

add_de1_widget "iconik_settings" checkbutton 100 420 {} -text [translate "Show steam preset buttons"] -indicatoron true  -font $::font_tiny -bg [::theme background] -anchor nw -foreground [::theme background_text] -variable ::iconik_settings(steam_presets_enabled)  -borderwidth 0 -selectcolor [::theme background] -highlightthickness 0 -activebackground [::theme background]  -bd 0 -activeforeground [::theme background_text] -relief flat -bd 0
add_de1_widget "iconik_settings" checkbutton 100 480 {} -text [translate "Show steam graph"] -indicatoron true  -font $::font_tiny -bg [::theme background] -anchor nw -foreground [::theme background_text] -variable ::iconik_settings(show_steam)  -borderwidth 0 -selectcolor [::theme background] -highlightthickness 0 -activebackground [::theme background]  -bd 0 -activeforeground [::theme background_text] -relief flat -bd 0
add_de1_widget "iconik_settings" checkbutton 150 540 {} -text [translate "Show steam graph grid lines"] -indicatoron true  -font $::font_tiny -bg [::theme background] -anchor nw -foreground [::theme background_text] -variable ::iconik_settings(show_steam_grid_lines)  -borderwidth 0 -selectcolor [::theme background] -highlightthickness 0 -activebackground [::theme background]  -bd 0 -activeforeground [::theme background_text] -relief flat -bd 0
add_de1_widget "iconik_settings" checkbutton 100 600 {} -text [translate "Replace steam & hotwater with dose & grind settings"] -indicatoron true  -font $::font_tiny -bg [::theme background] -anchor nw -foreground [::theme background_text] -variable ::iconik_settings(show_grinder_settings_on_main_page)  -borderwidth 0 -selectcolor [::theme background] -highlightthickness 0 -activebackground [::theme background]  -bd 0 -activeforeground [::theme background_text] -relief flat -bd 0
add_de1_widget "iconik_settings" checkbutton 150 660 {} -text [translate "Show clock instead of grind setting"] -indicatoron true  -font $::font_tiny -bg [::theme background] -anchor nw -foreground [::theme background_text] -variable ::iconik_settings(show_clock_on_main_page)  -borderwidth 0 -selectcolor [::theme background] -highlightthickness 0 -activebackground [::theme background]  -bd 0 -activeforeground [::theme background_text] -relief flat -bd 0
add_de1_widget "iconik_settings" checkbutton 100 720 {} -text [translate "Always show temperatures"] -indicatoron true  -font $::font_tiny -bg [::theme background] -anchor nw -foreground [::theme background_text] -variable ::iconik_settings(always_show_temperatures)  -borderwidth 0 -selectcolor [::theme background] -highlightthickness 0 -activebackground [::theme background]  -bd 0 -activeforeground [::theme background_text] -relief flat -bd 0
add_de1_widget "iconik_settings" checkbutton 100 780 {} -text [translate "Show Puck Resistance"] -indicatoron true  -font $::font_tiny -bg [::theme background] -anchor nw -foreground [::theme background_text] -variable ::iconik_settings(show_resistance)  -borderwidth 0 -selectcolor [::theme background] -highlightthickness 0 -activebackground [::theme background]  -bd 0 -activeforeground [::theme background_text] -relief flat -bd 0

add_de1_text  "iconik_settings" 100 880 -text "Scale Settings:" -anchor w -justify center -font $::font_small_header -fill [::theme background_text]
add_de1_widget "iconik_settings" checkbutton 100 920 {} -text [translate "Only tare when pouring (useful for weighing beans)"] -indicatoron true  -font $::font_tiny -bg [::theme background] -anchor nw -foreground [::theme background_text] -variable ::settings(tare_only_on_espresso_start)  -borderwidth 0 -selectcolor [::theme background] -highlightthickness 0 -activebackground [::theme background]  -bd 0 -activeforeground [::theme background_text] -relief flat -bd 0
add_de1_widget "iconik_settings" checkbutton 100 980 {} -text [translate "Reconnect to the scale on espresso start"] -indicatoron true  -font $::font_tiny -bg [::theme background] -anchor nw -foreground [::theme background_text] -variable ::settings(reconnect_to_scale_on_espresso_start)  -borderwidth 0 -selectcolor [::theme background] -highlightthickness 0 -activebackground [::theme background]  -bd 0 -activeforeground [::theme background_text] -relief flat -bd 0
add_de1_widget "iconik_settings" checkbutton 100 1040 {} -text [translate "Double the scale input / spouted portafilter scale mode"] -indicatoron true  -font $::font_tiny -bg [::theme background] -anchor nw -foreground [::theme background_text] -variable ::settings(scale_stop_at_half_shot)  -borderwidth 0 -selectcolor [::theme background] -highlightthickness 0 -activebackground [::theme background]  -bd 0 -activeforeground [::theme background_text] -relief flat -bd 0

add_de1_text  "iconik_settings" 100 1140 -text "Clean Settings:" -anchor w -justify center -font $::font_small_header -fill [::theme background_text]
add_de1_widget "iconik_settings" checkbutton 100 1180 {} -text [translate "Use profile for cleanup button"] -indicatoron true  -font $::font_tiny -bg [::theme background] -anchor nw -foreground [::theme background_text] -variable ::iconik_settings(cleanup_use_profile)  -borderwidth 0 -selectcolor [::theme background] -highlightthickness 0 -activebackground [::theme background]  -bd 0 -activeforeground [::theme background_text] -relief flat -bd 0
add_de1_widget "iconik_settings" checkbutton 100 1240 {} -text [translate "Restore selected profile after cleanup"] -indicatoron true  -font $::font_tiny -bg [::theme background] -anchor nw -foreground [::theme background_text] -variable ::iconik_settings(cleanup_restore_selected_profile)  -borderwidth 0 -selectcolor [::theme background] -highlightthickness 0 -activebackground [::theme background]  -bd 0 -activeforeground [::theme background_text] -relief flat -bd 0
add_de1_widget "iconik_settings" checkbutton 100 1300 {} -text [translate "Bypass shot history for cleanup profile"] -indicatoron true  -font $::font_tiny -bg [::theme background] -anchor nw -foreground [::theme background_text] -variable ::iconik_settings(cleanup_bypass_shot_history)  -borderwidth 0 -selectcolor [::theme background] -highlightthickness 0 -activebackground [::theme background]  -bd 0 -activeforeground [::theme background_text] -relief flat -bd 0

add_de1_text  "iconik_settings" 100 1400 -text "Misc:" -anchor w -justify center -font $::font_small_header -fill [::theme background_text]
add_de1_widget "iconik_settings" checkbutton 200 1380 {} -text [translate "EXPERIMENTAL: Create profile backups"] -indicatoron true  -font $::font_tiny -bg [::theme background] -anchor nw -foreground [::theme background_text] -variable ::iconik_settings(create_profile_backups)  -borderwidth 0 -selectcolor [::theme background] -highlightthickness 0 -activebackground [::theme background]  -bd 0 -activeforeground [::theme background_text] -relief flat -bd 0

# Preset buttons
add_de1_text  "iconik_settings" 1370 900 -text "Presets:" -anchor w -justify center -font $::font_small_header -fill [::theme background_text]

## Dose / Grind settings
create_settings_button "iconik_settings" 1370 940 1700 1090 $::font_tinier [::theme button_secondary] [::theme button_text_light] { set ::settings(grinder_dose_weight) [round_one_digits [expr {$::settings(grinder_dose_weight) - 0.5}]]; profile_has_changed_set; save_profile; save_settings_to_de1; save_settings} { set ::settings(grinder_dose_weight) [round_one_digits [expr {$::settings(grinder_dose_weight) + 0.5}]]; profile_has_changed_set; save_profile; save_settings_to_de1; save_settings} {Dose:\n $::settings(grinder_dose_weight)g ([iconik_get_ratio_text])}
create_settings_button "iconik_settings" 1760 940 2090 1090 $::font_tinier [::theme button_secondary] [::theme button_text_light] { set ::settings(grinder_setting) [round_to_one_digits [expr {$::settings(grinder_setting) - 0.1}]]; profile_has_changed_set; save_profile; save_settings_to_de1; save_settings} { set ::settings(grinder_setting) [round_to_one_digits [expr {$::settings(grinder_setting) + 0.1}]]; profile_has_changed_set; save_profile; save_settings_to_de1; save_settings} {Grind Setting:\n $::settings(grinder_setting)}

## Cup settings
create_settings_button "iconik_settings" 1370 1150 1700 1300 $::font_tinier [::theme button_secondary] [::theme button_text_light] { set ::iconik_settings(small_mug_setting) [round_to_integer [expr {$::iconik_settings(small_mug_setting) - 1}]]; save_settings} { set ::iconik_settings(small_mug_setting) [round_to_integer [expr {$::iconik_settings(small_mug_setting) + 1}]]; save_settings} {Small Cup:\n $::iconik_settings(small_mug_setting)g}
create_settings_button "iconik_settings" 1760 1150 2090 1300 $::font_tinier [::theme button_secondary] [::theme button_text_light] { set ::iconik_settings(large_mug_setting) [round_to_integer [expr {$::iconik_settings(large_mug_setting) - 1}]]; save_settings} { set ::iconik_settings(large_mug_setting) [round_to_integer [expr {$::iconik_settings(large_mug_setting) + 1}]]; save_settings} {Large Cup:\n $::iconik_settings(large_mug_setting)g}

## Water / Steam settings
create_settings_button "iconik_settings" 1370 1360 1700 1510 $::font_tinier [::theme button_secondary] [::theme button_text_light]  {  set ::iconik_settings(water_temperature_overwride) [round_one_digits [expr {$::iconik_settings(water_temperature_overwride) - 5}]]; iconik_save_water_temperature} {  set ::iconik_settings(water_temperature_overwride) [round_one_digits [expr {$::iconik_settings(water_temperature_overwride) + 5}]];iconik_save_water_temperature} {Water Temp:\n [iconik_water_temperature]}
create_settings_button "iconik_settings" 1760 1360 2090 1510 $::font_tinier [::theme button_secondary] [::theme button_text_light] {set ::settings(water_volume) [expr {$::settings(water_volume) - 5}]; de1_send_steam_hotwater_settings; save_settings} {  set ::settings(water_volume) [expr {$::settings(water_volume) + 5}]; de1_send_steam_hotwater_settings; save_settings} {Water Vol:\n [round_to_integer $::settings(water_volume)]ml}
create_settings_button "iconik_settings" 2150 1360 2480 1510 $::font_tinier [::theme button_secondary] [::theme button_text_light] {iconic_steam_tap down} {iconic_steam_tap up} {Steam $::iconik_settings(steam_active_slot):\n[iconik_get_steam_time]}

# Skin Theme buttons
add_de1_text  "iconik_settings" 1370 420 -text "Skin Theme:" -anchor w -justify center -font $::font_small_header -fill [::theme background_text]
create_button "iconik_settings" 1370 460 1570 610 $::font_tiny $::default_theme(button) $::default_theme(button_text_light) {set ::iconik_settings(theme) "::default_theme"; iconik_save_settings; borg toast "Theme changed, please restart"}  "Default" 
create_button "iconik_settings" 1630 460 1830 610 $::font_tiny $::dark_theme(button)    $::dark_theme(button_text_light)    {set ::iconik_settings(theme) "::dark_theme";    iconik_save_settings; borg toast "Theme changed, please restart"} "Dark" 
create_button "iconik_settings" 1890 460 2090 610 $::font_tiny $::cocoa_theme(button)   $::cocoa_theme(button_text_light)   {set ::iconik_settings(theme) "::cocoa_theme";   iconik_save_settings; borg toast "Theme changed, please restart"}  "Cocoa"

create_button "iconik_settings" 1370 670 1570 820 $::font_tiny $::purple_theme(button)     $::purple_theme(button_text_light)  {set ::iconik_settings(theme) "::purple_theme";  iconik_save_settings; borg toast "Theme changed, please restart"} "Purple" 
create_button "iconik_settings" 1630 670 1830 820 $::font_tiny $::red_theme(button)        $::red_theme(button_text_light)     {set ::iconik_settings(theme) "::red_theme";     iconik_save_settings; borg toast "Theme changed, please restart"} "Red"  
create_button "iconik_settings" 1890 670 2090 820 $::font_tiny $::rainforest_theme(button) $::rainforest_theme(button_text_light)     {set ::iconik_settings(theme) "::rainforest_theme";     iconik_save_settings; borg toast "Theme changed, please restart"} "Rain"  

# UI selection buttons
add_de1_text  "iconik_settings" 1370 140 -text "User Interface:" -anchor w -justify center -font $::font_small_header -fill [::theme background_text]
create_button "iconik_settings" 1370 180 1570 330 $::font_tiny [::theme button] [::theme button_text_light] {set ::iconik_settings(ui) "default"; iconik_save_settings; borg toast "UI changed, please restart"} "Default" 
create_button "iconik_settings" 1630 180 1830 330 $::font_tiny [::theme button] [::theme button_text_light] {set ::iconik_settings(ui) "magadan"; iconik_save_settings; borg toast "UI changed, please restart"} "Magadan"

# Bottom buttons
create_button "iconik_settings" 210 1460 1220 1580 $::font_small [::theme button_tertiary] [::theme button_text_light] { say [translate "settings"] $::settings(sound_button_in); iconik_save_settings; page_to_show_when_off "$::iconik_settings(ui)_off" } { [translate "Done"]}
create_button "iconik_settings" 50 1460 190 1580 $::font_big_icon [::theme button_tertiary] [::theme button_text_light] { say [translate "settings"] $::settings(sound_button_in); iconik_open_profile_settings } {\uf013}

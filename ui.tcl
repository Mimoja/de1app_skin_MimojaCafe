
proc iconik_wakeup {} {
	set_next_page "off" "off"
	page_show "off"
	start_idle
}

proc iconik_water_temperature {} {
	if {$::settings(enable_fahrenheit) == 1} {
		set temp [round_to_one_digits [celsius_to_fahrenheit $::settings(water_temperature)]]
		return "$temp F"
	}
	set temp [round_to_one_digits $::settings(water_temperature)]
	return "$temp °C"
}

proc iconik_expresso_temperature {} {
	if {$::settings(settings_profile_type) == "settings_2c2" || $::settings(settings_profile_type) == "settings_2c"} {
		set val $::current_adv_step(temperature)
	} else {
		set val $::settings(espresso_temperature)
	}
	if {$::settings(enable_fahrenheit) == 1} {
		set temp [round_to_one_digits [celsius_to_fahrenheit $val]]
		return "$temp F"
	}
	set temp [round_to_one_digits $val]
	return "$temp °C"
}

proc iconik_get_final_weight {} {
	if {$::settings(settings_profile_type) == "settings_2c"} {
    	return $::settings(final_desired_shot_weight_advanced)
    } else {
    	return $::settings(final_desired_shot_weight)
    }
}

proc iconik_profile_title {slot} {
	return [dict get $::iconik_settings(profiles) $slot title]
}

proc iconik_steam_timeout {slot} {
	return [dict get $::iconik_settings(steam_profiles) $slot timeout]
}

add_background "off history"

# History Page

add_de1_widget "history" graph 680 80 {
	#Target
	$widget element create line_history_espresso_pressure_goal -xdata history_elapsed -ydata history_pressure_goal -symbol none -label "" -linewidth [rescale_x_skin 8] -color [theme primary_light]  -smooth $::settings(live_graph_smoothing_technique) -pixels 0 -dashes {5 5};
	$widget element create line_history_espresso_flow_goal -xdata history_elapsed -ydata history_flow_goal -symbol none -label "" -linewidth [rescale_x_skin 8] -color [theme secondary_light] -smooth $::settings(live_graph_smoothing_technique) -pixels 0  -dashes {5 5};
	$widget element create line_history_espresso_pressure -xdata history_elapsed -ydata history_pressure  -symbol none -label "" -linewidth [rescale_x_skin 12] -color [theme primary]  -smooth $::settings(live_graph_smoothing_technique) -pixels 0 -dashes $::settings(chart_dashes_pressure);
	$widget element create line_history_espresso_flow -xdata history_elapsed -ydata history_flow -symbol none -label "" -linewidth [rescale_x_skin 12] -color  [theme secondary] -smooth $::settings(live_graph_smoothing_technique) -pixels 0  -dashes $::settings(chart_dashes_flow);

	$widget element create line_history_espresso_weight -xdata history_elapsed -ydata history_weight -symbol none -label "" -linewidth [rescale_x_skin 6] -color #f8b888 -smooth $::settings(live_graph_smoothing_technique) -pixels 0 -dashes $::settings(chart_dashes_espresso_weight);
	$widget axis configure x -color [theme background_text] -tickfont Helv_7 -min 0.0;
	$widget axis configure y -color [theme background_text] -tickfont Helv_7 -min 0.0 -max 12 -subdivisions 5 -majorticks {0 1 2 3 4 5 6 7 8 9 10 11 12}  -hide 0;
	$widget grid configure -color [theme background_text]

} -plotbackground [theme background] -width [rescale_x_skin 1860] -height [rescale_y_skin 1340] -borderwidth 1 -background [theme background] -plotrelief flat

add_de1_widget "history" listbox 80	80 {
	set ::history_widget $widget
	bind $::history_widget <<ListboxSelect>> ::iconik_show_past_shot
	iconik_fill_history_listbox
} -background #fbfaff -font Helv_9 -bd 0 -height 18 -width 16 -borderwidth 0 -selectborderwidth 0  -relief flat -highlightthickness 0 -selectmode single -foreground [theme primary] -selectbackground [theme primary_dark]  -selectforeground [theme button_text_light] -yscrollcommand {scale_scroll_new $::history_widget ::history_slider}

set ::history_slider 0
set ::history_scrollbar [add_de1_widget "history" scale 10000 1 {} -from 0 -to .90 -bigincrement 0.2 -background [theme primary] -borderwidth 1 -showvalue 0 -resolution .01 -length [rescale_x_skin 400] -width [rescale_y_skin 150] -variable ::history_slider -font Helv_10_bold -sliderlength [rescale_x_skin 125] -relief flat -command {listbox_moveto $::history_widget $::history_slider}  -foreground [theme background] -troughcolor [theme background] -borderwidth 2  -highlightthickness 0]

proc set_history_scrollbar_dimensions {} {
	set_scrollbar_dimensions $::history_scrollbar $::history_widget
}


create_button "history" 580 1440 1880 1560 [translate "Done"] $::font_tiny [theme button_tertiary] [theme button_text_light] { say [translate "settings"] $::settings(sound_button_in); page_to_show_when_off "off" }

# Return from screensaver
set_de1_screen_saver_directory "[homedir]/saver"
add_de1_button "saver" {say [translate "wake"] $::settings(sound_button_in); iconik_wakeup} 0 0 2560 1600

# Profile QuickSettings
create_button "settings_1" 1140 1020 1240 1120 "1" $::font_big [theme button] [theme button_text_light] {iconik_save_profile 1}
create_button "settings_1" 1140 1150 1240 1250 "2" $::font_big [theme button] [theme button_text_light] {iconik_save_profile 2}
create_button "settings_1" 1140 1280 1240 1380 "3" $::font_big [theme button] [theme button_text_light] {iconik_save_profile 3}

# Skin theme buttons
create_button "settings_4" 80 1480 380 1580 "Default"  $::font_big $::default_theme(button) $::default_theme(button_text_light) {set ::iconik_settings(theme) "::default_theme"; iconik_save_settings; borg toast "Theme changed, please restart"}
create_button "settings_4" 480 1480 780 1580 "Dark"    $::font_big $::dark_theme(button)     $::dark_theme(button_text_light)   {set ::iconik_settings(theme) "::dark_theme";    iconik_save_settings; borg toast "Theme changed, please restart"}
create_button "settings_4" 880 1480 1180 1580 "Purple" $::font_big $::purple_theme(button)   $::purple_theme(button_text_light) {set ::iconik_settings(theme) "::purple_theme";  iconik_save_settings; borg toast "Theme changed, please restart"}


# Upper buttons
## Background
rectangle "off" 0 0 2560 180 [theme background_highlight]

## Flush
create_settings_button "off" 80 30 480 150 "" $::font_tiny [theme button_secondary] [theme button_text_light]  {  set ::iconik_settings(flush_timeout) [expr {$::iconik_settings(flush_timeout) - 0.5}]; iconik_save_settings} {  set ::iconik_settings(flush_timeout) [expr {$::iconik_settings(flush_timeout) + 0.5}]; iconik_save_settings}
add_de1_variable "off" [expr (80 + 480) / 2.0 ] [expr (30 + 150) / 2.0 ] -width 200  -text "" -font $::font_tiny -fill [theme button_text_light] -anchor "center" -justify "center" -state "hidden" -textvariable {Flush:\n[round_to_one_digits $::iconik_settings(flush_timeout)]s}

## Espresso Temperature
create_settings_button "off" 580 30 980 150 "" $::font_tiny [theme button_secondary] [theme button_text_light] {iconik_temperature_adjust down} {iconik_temperature_adjust up}
add_de1_variable "off" [expr (580 + 980) / 2.0 ] [expr (30 + 150) / 2.0 ] -width [rescale_x_skin 280]  -text "" -font $::font_tiny -fill [theme button_text_light] -anchor "center" -justify "center" -state "hidden" -textvariable {Temp:\n [iconik_expresso_temperature]}

## Espresso Target Weight
create_settings_button "off" 1080 30 1480 150 "" $::font_tiny [theme button_secondary] [theme button_text_light]  { set ::settings(final_desired_shot_weight) [expr {$::settings(final_desired_shot_weight) - 1}];set ::settings(final_desired_shot_weight_advanced) [expr {$::settings(final_desired_shot_weight_advanced) - 1}]; profile_has_changed_set; save_profile; save_settings_to_de1; save_settings} { set ::settings(final_desired_shot_weight) [expr {$::settings(final_desired_shot_weight) + 1}];set ::settings(final_desired_shot_weight_advanced) [expr {$::settings(final_desired_shot_weight_advanced) + 1}]; profile_has_changed_set; save_profile; save_settings_to_de1; save_settings}
add_de1_variable "off" [expr (1080 + 1480) / 2.0 ] [expr (30 + 150) / 2.0 ] -width [rescale_x_skin 280]  -text "" -font $::font_tiny -fill [theme button_text_light] -anchor "center" -justify "center" -state "hidden" -textvariable {Bev. weight:\n [iconik_get_final_weight]g}

## Steam
create_settings_button "off" 1580 30 1980 150 "" $::font_tiny [theme button_secondary] [theme button_text_light] {iconic_steam_tap down} {iconic_steam_tap up}
add_de1_variable "off" [expr (1580 + 1980) / 2.0 ] [expr (30 + 150) / 2.0 ] -width [rescale_x_skin 280]  -text "" -font $::font_tiny -fill [theme button_text_light] -anchor "center" -justify "center" -state "hidden" -textvariable {Steam $::iconik_settings(steam_active_slot):\n[iconik_get_steam_time]}

## Water Volume
create_settings_button "off" 2080 30 2480 150 "" $::font_tiny [theme button_secondary] [theme button_text_light]  {  set ::settings(water_volume) [expr {$::settings(water_volume) - 5}]; de1_send_steam_hotwater_settings; save_settings} {  set ::settings(water_volume) [expr {$::settings(water_volume) + 5}]; de1_send_steam_hotwater_settings; save_settings}
add_de1_variable "off" [expr (2080 + 2480) / 2.0 ] [expr (30 + 150) / 2.0 ] -width [rescale_x_skin 280]  -text "" -font $::font_tiny -fill [theme button_text_light] -anchor "center" -justify "center" -state "hidden" -textvariable {Water [iconik_water_temperature]:\n[round_to_integer $::settings(water_volume)]ml}

# Recipe
rounded_rectangle "off" 80 210 480 1110 [rescale_x_skin 80] [theme button]
add_de1_variable "off" [expr (80 + 480) / 2.0 ] [expr (240 + 240) / 2.0 ] -width [rescale_x_skin 380]  -text "" -font $::font_big -fill [theme button_text_light] -anchor "n" -justify "center" -state "hidden" -textvariable {[string range $::settings(profile_title) 0 28]}

### TIME
set column1_pos  [expr (80 + 20)  ]
set column2_pos  [expr $column1_pos + 500]
set pos_top 400
set spacer 38

add_de1_text "off" $column1_pos [expr {$pos_top + (0 * $spacer)}] -justify left -anchor "nw" -text [translate "Time"] -font $::font_tiny -fill  [theme button_text_light] -width [rescale_x_skin 520]
add_de1_variable "off" $column1_pos [expr {$pos_top + (1 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny -fill [theme button_text_dark] -width [rescale_x_skin 520] -textvariable {[preinfusion_pour_timer_text]}
add_de1_variable "off" $column1_pos [expr {$pos_top + (3 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny -fill [theme button_text_dark] -width [rescale_x_skin 520] -textvariable {[total_pour_timer_text]}
add_de1_variable "off" $column1_pos [expr {$pos_top + (4 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny -fill [theme button_text_dark] -width [rescale_x_skin 520] -textvariable {[espresso_done_timer_text]}
add_de1_variable "off" $column1_pos [expr {$pos_top + (2 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny -fill [theme button_text_dark] -width [rescale_x_skin 520] -textvariable {[pouring_timer_text]}
# Volume

add_de1_text "off" $column1_pos [expr {$pos_top + (6 * $spacer)}] -justify left -anchor "nw" -text [translate "Volume"] -font $::font_tiny -fill  [theme button_text_light] -width [rescale_x_skin 520]
add_de1_variable "off" $column1_pos [expr {$pos_top + (7 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny  -fill  [theme button_text_dark]  -width [rescale_x_skin 520] -textvariable {[preinfusion_volume]}
add_de1_variable "off" $column1_pos [expr {$pos_top + (8 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny  -fill  [theme button_text_dark]  -width [rescale_x_skin 520] -textvariable {[pour_volume]}
add_de1_variable "off" $column1_pos [expr {$pos_top + (9 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny -fill  [theme button_text_dark]  -width [rescale_x_skin 520] -textvariable {[watervolume_text]}


add_de1_text "off" $column1_pos [expr {$pos_top + (11 * $spacer)}] -justify left -anchor "nw" -text [translate "Peak pressure"] -font $::font_tiny -fill  [theme button_text_light] -width [rescale_x_skin 520]
add_de1_variable "off" $column1_pos [expr {$pos_top + (12 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny  -fill  [theme button_text_dark]  -width [rescale_x_skin 520] -textvariable {[iconik_get_max_pressure] bar}
add_de1_text "off" $column1_pos [expr {$pos_top + (13 * $spacer)}] -justify left -anchor "nw" -text [translate "Minimum flow"] -font $::font_tiny -fill  [theme button_text_light] -width [rescale_x_skin 520]
add_de1_variable "off" $column1_pos [expr {$pos_top + (14 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny  -fill  [theme button_text_dark]  -width [rescale_x_skin 520] -textvariable {[iconik_get_min_flow]  ml/ s}

add_de1_text "off" $column1_pos [expr {$pos_top + (16 * $spacer)}] -justify left -anchor "nw" -text [translate "Waterlevel"] -font $::font_tiny -fill  [theme button_text_light] -width [rescale_x_skin 520]
add_de1_variable "off" $column1_pos [expr {$pos_top + (17 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny  -fill  [theme button_text_dark]  -width [rescale_x_skin 520] -textvariable {Lim: $::settings(water_refill_point) Curr: [round_to_one_digits $::de1(water_level)]}


# Presets

## Coffee
rounded_rectangle "off" 80 1140 480 1380  [rescale_x_skin 80] [theme button]
add_de1_variable "off" [expr (80 + 480) / 2.0 ] [expr (1140 + 1380) / 2.0 ] -width 180  -text "" -font $::font_tiny -fill [theme button_text_light] -anchor "center" -justify "center" -state "hidden" -textvariable {Coffee:\n[iconik_profile_title 1]}
add_de1_button "off" {iconik_toggle_profile 1} 80 1140 480 1380

rounded_rectangle "off" 580 1140 980 1380 [rescale_x_skin 80] [theme button]
add_de1_variable "off" [expr (580 + 980) / 2.0 ] [expr (1140 + 1380) / 2.0 ] -width 180  -text "" -font $::font_tiny -fill [theme button_text_light] -anchor "center" -justify "center" -state "hidden" -textvariable {Coffee:\n[iconik_profile_title 2]}
add_de1_button "off" {iconik_toggle_profile 2} 580 1140 980 1380

rounded_rectangle "off" 1080 1140 1480 1380 [rescale_x_skin 80] [theme button]
add_de1_variable "off" [expr (1080 + 1480) / 2.0 ] [expr (1140 + 1380) / 2.0 ] -width 180  -text "" -font $::font_tiny -fill [theme button_text_light] -anchor "center" -justify "center" -state "hidden" -textvariable {Coffee:\n[iconik_profile_title 3]}
add_de1_button "off" {iconik_toggle_profile 3} 1080 1140 1480 1380

## Steam Presets

rounded_rectangle "off" 1580 1140 1980 1380 [rescale_x_skin 80] [theme button]
add_de1_variable "off" [expr (1580 + 1980) / 2.0 ] [expr (1140 + 1380) / 2.0 ] -width 100  -text "" -font $::font_tiny -fill [theme button_text_light] -anchor "center" -justify "center" -state "hidden" -textvariable {Steam 1:\n[iconik_steam_timeout 1]s}
add_de1_button "off" {iconik_toggle_steam_settings 1} 1580 1140 1980 1380

rounded_rectangle "off" 2080 1140 2480 1380 [rescale_x_skin 80] [theme button]
add_de1_variable "off" [expr (2080 + 2480) / 2.0 ] [expr (1140 + 1380) / 2.0 ] -width 100  -text "" -font $::font_tiny -fill [theme button_text_light] -anchor "center" -justify "center" -state "hidden" -textvariable {Steam 2:\n[iconik_steam_timeout 2]s}
add_de1_button "off" {iconik_toggle_steam_settings 2} 2080 1140 2480 1380


## Bottom buttons

rectangle "off" 0 1410 2560 1600 [theme background_highlight]

## Status
rounded_rectangle "off" 80 1440 480 1560 [rescale_x_skin 80] [theme button_tertiary]
add_de1_variable "off" [expr (80 + 480) / 2.0 ] [expr (1440 + 1560) / 2.0 ] -width 280  -text "" -font $::font_tiny -fill [theme button_text_light] -anchor "center" -justify "center" -state "hidden" -textvariable {[iconik_get_status_text]}
add_de1_button "off" { iconik_status_tap } 80 1440 480 1560

## MISC buttons
create_button "off" 580 1440 980 1560 [translate "History"] $::font_tiny [theme button_tertiary] [theme button_text_light] { say [translate "settings"] $::settings(sound_button_in); iconik_fill_history_listbox; page_to_show_when_off "history"; set_history_scrollbar_dimensions}
create_button "off" 1080 1440 1480 1560 [translate "Clean"] $::font_tiny [theme button_tertiary] [theme button_text_light] { say [translate "settings"] $::settings(sound_button_in); iconik_toggle_cleaning }
create_button "off" 1580 1440 1980 1560 [translate "Settings"] $::font_tiny [theme button_tertiary] [theme button_text_light] { say [translate "settings"] $::settings(sound_button_in); iconik_show_settings}
create_button "off" 2080 1440 2480 1560 [translate "Sleep"] $::font_tiny [theme button_tertiary] [theme button_text_light] { say [translate "settings"] $::settings(sound_button_in); start_sleep }

## Graph

add_de1_widget "off" graph 580 230 {

	$widget element create line_espresso_pressure_goal -xdata espresso_elapsed -ydata espresso_pressure_goal -symbol none -label "" -linewidth [rescale_x_skin 8] -color [theme primary_light]  -smooth $::settings(live_graph_smoothing_technique) -pixels 0 -dashes {5 5};
	$widget element create line2_espresso_pressure -xdata espresso_elapsed -ydata espresso_pressure -symbol none -label "" -linewidth [rescale_x_skin 12] -color [theme primary]  -smooth $::settings(live_graph_smoothing_technique) -pixels 0 -dashes $::settings(chart_dashes_pressure);

	if {$::settings(display_pressure_delta_line) == 1} {
		$widget element create line_espresso_pressure_delta_1  -xdata espresso_elapsed -ydata espresso_pressure_delta -symbol none -label "" -linewidth [rescale_x_skin 2] -color [theme primary_dark] -pixels 0 -smooth $::settings(live_graph_smoothing_technique)
	}

	$widget element create line_espresso_flow_goal_2x  -xdata espresso_elapsed -ydata espresso_flow_goal -symbol none -label "" -linewidth [rescale_x_skin 8] -color [theme secondary_light] -smooth $::settings(live_graph_smoothing_technique) -pixels 0  -dashes {5 5};
	$widget element create line_espresso_flow_2x  -xdata espresso_elapsed -ydata espresso_flow -symbol none -label "" -linewidth [rescale_x_skin 12] -color  [theme secondary] -smooth $::settings(live_graph_smoothing_technique) -pixels 0  -dashes $::settings(chart_dashes_flow);
	$widget element create god_line_espresso_flow_2x  -xdata espresso_elapsed -ydata god_espresso_flow -symbol none -label "" -linewidth [rescale_x_skin 24] -color #e4edff -smooth $::settings(live_graph_smoothing_technique) -pixels 0;

	if {$::settings(chart_total_shot_flow) == 1} {
		$widget element create line_espresso_total_flow  -xdata espresso_elapsed -ydata espresso_water_dispensed -symbol none -label "" -linewidth [rescale_x_skin 6] -color #98c5ff -smooth $::settings(live_graph_smoothing_technique) -pixels 0 -dashes $::settings(chart_dashes_espresso_weight);
	}

	if {$::settings(display_flow_delta_line) == 1} {
		$widget element create line_espresso_flow_delta_1  -xdata espresso_elapsed -ydata espresso_flow_delta -symbol none -label "" -linewidth [rescale_x_skin 2] -color #98c5ff -pixels 0 -smooth $::settings(live_graph_smoothing_technique)
	}

	if {$::settings(scale_bluetooth_address) != ""} {
		$widget element create line_espresso_flow_weight_2x  -xdata espresso_elapsed -ydata espresso_flow_weight -symbol none -label "" -linewidth [rescale_x_skin 8] -color #a2693d -smooth $::settings(live_graph_smoothing_technique) -pixels 0;
		$widget element create line_espresso_flow_weight_raw_2x  -xdata espresso_elapsed -ydata espresso_flow_weight_raw -symbol none -label "" -linewidth [rescale_x_skin 2] -color #f8b888 -smooth $::settings(live_graph_smoothing_technique) -pixels 0 ;
		$widget element create god_line_espresso_flow_weight_2x  -xdata espresso_elapsed -ydata god_espresso_flow_weight -symbol none -label "" -linewidth [rescale_x_skin 16] -color #edd4c1 -smooth $::settings(live_graph_smoothing_technique) -pixels 0;

		if {$::settings(chart_total_shot_weight) == 1 || $::settings(chart_total_shot_weight) == 2} {
			$widget element create line_espresso_weight_2x  -xdata espresso_elapsed -ydata espresso_weight_chartable -symbol none -label "" -linewidth [rescale_x_skin 6] -color #f8b888 -smooth $::settings(live_graph_smoothing_technique) -pixels 0 -dashes $::settings(chart_dashes_espresso_weight);
		}

		# when using Resistance calculated from the flowmeter, use a solid line to indicate it is well measured
		$widget element create line_espresso_resistance  -xdata espresso_elapsed -ydata espresso_resistance_weight -symbol none -label "" -linewidth [rescale_x_skin 4] -color #e5e500 -smooth $::settings(live_graph_smoothing_technique) -pixels 0

	}

	$widget element create line_espresso_resistance_dashed  -xdata espresso_elapsed -ydata espresso_resistance -symbol none -label "" -linewidth [rescale_x_skin 4] -color #e5e500 -smooth $::settings(live_graph_smoothing_technique) -pixels 0  -dashes {6 2};

	$widget element create god_line2_espresso_pressure -xdata espresso_elapsed -ydata god_espresso_pressure -symbol none -label "" -linewidth [rescale_x_skin 24] -color #c5ffe7  -smooth $::settings(live_graph_smoothing_technique) -pixels 0;
	$widget element create line_espresso_state_change_1 -xdata espresso_elapsed -ydata espresso_state_change -label "" -linewidth [rescale_x_skin 6] -color #AAAAAA  -pixels 0 ;

	$widget axis configure x -color [theme background_text] -tickfont Helv_7_bold;
	$widget axis configure y -color [theme background_text] -tickfont Helv_7_bold -min 0.0 -max $::settings(zoomed_y_axis_scale) -subdivisions 5 -majorticks {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20} -hide 0;

	# show the explanation for pressure
	$widget element create line_espresso_de1_explanation_chart_pressure_zoomed -xdata espresso_de1_explanation_chart_elapsed -ydata espresso_de1_explanation_chart_pressure  -label "" -linewidth [rescale_x_skin 16] -color [theme primary]  -smooth $::settings(preview_graph_smoothing_technique) -pixels 0;

	# show the explanation for flow
	$widget element create line_espresso_de1_explanation_chart_flow_zoom -xdata espresso_de1_explanation_chart_elapsed_flow -ydata espresso_de1_explanation_chart_flow  -label "" -linewidth [rescale_x_skin 18] -color [theme secondary]  -smooth $::settings(preview_graph_smoothing_technique) -pixels 0;


} -plotbackground [theme background] -width [rescale_x_skin 1880] -height [rescale_y_skin 900] -borderwidth 1 -background [theme background] -plotrelief flat -plotpady 0 -plotpadx 10

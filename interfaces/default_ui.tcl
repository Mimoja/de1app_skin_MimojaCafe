
proc iconik_water_temperature {} {
	if {$::settings(enable_fahrenheit) == 1} {
		set temp [round_to_one_digits [celsius_to_fahrenheit $::iconik_settings(water_temperature_overwride)]]
		return "$temp F"
	}
	set temp [round_to_one_digits $::iconik_settings(water_temperature_overwride)]
	return "$temp °C"
}

proc iconik_expresso_temperature {} {
	set profile_changed_indicator ""
	
	if {[profile_backup_exists]} {
		set profile_changed_indicator " *"
	}

	if {[is_advanced_profile]} {
		set val $::current_adv_step(temperature)
	} else {
		set val $::settings(espresso_temperature)
	}
	if {$::settings(enable_fahrenheit) == 1} {
		set temp [round_to_one_digits [celsius_to_fahrenheit $val]]
		return "$temp F$profile_changed_indicator"
	}
	set temp [round_to_one_digits $val]
	return "$temp °C$profile_changed_indicator"
}

proc iconik_profile_title {slot} {
	return [dict get $::iconik_settings(profiles) $slot title]
}

proc iconik_steam_timeout {slot} {
	return [dict get $::iconik_settings(steam_profiles) $slot timeout]
}

proc profile_file {} {
	return "[homedir]/profiles/${::settings(profile_filename)}.tcl"
}

proc profile_backup_file {} {
	return "[profile_file].orig"
}

proc profile_backup_exists {} {
	if {$::iconik_settings(create_profile_backups) == 0} {
		return 0;
	}
	set origfn [profile_backup_file]
	return [file exists $origfn]
}

proc backup_profile {} {
	if {$::iconik_settings(create_profile_backups) == 0} {
		return;
	}
	if {![profile_backup_exists]} {
		file copy -force [profile_file] [profile_backup_file]
		borg toast [translate "Original profile backed up"]
	}
}

proc is_advanced_profile {} {
	return [expr {$::settings(settings_profile_type) == "settings_2c2" || $::settings(settings_profile_type) == "settings_2c"}]
}

set ::origprofilefile {}
proc restore_profile {} {
	if {$::iconik_settings(create_profile_backups) == 0} {
		return;
	}
	if {[profile_backup_exists]} {
		file copy -force [profile_backup_file] [profile_file] 
		file delete [profile_backup_file]

		set ::origprofilefile $::settings(profile_filename)
		select_profile "default"
		after 100 {
			select_profile $::origprofilefile
			if {[is_advanced_profile]} {
				fill_advanced_profile_steps_listbox
			}
			borg toast [translate "Original profile restored"]
		}
	}
}

add_background "default_off"

# Water level indicator
if {$::iconik_settings(show_water_level_indicator) == 1} {
	# water level sensor
	add_de1_widget "default_off" scale 0 0 {after 1000 water_level_color_check $widget} -from 40 -to 5 -background [::theme primary] -foreground [::theme secondary] -borderwidth 1 -bigincrement .1 -resolution .1 -length [rescale_x_skin 1600] -showvalue 0 -width [rescale_y_skin 16] -variable ::de1(water_level) -state disabled -sliderrelief flat -font Helv_10_bold -sliderlength [rescale_x_skin 50] -relief flat -troughcolor [::theme background] -borderwidth 0  -highlightthickness 0
}


# Upper buttons
## Background
rectangle "default_off" 0 0 2560 180 [::theme background_highlight]

## Flush
create_settings_button "default_off" 80 30 480 150 $::font_tiny [::theme button_secondary] [::theme button_text_light]  {set ::iconik_settings(flush_timeout) [expr {$::iconik_settings(flush_timeout) - 0.5}]; iconik_save_settings} {  set ::iconik_settings(flush_timeout) [expr {$::iconik_settings(flush_timeout) + 0.5}]; iconik_save_settings} {Flush:\n[round_to_one_digits $::iconik_settings(flush_timeout)]s}

## Espresso Temperature
if {$::iconik_settings(create_profile_backups) == 0} {
	create_settings_button "default_off" 580 30 980 150 $::font_tiny [::theme button_secondary] [::theme button_text_light] {iconik_temperature_adjust down} {iconik_temperature_adjust up} {Temp:\n [iconik_expresso_temperature]}
} else {
	create_triple_button "default_off" 580 30 980 150 $::font_tiny [::theme button_secondary] [::theme button_text_light] {iconik_temperature_adjust down} {restore_profile} {iconik_temperature_adjust up} {Temp:\n [iconik_expresso_temperature]}
}

## Espresso Target Weight
create_settings_button "default_off" 1080 30 1480 150 $::font_tiny [::theme button_secondary] [::theme button_text_light] {iconik_weight_change down} {iconik_weight_change up} {Bev. weight:\n [iconik_get_final_weight_text]g}

if {$::iconik_settings(show_grinder_settings_on_main_page) == 0} {
	## Steam
	create_settings_button "default_off" 1580 30 1980 150 $::font_tiny [::theme button_secondary] [::theme button_text_light] {iconic_steam_tap down} {iconic_steam_tap up} {Steam $::iconik_settings(steam_active_slot):\n[iconik_get_steam_time]}
	## Water Volume
	create_settings_button "default_off" 2080 30 2480 150 $::font_tiny [::theme button_secondary] [::theme button_text_light] {set ::settings(water_volume) [expr {$::settings(water_volume) - 5}]; de1_send_steam_hotwater_settings; save_settings} {  set ::settings(water_volume) [expr {$::settings(water_volume) + 5}]; de1_send_steam_hotwater_settings; save_settings} {Water [iconik_water_temperature]:\n[round_to_integer $::settings(water_volume)]ml}
} else {
	# Grind Settings
	create_settings_button "default_off" 1580 30 1980 150 $::font_tiny [::theme button_secondary] [::theme button_text_light] { set ::settings(grinder_dose_weight) [expr {$::settings(grinder_dose_weight) - 0.5}]; profile_has_changed_set; save_profile; save_settings_to_de1; save_settings} { set ::settings(grinder_dose_weight) [expr {$::settings(grinder_dose_weight) + 0.5}]; profile_has_changed_set; save_profile; save_settings_to_de1; save_settings} {Dose:\n $::settings(grinder_dose_weight) ([iconik_get_ratio_text])}
	if {$::iconik_settings(show_clock_on_main_page) == 1} {
		## Show clock
		create_button "default_off" 2080 30 2480 150 $::font_tiny [::theme button_secondary] [::theme button_text_light] {} { [time_format [clock seconds] 1]}
	} else {
		create_settings_button "default_off" 2080 30 2480 150 $::font_tiny [::theme button_secondary] [::theme button_text_light]  { set ::settings(grinder_setting) [round_to_one_digits [expr {$::settings(grinder_setting) - 0.1}]]; profile_has_changed_set; save_profile; save_settings_to_de1; save_settings} { set ::settings(grinder_setting) [round_to_one_digits [expr {$::settings(grinder_setting) + 0.1}]]; profile_has_changed_set; save_profile; save_settings_to_de1; save_settings} {Grinder Setting:\n $::settings(grinder_setting)}
	}
}

# Recipe
rounded_rectangle "default_off" 80 210 480 1110 [rescale_x_skin 80] [::theme button]
add_de1_variable "default_off" [expr (80 + 480) / 2.0 ] [expr (240 + 240) / 2.0 ] -width [rescale_x_skin 380]  -text "" -font $::font_small -fill [::theme button_text_light] -anchor "n" -justify "center" -state "hidden" -textvariable {[string range $::settings(profile_title) 0 28]}
add_de1_button "default_off" { say [translate "settings"] $::settings(sound_button_in); iconik_show_settings} 80 240 480 360

### TIME
set column1_pos  [expr (80 + 20)  ]
set column2_pos  [expr $column1_pos + 500]
set pos_top 360
set spacer 38

set ::last_profile ""

proc remember_last_profile { old new } {
	set ::last_profile $::settings(profile_title)
}

register_state_change_handler "Idle" "Espresso" ::remember_last_profile

add_de1_text "default_off" $column1_pos [expr {$pos_top + (0 * $spacer)}] -justify left -anchor "nw" -text [translate "Time"] -font $::font_tiny -fill  [::theme button_text_light] -width [rescale_x_skin 520]
add_de1_variable "default_off" $column1_pos [expr {$pos_top + (1 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny -fill [::theme button_text_dark] -width [rescale_x_skin 520] -textvariable {[preinfusion_pour_timer_text]}
add_de1_variable "default_off" $column1_pos [expr {$pos_top + (2 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny -fill [::theme button_text_dark] -width [rescale_x_skin 520] -textvariable {[pouring_timer_text]}
add_de1_variable "default_off" $column1_pos [expr {$pos_top + (3 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny -fill [::theme button_text_dark] -width [rescale_x_skin 520] -textvariable {[total_pour_timer_text]}
add_de1_variable "default_off" $column1_pos [expr {$pos_top + (4 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny -fill [::theme button_text_dark] -width [rescale_x_skin 520] -textvariable {[espresso_done_timer_text]}
add_de1_variable "default_off" $column1_pos [expr {$pos_top + (5 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny -fill [::theme button_text_dark] -width [rescale_x_skin 380] -textvariable {Last: $::last_profile}

# Volume
add_de1_text "default_off" $column1_pos [expr {$pos_top + (7 * $spacer)}] -justify left -anchor "nw" -text [translate "Volume"] -font $::font_tiny -fill  [::theme button_text_light] -width [rescale_x_skin 520]
add_de1_variable "default_off" $column1_pos [expr {$pos_top + (8 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny  -fill  [::theme button_text_dark]  -width [rescale_x_skin 520] -textvariable {[preinfusion_volume]}
add_de1_variable "default_off" $column1_pos [expr {$pos_top + (9 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny  -fill  [::theme button_text_dark]  -width [rescale_x_skin 520] -textvariable {[pour_volume]}
add_de1_variable "default_off" $column1_pos [expr {$pos_top + (10 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny -fill  [::theme button_text_dark]  -width [rescale_x_skin 520] -textvariable {[watervolume_text]}

if {$::iconik_settings(always_show_temperatures) == 1} {
	# Temperature
	add_de1_text "default_off" $column1_pos [expr {$pos_top + (12 * $spacer)}] -justify left -anchor "nw" -text [translate "Temperature"] -font $::font_tiny -fill  [::theme button_text_light] -width [rescale_x_skin 520]
	add_de1_variable "default_off" $column1_pos [expr {$pos_top + (13 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny  -fill  [::theme button_text_dark]  -width [rescale_x_skin 520] -textvariable {[translate Group] [group_head_heater_temperature_text]}
	add_de1_variable "default_off" $column1_pos [expr {$pos_top + (14 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny  -fill  [::theme button_text_dark]  -width [rescale_x_skin 520] -textvariable {[translate Steam] [steamtemp_text]}
	add_de1_variable "default_off" $column1_pos [expr {$pos_top + (15 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny -fill  [::theme button_text_dark]  -width [rescale_x_skin 520] -textvariable {[translate {Tank preheat}] [return_temperature_setting_or_off $::settings(tank_desired_water_temperature)]}
} else {
	# Max pressure, min flow
	add_de1_text "default_off" $column1_pos [expr {$pos_top + (12 * $spacer)}] -justify left -anchor "nw" -text [translate "Pressure"] -font $::font_tiny -fill  [::theme button_text_light] -width [rescale_x_skin 520]
	add_de1_variable "default_off" $column1_pos [expr {$pos_top + (13 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny  -fill  [::theme button_text_dark]  -width [rescale_x_skin 520] -textvariable {[round_to_one_digits $::de1(pressure)] bar ([iconik_get_max_pressure] peak)}
	add_de1_text "default_off" $column1_pos [expr {$pos_top + (14 * $spacer)}] -justify left -anchor "nw" -text [translate Flow] -font $::font_tiny -fill  [::theme button_text_light] -width [rescale_x_skin 520]
	add_de1_variable "default_off" $column1_pos [expr {$pos_top + (15 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny  -fill  [::theme button_text_dark]  -width [rescale_x_skin 520] -textvariable {[round_to_one_digits $::de1(flow)] mL/s ([iconik_get_min_flow] min)}
}

# water refill
if {$::iconik_settings(show_ml_instead_of_water_level) == 1} {
	add_de1_text "default_off" $column1_pos [expr {$pos_top + (17 * $spacer)}] -justify left -anchor "nw" -text [translate "Water remaining"] -font $::font_tiny -fill  [::theme button_text_light] -width [rescale_x_skin 520]
	add_de1_variable "default_off" $column1_pos [expr {$pos_top + (18 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny  -fill  [::theme button_text_dark]  -width [rescale_x_skin 520] -textvariable {[water_tank_level_to_milliliters $::de1(water_level)] [translate mL] ([round_to_integer $::de1(water_level)][translate mm])}
} else {
	add_de1_text "default_off" $column1_pos [expr {$pos_top + (17 * $spacer)}] -justify left -anchor "nw" -text [translate "Waterlevel"] -font $::font_tiny -fill  [::theme button_text_light] -width [rescale_x_skin 520]
	add_de1_variable "default_off" $column1_pos [expr {$pos_top + (18 * $spacer)}] -justify left -anchor "nw" -text "" -font $::font_tiny  -fill  [::theme button_text_dark]  -width [rescale_x_skin 520] -textvariable {Lim: $::settings(water_refill_point) Curr: [round_to_one_digits $::de1(water_level)]}
}

# Presets

## coffee
create_button "default_off" 80 1140 480 1380 $::font_tiny [::theme button_coffee] [::theme button_text_light] {iconik_toggle_profile 1} {[iconik_profile_title 1]}
create_active_marker "default_off" 80 1140 480 1380 {[iconik_is_coffee_chosen 1]}
create_button "default_off" 580 1140 980 1380 $::font_tiny [::theme button_coffee] [::theme button_text_light] {iconik_toggle_profile 2} {[iconik_profile_title 2]}
create_active_marker "default_off" 580 1140 980 1380 {[iconik_is_coffee_chosen 2]}
create_button "default_off" 1080 1140 1480 1380 $::font_tiny [::theme button_coffee] [::theme button_text_light] {iconik_toggle_profile 3} {[iconik_profile_title 3]}
create_active_marker "default_off" 1080 1140 1480 1380 {[iconik_is_coffee_chosen 3]}


if {$::iconik_settings(steam_presets_enabled) == 1} {
	## Steam Presets
	create_button "default_off" 1580 1140 1980 1380 $::font_tiny [::theme button_coffee] [::theme button_text_light] {iconik_toggle_steam_settings 1} {Steam 1:\n[iconik_steam_timeout 1]s}
	create_active_marker "default_off" 1580 1140 1980 1380 {[iconik_is_steam_chosen 1]}
	create_button "default_off" 2080 1140 2480 1380 $::font_tiny [::theme button_coffee] [::theme button_text_light] {iconik_toggle_steam_settings 2} {Steam 2:\n[iconik_steam_timeout 2]s} 
	create_active_marker "default_off" 2080 1140 2480 1380 {[iconik_is_steam_chosen 2]}
} else {
	# Two more coffee presets
	create_button "default_off"  1580 1140 1980 1380 $::font_tiny [::theme button_coffee] [::theme button_text_light] {iconik_toggle_profile 4} {[iconik_profile_title 4]}
	create_active_marker "default_off" 1580 1140 1980 1380 {[iconik_is_coffee_chosen 4]}
	create_button "default_off" 2080 1140 2480 1380 $::font_tiny [::theme button_coffee] [::theme button_text_light] {iconik_toggle_profile 5} {[iconik_profile_title 5]}
	create_active_marker "default_off" 2080 1140 2480 1380 {[iconik_is_coffee_chosen 5]}
}

## Bottom buttons

rectangle "default_off" 0 1410 2560 1600 [::theme background_highlight]

## Status and MISC buttons
create_button "default_off" 80 1440 480 1560    $::font_tiny [::theme button_tertiary] [::theme button_text_light] { say [translate "settings"] $::settings(sound_button_in); iconik_status_tap } {[iconik_get_status_text]}
create_button "default_off" 580 1440 980 1560   $::font_tiny [::theme button_tertiary] [::theme button_text_light] { say [translate "settings"] $::settings(sound_button_in); show_history_page} {[translate "History"]}
create_button "default_off" 1080 1440 1480 1560 $::font_tiny [::theme button_tertiary] [::theme button_text_light] { say [translate "settings"] $::settings(sound_button_in); iconik_toggle_cleaning } { [translate "Clean"]} 
create_button "default_off" 1580 1440 1980 1560 $::font_tiny [::theme button_tertiary] [::theme button_text_light] { say [translate "settings"] $::settings(sound_button_in); iconik_select_profile } {[translate "Settings"]}
create_button "default_off" 2080 1440 2480 1560 $::font_tiny [::theme button_tertiary] [::theme button_text_light] { say [translate "settings"] $::settings(sound_button_in); start_sleep } { [translate "Sleep"]}


## GHC buttons
if {$::iconik_settings(show_ghc_buttons) == 1} {
	create_button "default_off" 2180 210 2480 390  $::font_tiny [::theme button_tertiary] [::theme button_text_light] { ghc_action_or_stop start_espresso } {[ghc_text_or_stop "Espresso"]}
	create_button "default_off" 2180 450 2480 630  $::font_tiny [::theme button_tertiary] [::theme button_text_light] { ghc_action_or_stop start_water}     {[ghc_text_or_stop "Water"]}
	create_button "default_off" 2180 690 2480 870  $::font_tiny [::theme button_tertiary] [::theme button_text_light] { ghc_action_or_stop start_steam}     {[ghc_text_or_stop "Steam"]}
	create_button "default_off" 2180 930 2480 1110 $::font_tiny [::theme button_tertiary] [::theme button_text_light] { ghc_action_or_stop start_flush}     {[ghc_text_or_stop "Flush"]} 
}


## Graph

# 900 default
set espresso_graph_height 900
set espresso_graph_width 1880

if {$::iconik_settings(show_ghc_buttons) == 1} {
	set espresso_graph_width 1540
}

if {$::iconik_settings(show_steam) == 1} {
	set espresso_graph_height 600
}
add_de1_widget "default_off" graph 580 230 {

	set ::skin::mimojacafe::graph::espresso $widget

	# configure axes
	$widget axis configure x -color [::theme background_text] -tickfont Helv_6;
	$widget axis configure y -color [::theme background_text] -tickfont Helv_6 -min 0.0 -max $::iconik_settings(y_axis_scale) -subdivisions 5 -majorticks {0 1 2 3 4 5 6 7 8 9 10 11 12} -hide 0;

	set flow_axis y

	if {$::iconik_settings(seperate_flow_axis)} {
		$widget axis configure y2 -color [::theme secondary] -tickfont Helv_6 -min 0.0 -max [expr {$::iconik_settings(y_axis_scale) / 3 * 2}] -subdivisions 0 -majorticks {0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8} -title [translate {Flow [mL/s]}] -titlecolor [::theme secondary] -hide 0;
		set flow_axis y2
	}

	if {$::iconik_settings(show_grid_lines) != 1} {
		$widget grid configure -hide yes
	}
	# create lines
	$widget element create line_espresso_pressure_goal -xdata espresso_elapsed -ydata espresso_pressure_goal -symbol none -label "" -linewidth [rescale_x_skin 8] -color [::theme primary_light]  -smooth $::settings(live_graph_smoothing_technique) -pixels 0 -dashes {5 5};
	$widget element create line2_espresso_pressure -xdata espresso_elapsed -ydata espresso_pressure -symbol none -label "" -linewidth [rescale_x_skin 12] -color [::theme primary]  -smooth $::settings(live_graph_smoothing_technique) -pixels 0 -dashes $::settings(chart_dashes_pressure);

	if {$::settings(display_pressure_delta_line) == 1} {
		$widget element create line_espresso_pressure_delta_1  -xdata espresso_elapsed -ydata espresso_pressure_delta -symbol none -label "" -linewidth [rescale_x_skin 2] -color [::theme primary_dark] -pixels 0 -smooth $::settings(live_graph_smoothing_technique)
	}

	if {$::iconik_settings(always_show_temperatures)} {
		$widget axis create temp
		$widget axis configure temp -color [::theme background_text] -min 0.0 -max [expr {$::iconik_settings(y_axis_scale) * 10}]
		
		$widget element create line_espresso_temperature_goal -xdata espresso_elapsed -ydata espresso_temperature_goal -mapy temp  -symbol none -label ""  -linewidth [rescale_x_skin 8] -color #ffa5a6 -smooth $::settings(live_graph_smoothing_technique) -pixels 0 -dashes {5 5}; 
		$widget element create line_espresso_temperature_basket -xdata espresso_elapsed -ydata espresso_temperature_basket -mapy temp -symbol none -label ""  -linewidth [rescale_x_skin 12] -color #e73249 -smooth $::settings(live_graph_smoothing_technique) -pixels 0 -dashes $::settings(chart_dashes_temperature);  

		# show the explanation for temperature
		$widget element create line_espresso_de1_explanation_chart_temp -xdata espresso_de1_explanation_chart_elapsed -ydata espresso_de1_explanation_chart_temperature -mapy temp -label "" -linewidth [rescale_x_skin 15] -color #ff888c  -smooth $::settings(preview_graph_smoothing_technique) -pixels 0; 
	}

	$widget element create line_espresso_flow_goal  -xdata espresso_elapsed -ydata espresso_flow_goal -mapy $flow_axis -symbol none -label "" -linewidth [rescale_x_skin 8] -color [::theme secondary_light] -smooth $::settings(live_graph_smoothing_technique) -pixels 0  -dashes {5 5};
	$widget element create line_espresso_flow  -xdata espresso_elapsed -ydata espresso_flow -mapy $flow_axis -symbol none -label "" -linewidth [rescale_x_skin 12] -color  [::theme secondary] -smooth $::settings(live_graph_smoothing_technique) -pixels 0  -dashes $::settings(chart_dashes_flow);
	$widget element create god_line_espresso_flow  -xdata espresso_elapsed -ydata god_espresso_flow -mapy $flow_axis -symbol none -label "" -linewidth [rescale_x_skin 24] -color #e4edff -smooth $::settings(live_graph_smoothing_technique) -pixels 0;

	if {$::settings(chart_total_shot_flow) == 1} {
		$widget element create line_espresso_total_flow  -xdata espresso_elapsed -ydata espresso_water_dispensed -symbol none -label "" -linewidth [rescale_x_skin 6] -color #98c5ff -smooth $::settings(live_graph_smoothing_technique) -pixels 0 -dashes $::settings(chart_dashes_espresso_weight);
	}

	if {$::settings(scale_bluetooth_address) != ""} {
		$widget element create line_espresso_flow_weight  -xdata espresso_elapsed -ydata espresso_flow_weight -mapy $flow_axis -symbol none -label "" -linewidth [rescale_x_skin 8] -color #a2693d -smooth $::settings(live_graph_smoothing_technique) -pixels 0;
		$widget element create line_espresso_flow_weight_raw  -xdata espresso_elapsed -ydata espresso_flow_weight_raw -mapy $flow_axis -symbol none -label "" -linewidth [rescale_x_skin 2] -color #f8b888 -smooth $::settings(live_graph_smoothing_technique) -pixels 0 ;
		$widget element create god_line_espresso_flow_weight  -xdata espresso_elapsed -ydata god_espresso_flow_weight -mapy $flow_axis -symbol none -label "" -linewidth [rescale_x_skin 16] -color #edd4c1 -smooth $::settings(live_graph_smoothing_technique) -pixels 0;

		if {$::settings(chart_total_shot_weight) == 1 || $::settings(chart_total_shot_weight) == 2} {
			$widget element create line_espresso_weight  -xdata espresso_elapsed -ydata espresso_weight_chartable -symbol none -label "" -linewidth [rescale_x_skin 6] -color #f8b888 -smooth $::settings(live_graph_smoothing_technique) -pixels 0 -dashes $::settings(chart_dashes_espresso_weight);
		}
	}

	$widget element create god_line2_espresso_pressure -xdata espresso_elapsed -ydata god_espresso_pressure -symbol none -label "" -linewidth [rescale_x_skin 24] -color #c5ffe7  -smooth $::settings(live_graph_smoothing_technique) -pixels 0;
	$widget element create line_espresso_state_change_1 -xdata espresso_elapsed -ydata espresso_state_change -label "" -linewidth [rescale_x_skin 6] -color #AAAAAA  -pixels 0 ;
	
	
	# show the explanation for pressure
	$widget element create line_espresso_de1_explanation_chart_pressurec -xdata espresso_de1_explanation_chart_elapsed -ydata espresso_de1_explanation_chart_pressure  -label "" -linewidth [rescale_x_skin 16] -color [::theme primary]  -smooth $::settings(preview_graph_smoothing_technique) -pixels 0;
	
	# show the explanation for flow
	$widget element create line_espresso_de1_explanation_chart_flowc -xdata espresso_de1_explanation_chart_elapsed -ydata espresso_de1_explanation_chart_flow -mapy $flow_axis  -label "" -linewidth [rescale_x_skin 18] -color [::theme secondary]  -smooth $::settings(preview_graph_smoothing_technique) -pixels 0;
	
} -plotbackground [::theme background] -width [rescale_x_skin $espresso_graph_width] -height [rescale_y_skin $espresso_graph_height] -borderwidth 1 -background [::theme background] -plotrelief flat -plotpady 0 -plotpadx 10


if {$::iconik_settings(show_steam) == 1} {
	add_de1_widget "default_off" graph 580 830 {

		set ::skin::mimojacafe::graph::steam $widget

		if {$::iconik_settings(show_steam_grid_lines) != 1} {
			$widget grid configure -hide yes
		}

		$widget element create line_steam_pressure -xdata steam_elapsed -ydata steam_pressure -symbol none -label "" -linewidth [rescale_x_skin 6] -color #86C240  -smooth $::settings(live_graph_smoothing_technique) -pixels 0 -dashes $::settings(chart_dashes_pressure);
		$widget element create line_steam_flow -xdata steam_elapsed -ydata steam_flow -symbol none -label "" -linewidth [rescale_x_skin 6] -color #43B1E3  -smooth $::settings(live_graph_smoothing_technique) -pixels 0 -dashes $::settings(chart_dashes_flow);
		$widget element create line_steam_temperature -xdata steam_elapsed -ydata steam_temperature -symbol none -label "" -linewidth [rescale_x_skin 6] -color #FF2600 -smooth $::settings(live_graph_smoothing_technique) -pixels 0 -dashes $::settings(chart_dashes_temperature);

		$widget axis configure x -color [::theme background_text] -tickfont Helv_6 -linewidth [rescale_x_skin 2]
		$widget axis configure y -color [::theme background_text] -tickfont Helv_6 -min 0 -max 4 -subdivisions 5 -majorticks {1 2 3 4}

	} -plotbackground [::theme background] -width [rescale_x_skin $espresso_graph_width] -height [rescale_y_skin 300] -borderwidth 1 -background [::theme background] -plotrelief flat
}

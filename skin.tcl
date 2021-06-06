package require de1plus 1.0
package require de1_plugins

source "[homedir]/skins/default/standard_includes.tcl"

set ::skindebug 0
set ::debugging 0
set ::history_to_restore_after_cleanup {}

namespace eval ::skin::mimojacafe::graph {}

source "[skin_directory]/settings.tcl"

iconik_load_settings
iconik_save_settings

set ::version_string "Version 1.6.1-$::iconik_settings(ui)"

source "[skin_directory]/framework.tcl"

proc iconik_wakeup {} {
	set_next_page "off" "$::iconik_settings(ui)_off"
	page_show "$::iconik_settings(ui)_off"
	start_idle
}

proc iconik_DYE_supported {} {
	return [plugins enabled "DYE"]
}

source "[skin_directory]/interfaces/default_ui.tcl"
source "[skin_directory]/interfaces/magadan_ui.tcl"

source "[skin_directory]/theme.tcl"
init_MimojaCafe_dui_theme

# Settings Page
source "[skin_directory]/interfaces/default_settings_screen.tcl"

# Return from screensaver
set_de1_screen_saver_directory [homedir]$::iconik_settings(saver_dir)
add_de1_button "saver" {say [translate "wake"] $::settings(sound_button_in); iconik_wakeup} 0 0 2560 1600


# Profile QuickSettings
create_button "settings_1" 80 1460 200 1580  $::font_tiny [::theme button] [::theme button_text_light] {iconik_save_profile 1} "1"
create_button "settings_1" 220 1460 340 1580 $::font_tiny [::theme button] [::theme button_text_light] {iconik_save_profile 2} "2"
create_button "settings_1" 360 1460 480 1580 $::font_tiny [::theme button] [::theme button_text_light] {iconik_save_profile 3} "3"
create_button "settings_1" 500 1460 620 1580 $::font_tiny [::theme button] [::theme button_text_light] {iconik_save_profile 4} "4" 

if {$::iconik_settings(steam_presets_enabled) == 0} {
	create_button "settings_1" 640 1460 760 1580 $::font_tiny [::theme button] [::theme button_text_light] {iconik_save_profile 5} "5" 
}

if {$::iconik_settings(cleanup_use_profile) == 1} {
	create_button "settings_1" 780 1460 940 1580 $::font_tiny [::theme button] [::theme button_text_light] {iconik_save_cleaning_profile} "Clean"
}


# Skin settings buttons
create_button "settings_1 settings_2 settings_2a settings_2b settings_2c settings_2c2 settings_3 settings_4" 1080 1460 1480 1580 $::font_tiny [::theme button] [::theme button_text_light] { page_to_show_when_off "iconik_settings"} "Skin Settings" 


create_grid
.can itemconfigure "grid" -state "hidden"
#.can itemconfigure "grid" -state "normal"

proc iconik_home {} {
	::page_to_show_when_off "$::iconik_settings(ui)_off"
}

# We no longer have an off page
::add_de1_action "off" ::iconik_home

if {[info exists ::settings(grinder_setting)] != 1 || $::settings(grinder_setting) == {}} {
	set ::settings(grinder_setting) 0
}

if {[info exists ::settings(grinder_dose_weight)] != 1 || $::settings(grinder_dose_weight) == {}} {
	set ::settings(grinder_dose_weight) 0
}


#dont change page on state change
proc skins_page_change_due_to_de1_state_change { textstate } {
	if {$textstate == "Idle"} {
		page_display_change $::de1(current_context) "$::iconik_settings(ui)_off"
    } elseif {$textstate == "Sleep"} {
		page_display_change $::de1(current_context) "saver"
    } elseif {$textstate == "Refill"} {
		page_display_change $::de1(current_context) "tankempty"
	} elseif {$textstate == "Descale"} {
		page_display_change $::de1(current_context) "descaling"
	} elseif {$textstate == "Clean"} {
		page_display_change $::de1(current_context) "cleaning"
	} elseif {$textstate == "AirPurge"} {
		page_display_change $::de1(current_context) "travel_do"
	}
}

proc iconik_toggle_cleaning {} {
	if {$::iconik_settings(cleanup_use_profile)} {
		if {$::iconik_settings(cleanup_restore_selected_profile) == 1} {
			set ::iconik_settings(tmp_profile_to_restore_after_cleanup) $::settings(profile_filename)
			iconik_save_settings
		}
		select_profile $::iconik_settings(cleanup_profile)
	} else {
		start_cleaning
	}
}

proc is_connected {} {return [expr {[clock seconds] - $::de1(last_ping)} < 5]}

proc iconik_get_status_text {} {
	if {[is_connected] != 1} {
		return [translate "Disconnected"]
	}

	if {$::currently_connecting_scale_handle != 0} {
		return  [translate "Scale reconnecting"]
	}

	if { [::device::scale::expecting_present] && ![::device::scale::is_connected]} {
		return [translate "Scale disconnected.\nTap here"]
	}

	switch $::de1(substate) {
		"-" {
			return [translate "Starting"]
		}
		0 {
			if {[::device::scale::is_connected]} {
				return [translate "Ready\nScale connected"]
			}

			return [translate "Ready"]
		}
		1 {
			if {$::iconik_settings(always_show_temperatures)} {
				return [translate "Heating"]
			}
			return [translate "Heating"]\n[group_head_heater_temperature_text]
		}
		3 {
			return [translate "Stabilising"]
		}
		4 {
			return [translate "Preinfusion\nTap to move on"]
		}
		5 {
			return [translate "Pouring\nTap to move on"]
		}
		6 {
			return [translate "Ending"]
		}
		17 {
			return [translate "Refilling"]
		}
		default {
			set result [de1_connected_state 0]
			if {$result == ""} { return "Unknown state" }
			return $result
		}
	}

}

proc show_DYE_page {} {
	dui page load DYE current
}

proc iconik_status_tap {} {
	if {$::de1(scale_device_handle) == 0 && $::settings(scale_bluetooth_address) != ""} {
		ble_connect_to_scale
	}

	if {$::de1_num_state($::de1(state)) == "Espresso"} {
		start_next_step
	}
}

proc ghc_text_or_stop {text} {
	if { $::de1(substate) == 1} {
		return [translate "Please wait"]
	}
	if { $::de1(substate) > 1} {
		return [translate Stop]
	}
	return $text
}

proc ghc_action_or_stop {action} {
	if { $::de1(substate) == 1} {
		return
	}
	if { $::de1(substate) > 1} {
		start_idle
		return
	}
	$action
}

proc iconic_steam_tap {up} {

	if {$up == "up"} {
		set ::settings(steam_timeout) [expr {$::settings(steam_timeout) + 1}]
	} else {
		set ::settings(steam_timeout) [expr {$::settings(steam_timeout) - 1}]
	}

	dict set ::iconik_settings(steam_profiles) $::iconik_settings(steam_active_slot) timeout $::settings(steam_timeout)

	save_settings
	de1_send_steam_hotwater_settings
}

proc iconik_temperature_adjust {up} {
	if {$::iconik_settings(create_profile_backups) == 1} {
		backup_profile
	}

	if {$::settings(settings_profile_type) == "settings_2c2" || $::settings(settings_profile_type) == "settings_2c"} {
		set new_profile {}
		foreach step $::settings(advanced_shot) {
			array set step_array $step
			if {$up == "up"} {
				set step_array(temperature) [round_to_one_digits [expr {$step_array(temperature) + 0.5}]]
			} else {
				set step_array(temperature) [round_to_one_digits [expr {$step_array(temperature) - 0.5}]]
			}
			lappend new_profile [array get step_array]
		}
		set ::settings(advanced_shot) $new_profile
		array set ::current_adv_step [lindex $::settings(advanced_shot) 0]

	} else {
		if {[ifexists ::settings(espresso_temperature_steps_enabled)] == 1} {
			if {$up == "up"} {				
				set ::settings(espresso_temperature_0) [expr {$::settings(espresso_temperature_0) + 0.5}]
				set ::settings(espresso_temperature_1) [expr {$::settings(espresso_temperature_1) + 0.5}]
				set ::settings(espresso_temperature_2) [expr {$::settings(espresso_temperature_2) + 0.5}]
				set ::settings(espresso_temperature_3) [expr {$::settings(espresso_temperature_3) + 0.5}]
				set ::settings(espresso_temperature) $::settings(espresso_temperature_0)
			} else {
				set ::settings(espresso_temperature_0) [expr {$::settings(espresso_temperature_0) - 0.5}]
				set ::settings(espresso_temperature_1) [expr {$::settings(espresso_temperature_1) - 0.5}]
				set ::settings(espresso_temperature_2) [expr {$::settings(espresso_temperature_2) - 0.5}]
				set ::settings(espresso_temperature_3) [expr {$::settings(espresso_temperature_3) - 0.5}]
				set ::settings(espresso_temperature) $::settings(espresso_temperature_0)
			}
		} else {
			if {$up == "up"} {
				set ::settings(espresso_temperature) [expr {$::settings(espresso_temperature) + 0.5}]
			} else {
				set ::settings(espresso_temperature) [expr {$::settings(espresso_temperature) - 0.5}]
			}
		}
	}
	profile_has_changed_set;
	save_profile
	save_settings_to_de1
	save_settings
}


set ::active_button_indicator {___________________________}

proc iconik_is_coffee_chosen { slot } {
	if {[ifexists ::settings(original_profile_title)] == [iconik_profile_title $slot]} {
		return $::active_button_indicator
	} else {
		return {}
	}
}

proc iconik_is_steam_chosen { slot } {
	if {$::settings(steam_timeout) == [iconik_steam_timeout $slot]} {
		return $::active_button_indicator
	} else {
		return {}
	}
}


proc iconik_toggle_steam_settings {slot} {

	set new_steam_timeout [dict get $::iconik_settings(steam_profiles) $slot timeout]

	iconik_save_settings
	set ::settings(steam_timeout) $new_steam_timeout
	set ::iconik_settings(steam_active_slot) $slot
	save_settings
	de1_send_steam_hotwater_settings
}

proc iconik_save_water_temperature {} {
	set ::settings(water_temperature) $::iconik_settings(water_temperature_overwride)
	de1_send_steam_hotwater_settings
	save_settings
}

proc iconik_toggle_profile {slot} {
	god_shot_clear

	set profile [dict get $::iconik_settings(profiles) $slot name]

	select_profile $profile

	if {$::settings(settings_profile_type) == "settings_2c2" || $::settings(settings_profile_type) == "settings_2c"} {
		array set ::current_adv_step [lindex $::settings(advanced_shot) 0]
	}

	iconik_save_water_temperature
	save_settings_to_de1
	save_settings
}

proc timout_flush {old new}  {
	after [round_to_integer [expr $::iconik_settings(flush_timeout) * 1000]] start_idle
}

proc iconik_save_profile {slot} {
	set profiles $::iconik_settings(profiles)

	dict set profiles $slot name $::settings(profile_filename)
	dict set profiles $slot title $::settings(profile_title)

	set ::iconik_settings(profiles) $profiles
	iconik_save_settings
	borg toast [translate "Saved in slot $slot"]
}

proc iconik_save_cleaning_profile {} {

	set ::iconik_settings(cleanup_profile) $::settings(profile_filename)

	iconik_save_settings
	borg toast [translate "Saved in as cleaning profile"]
}

register_state_change_handler "Idle" "HotWaterRinse" ::timout_flush
register_state_change_handler "Espresso" "Idle" ::iconik_after_espresso
register_state_change_handler "Idle" "Espresso" ::iconik_before_espresso

proc iconik_show_settings {} {
	if {$::settings(settings_profile_type) == "settings_2c2" || $::settings(settings_profile_type) == "settings_2c"} {
		fill_advanced_profile_steps_listbox
	}
	show_settings $::settings(settings_profile_type)
}

proc iconik_select_profile {} {
	fill_profiles_listbox
	show_settings settings_1;
	set_profiles_scrollbar_dimensions
}

set ::iconik_max_pressure 0
set ::iconik_min_flow 20

proc iconik_get_max_pressure {} {
	if {$::de1_num_state($::de1(state)) == "Espresso"} {
		if {$::de1(substate) >= $::de1_substate_types_reversed(pouring)} {
			if {$::de1(pressure) >= $::iconik_max_pressure} {
				set ::iconik_max_pressure $::de1(pressure)
			}
		} else {
			set ::iconik_max_pressure 0
		}
	}
	return [round_to_one_digits $::iconik_max_pressure]
}

proc iconik_get_min_flow {} {
	if {$::de1_num_state($::de1(state)) == "Espresso"} {
		if {$::de1_substate_types($::de1(substate)) == "pouring"} {
			if {$::de1(flow) <= $::iconik_min_flow} {
				set ::iconik_min_flow $::de1(flow)
			}
		} else {
			set ::iconik_min_flow 20
		}
	}
	if {$::iconik_min_flow == 20} {
		return 0;
	}
	return [round_to_one_digits $::iconik_min_flow]
}

proc iconik_get_steam_time {} {
	set target_steam_time [round_to_integer $::settings(steam_timeout)]
	if {[info exists ::timers(steam_pour_start)] == 1 && $::de1_num_state($::de1(state)) == "Steam"} {
		set current_steam_time [expr {([clock milliseconds] - $::timers(steam_pour_start))/1000}]
		return "$current_steam_time / ${target_steam_time}s"
	}

	return "${target_steam_time}s"
}

proc iconik_final_weight {} {
	#SAW
	if {[::device::scale::expecting_present]} {
		if {$::settings(settings_profile_type) == "settings_2c"} {
			return $::settings(final_desired_shot_weight_advanced)
		} else {
			return $::settings(final_desired_shot_weight)
		}
	}
	# SAV
	if {$::settings(settings_profile_type) == "settings_2c"} {
		return $::settings(final_desired_shot_volume_advanced)
	} else {
		return $::settings(final_desired_shot_volume)
	}
}

proc iconik_get_ratio_text {} {
	set weight [iconik_final_weight]
	set dose $::settings(grinder_dose_weight)

	return 1:[round_to_one_digits [expr $weight / $dose ]]
}

proc iconik_get_final_weight_text {} {
	set target [iconik_final_weight]

	set current "$target"
	if {[::device::scale::is_connected]} {
		set current "$::de1(scale_weight) / $current"
	}

	return $current
}

proc iconik_weight_change {direction} {

	set change 0
	if {$direction == "up"} {
		set change 1
	} else {
		set change -1
	}

	#SAW
	if {[::device::scale::expecting_present]} {
		if {$::settings(settings_profile_type) == "settings_2c"} {
			set ::settings(final_desired_shot_weight_advanced) [expr {$::settings(final_desired_shot_weight_advanced) + $change}]
			set ::settings(final_desired_shot_weight) 0
		} else {
			set ::settings(final_desired_shot_weight) [expr {$::settings(final_desired_shot_weight) + $change}]
			set ::settings(final_desired_shot_weight_advanced) 0
		}
		set ::settings(final_desired_shot_volume) 0
		set ::settings(final_desired_shot_volume_advanced) 0
	} else {
	# SAV
		if {$::settings(settings_profile_type) == "settings_2c"} {
			set ::settings(final_desired_shot_volume_advanced) [expr {$::settings(final_desired_shot_volume_advanced) + $change}]
			set ::settings(final_desired_shot_volume) 0
		} else {
			set ::settings(final_desired_shot_volume) [expr {$::settings(final_desired_shot_volume) + $change}]
			set ::settings(final_desired_shot_volume_advanced) 0
		}
		set ::settings(final_desired_shot_weight) 0
		set ::settings(final_desired_shot_weight_advanced) 0
	}

	profile_has_changed_set
	save_profile
	save_settings_to_de1
	save_settings
}

proc iconik_set_weight {target} {
	#SAW
	if {[::device::scale::expecting_present]} {
		if {$::settings(settings_profile_type) == "settings_2c"} {
			set ::settings(final_desired_shot_weight_advanced) $target
			set ::settings(final_desired_shot_weight) 0
		} else {
			set ::settings(final_desired_shot_weight) $target
			set ::settings(final_desired_shot_weight_advanced) 0

		}
		set ::settings(final_desired_shot_volume) 0
		set ::settings(final_desired_shot_volume_advanced) 0
	} else {
	# SAV
		if {$::settings(settings_profile_type) == "settings_2c"} {
			set ::settings(final_desired_shot_volume_advanced) $target
			set ::settings(final_desired_shot_volume) 0
		} else {
			set ::settings(final_desired_shot_volume) $target
			set ::settings(final_desired_shot_volume_advanced) 0
		}
		set ::settings(final_desired_shot_weight) 0
		set ::settings(final_desired_shot_weight_advanced) 0
	}

	profile_has_changed_set
	save_profile
	save_settings_to_de1
	save_settings
}


proc iconik_is_cleanup {} { return [ expr { $::iconik_settings(cleanup_profile) == $::settings(profile_filename) } ] }

proc iconik_before_espresso { old new } {
	if { [iconik_is_cleanup] } { iconik_before_cleanup_profile }
}

proc iconik_after_espresso { old new } {
	if { [iconik_is_cleanup] } { iconik_after_cleanup_profile }
}

proc iconik_before_cleanup_profile {} {
	set ::history_to_restore_after_cleanup $::settings(should_save_history)
	if {$::iconik_settings(cleanup_bypass_shot_history) == 1} {
		set ::settings(should_save_history) 0
	}
}

proc iconik_after_cleanup_profile {} {
	set ::settings(should_save_history) $::history_to_restore_after_cleanup
	if {$::iconik_settings(cleanup_restore_selected_profile) == 1} {
		select_profile $::iconik_settings(tmp_profile_to_restore_after_cleanup)
	}
}

iconik_wakeup
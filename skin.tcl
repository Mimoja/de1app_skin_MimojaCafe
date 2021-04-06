package require de1plus 1.0

source "[homedir]/skins/default/standard_includes.tcl"

set ::skindebug 0
set ::debugging 0
set ::history_to_restore_after_cleanup {}

namespace eval ::skin::mimojacafe::graph {}

source "[skin_directory]/settings.tcl"

iconik_load_settings
iconik_save_settings

set ::version_string "Version 1.6-$::iconik_settings(ui)"

source "[skin_directory]/framework.tcl"

source "[skin_directory]/interfaces/$::iconik_settings(ui)_ui.tcl"


create_grid
.can itemconfigure "grid" -state "hidden"
#.can itemconfigure "grid" -state "normal"

if {[info exists ::settings(grinder_setting)] != 1 || $::settings(grinder_setting) == {}} {
	set ::settings(grinder_setting) 0
}

if {[info exists ::settings(grinder_dose_weight)] != 1 || $::settings(grinder_dose_weight) == {}} {
	set ::settings(grinder_dose_weight) 0
}


#dont change page on state change
proc skins_page_change_due_to_de1_state_change { textstate } {
	if {$textstate == "Idle"} {
		page_display_change $::de1(current_context) "off"
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
			return [translate "Preinfusion"]
		}
		5 {
			return [translate "Pouring"]
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

proc iconik_status_tap {} {
	if {$::de1(scale_device_handle) == 0 && $::settings(scale_bluetooth_address) != ""} {
		ble_connect_to_scale
	}
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
		if {$up == "up"} {
			set ::settings(espresso_temperature) [expr {$::settings(espresso_temperature) + 0.5}]
		} else {
			set ::settings(espresso_temperature) [expr {$::settings(espresso_temperature) - 0.5}]
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
	if {$::settings(settings_profile_type) == "settings_2c"} {
		set target $::settings(final_desired_shot_weight_advanced)
	} else {
		set target $::settings(final_desired_shot_weight)
	}
	return $target
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

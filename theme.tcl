# Define the DUI MimojaCafe theme
proc init_MimojaCafe_dui_theme {} {
	dui theme add MimojaCafe
	dui theme set MimojaCafe
	
	set disabled_colour "#35363d"
	set default_font_size 15
	
	dui aspect set [subst {
		page.bg_img {}
		page.bg_color [::theme background]
	
		font.font_family "Mazzard Regular"
		font.font_size $default_font_size
		
		dtext.font_family "Mazzard Regular"
		dtext.font_size $default_font_size
		dtext.fill [::theme background_text]
		dtext.disabledfill $disabled_colour
		dtext.anchor nw
		dtext.justify left
		
		dtext.fill.remark [::theme secondary]
		dtext.fill.error [::theme secondary_light]
		dtext.font_family.section_title "Mazzard Regular"
		
		dtext.font_family.page_title "Mazzard Regular"
		dtext.font_size.page_title 24
		dtext.fill.page_title [::theme background_text]
		dtext.anchor.page_title center
		dtext.justify.page_title center
	
		symbol.font_family "Font Awesome 5 Pro-Regular-400"
		symbol.font_size 20
		symbol.fill [::theme background_text]
		symbol.disabledfill $disabled_colour
		symbol.anchor nw
		symbol.justify left
		
		symbol.font_size.small 24
		symbol.font_size.medium 40
		symbol.font_size.big 55
		
		dbutton.debug_outline yellow
		dbutton.fill [::theme button]
		dbutton.fill.dsx_settings [::theme button]
		dbutton.disabledfill {}
		dbutton.outline white
		dbutton.disabledoutline $disabled_colour
		dbutton.activeoutline [::theme secondary]
		dbutton.width 0
		
		dbutton_label.pos {0.5 0.5}
		dbutton_label.pos.dsx_settings {0.6 0.5}
		dbutton_label.font_size [expr {$default_font_size}]
		dbutton_label.anchor center	
		dbutton_label.justify center
		dbutton_label.fill [::theme button_text_light]
		dbutton_label.disabledfill $disabled_colour
		
		dbutton_label1.pos {0.5 0.8}
		dbutton_label1.font_size [expr {$default_font_size-1}]
		dbutton_label1.anchor center
		dbutton_label1.justify center
		dbutton_label1.fill [::theme button_text_light]
		dbutton_label1.activefill [::theme button_text_light]
		dbutton_label1.disabledfill $disabled_colour
		
		dbutton_symbol.pos {0.2 0.5}
		dbutton_symbol.font_size 28
		dbutton_symbol.anchor center
		dbutton_symbol.justify center
		dbutton_symbol.fill [::theme button_text_light]
		dbutton_symbol.disabledfill [::theme primary_dark]
		
		dbutton.shape.insight_ok outline
		dbutton.width.insight_ok 4
		dbutton.arc_offset.insight_ok 20
		dbutton.bwidth.insight_ok 480
		dbutton.bheight.insight_ok 118
		dbutton_label.font_family.insight_ok "Mazzard Regular"
		dbutton_label.font_size.insight_ok 19
		
		dclicker.fill [::theme background]
		dclicker.disabledfill [::theme background_highlight]
		dclicker_label.pos {0.525 0.4}
		dclicker_symbol.pos {0.075 0.0}
		dclicker_symbol1.pos {0.275 0.0}
		dclicker_symbol2.pos {0.725 0.0}
		dclicker_symbol3.pos {0.925 0.0}
	
		dclicker_label.font_size 18
		dclicker_label.fill [::theme background_text]
		dclicker_label.anchor center
		dclicker_label.justify center
	
	
		entry.relief sunken
		entry.bg [::theme background]
		entry.disabledbackground $disabled_colour
		entry.width 2
		entry.foreground [::theme background_text]
		entry.font_size $default_font_size
			
		multiline_entry.relief sunken
		multiline_entry.foreground [::theme background_text]
		multiline_entry.bg [::theme background]
		multiline_entry.width 2
		multiline_entry.font_family "Mazzard Regular"
		multiline_entry.font_size $default_font_size
		multiline_entry.width 15
		multiline_entry.height 5
	
		dcombobox.relief sunken
		dcombobox.bg [::theme background]
		dcombobox.width 2
		dcombobox.font_family "Mazzard Regular"
		dcombobox.font_size $default_font_size
		
		dcombobox_ddarrow.font_size 24
		dcombobox_ddarrow.disabledfill $disabled_colour
		
		dcheckbox.font_family "Font Awesome 5 Pro"
		dcheckbox.font_size 18
		dcheckbox.fill [::theme background_text]
		dcheckbox.anchor nw
		dcheckbox.justify left
		
		dcheckbox_label.pos "en 30 -10"
		dcheckbox_label.anchor nw
		dcheckbox_label.justify left
		
		listbox.relief sunken
		listbox.borderwidth 1
		listbox.foreground [::theme background_text]
		listbox.background [::theme background]
		listbox.selectforeground [::theme background]
		listbox.selectbackground [::theme background_text]
		listbox.selectborderwidth 1
		listbox.disabledforeground $disabled_colour
		listbox.selectmode browse
		listbox.justify left
		
		listbox_label.pos "wn -10 0"
		listbox_label.anchor ne
		listbox_label.justify right
		
		listbox_label.font_family.section_title "Mazzard Regular"
		
		scrollbar.orient vertical
		scrollbar.width 120
		scrollbar.length 300
		scrollbar.sliderlength 120
		scrollbar.from 0.0
		scrollbar.to 1.0
		scrollbar.bigincrement 0.2
		scrollbar.borderwidth 1
		scrollbar.showvalue 0
		scrollbar.resolution 0.01
		scrollbar.background [::theme background_text]
		scrollbar.foreground white
		scrollbar.troughcolor [::theme background]
		scrollbar.relief flat
		scrollbar.borderwidth 0
		scrollbar.highlightthickness 0
		
		dscale.orient horizontal
		dscale.foreground "#4e85f4"
		dscale.background "#7f879a"
		dscale.sliderlength 75
		
		scale.orient horizontal
		scale.foreground "#FFFFFF"
		scale.background [::theme background_text]
		scale.troughcolor [::theme background]
		scale.showvalue 0
		scale.relief flat
		scale.borderwidth 0
		scale.highlightthickness 0
		scale.sliderlength 125
		scale.width 150
		
		drater.fill [::theme secondary] 
		drater.disabledfill $disabled_colour
		drater.font_size 24
		
		rect.fill.insight_back_box [::theme background]
		rect.width.insight_back_box 0
		line.fill.insight_back_box_shadow [::theme background]
		line.width.insight_back_box_shadow 2
		rect.fill.insight_front_box [::theme background]
		rect.width.insight_front_box 0
		
		graph.plotbackground [::theme background]
		graph.borderwidth 1
		graph.background white
		graph.plotrelief raised
		graph.plotpady 0 
		graph.plotpadx 10
		
		text.bg [::theme background]
		text.font_size 16
		text.relief flat
		text.highlightthickness 1
	}]
	
	# Styles for the history viewer
	dui aspect set [subst {
		dbutton.fill.hv_done_button [::theme button_tertiary]
	}]
}

# Define the DUI MimojaCafe theme
proc init_MimojaCafe_dui_theme {} {
	dui theme add MimojaCafe
	dui theme set MimojaCafe
	
	set disabled_colour "#35363d"
	set default_font_size 15

#	dialog_page.bg_shape round_outline
#	dialog_page.bg_color [::theme button]
#	dialog_page.fill [::theme button]
#	dialog_page.outline [::theme background_text]
#	dialog_page.width 1
	
	dui aspect set [subst {
		page.bg_img {}
		page.bg_color [::theme background]

		dialog_page.bg_shape round_outline
		dialog_page.bg_color [::theme background]
		dialog_page.fill [::theme background]
		dialog_page.outline [::theme background_text]
		dialog_page.width 4
		
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
		
		dbutton.shape.insight_ok round
		dbutton.width.insight_ok 4
		dbutton.radius.insight_ok 30
		dbutton.bwidth.insight_ok 480
		dbutton.bheight.insight_ok 118
		dbutton_label.font_family.insight_ok "Mazzard Regular"
		dbutton_label.font_size.insight_ok 19
		
		dclicker.fill {}
		dclicker.disabledfill {}
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
		multiline_entry.wrap word
	
		dcombobox.relief sunken
		dcombobox.bg [::theme background]
		dcombobox.width 2
		dcombobox.font_family "Mazzard Regular"
		dcombobox.font_size $default_font_size
		
		dbutton_dda.shape {}
		dbutton_dda.fill {}
		dbutton_dda.bwidth 70
		dbutton_dda.bheight 65
		dbutton_dda.symbol "sort-down"
		
		dbutton_dda_symbol.pos {0.5 0.15}
		dbutton_dda_symbol.font_size 24
		dbutton_dda_symbol.anchor center
		dbutton_dda_symbol.justify center
		dbutton_dda_symbol.fill [::theme background_text]
		dbutton_dda_symbol.disabledfill $disabled_colour
		
		dcheckbox.font_family "Font Awesome 5 Pro"
		dcheckbox.font_size 18
		dcheckbox.fill [::theme background_text]
		dcheckbox.disabledfill $disabled_colour
		dcheckbox.anchor nw
		dcheckbox.justify left
		
		dcheckbox_label.pos "e 30 0"
		dcheckbox_label.anchor w
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
		text.foreground [::theme background_text]
		text.font_size 16
		text.relief flat
		text.highlightthickness 1
		text.wrap word
		
		dbutton.shape.dne_clicker round 
		dbutton.bwidth.dne_clicker 120 
		dbutton.bheight.dne_clicker 140 
		dbutton.radius.dne_clicker 20 
		dbutton.anchor.dne_clicker center
		dbutton_symbol.pos.dne_clicker {0.5 0.4} 
		dbutton_symbol.anchor.dne_clicker center 
		dbutton_symbol.font_size.dne_clicker 20
		dbutton_label.pos.dne_clicker {0.5 0.8} 
		dbutton_label.font_size.dne_clicker 10 
		dbutton_label.anchor.dne_clicker center

		dbutton.shape.dne_pad_button round 
		dbutton.bwidth.dne_pad_button 280 
		dbutton.bheight.dne_pad_button 220 
		dbutton.radius.dne_pad_button 20 
		dbutton.anchor.dne_pad_button nw
		dbutton_label.pos.dne_pad_button {0.5 0.5} 
		dbutton_label.font_family.dne_pad_button notosansuibold 
		dbutton_label.font_size.dne_pad_button 24 
		dbutton_label.anchor.dne_pad_button center
	}]
	
	# Styles for the history viewer
	dui aspect set [subst {
		dbutton.fill.hv_done_button [::theme button_tertiary]
	}]
	
	# Menu dialogs
	dui aspect set [subst {
		dtext.font_size.menu_dlg_title +1
		dtext.anchor.menu_dlg_title center
		dtext.justify.menu_dlg_title center
		dtext.fill.menu_dlg_title [::theme background_text]
		
		dbutton.shape.menu_dlg_close rect 
		dbutton.fill.menu_dlg_close {} 
		dbutton.symbol.menu_dlg_close times
		dbutton_symbol.pos.menu_dlg_close {0.5 0.5}
		dbutton_symbol.anchor.menu_dlg_close center
		dbutton_symbol.justify.menu_dlg_close center
		dbutton_symbol.fill.menu_dlg_close [::theme primary_dark]
		
		dbutton.shape.menu_dlg_btn rect
		dbutton.fill.menu_dlg_btn {}
		dbutton.disabledfill.menu_dlg_btn {}
		dbutton_label.pos.menu_dlg_btn {0.25 0.4} 
		dbutton_label.anchor.menu_dlg_btn w
		dbutton_label.fill.menu_dlg_btn [::theme background_text]
		dbutton_label.disabledfill.menu_dlg_btn $disabled_colour
		
		dbutton_label1.pos.menu_dlg_btn {0.25 0.78} 
		dbutton_label1.anchor.menu_dlg_btn w
		dbutton_label1.fill.menu_dlg_btn #bbb
		dbutton_label1.disabledfill.menu_dlg_btn $disabled_colour
		dbutton_label1.font_size.menu_dlg_btn -3
		
		dbutton_symbol.pos.menu_dlg_btn {0.15 0.5} 
		dbutton_symbol.anchor.menu_dlg_btn center
		dbutton_symbol.fill.menu_dlg_btn [::theme primary_dark]
		dbutton_symbol.disabledfill.menu_dlg_btn $disabled_colour
		
		line.fill.menu_dlg_sepline #ddd
		line.width.menu_dlg_sepline 1
		
		dtext.fill.menu_dlg [::theme background_text]
		dtext.disabledfill.menu_dlg $disabled_colour
		dcheckbox.fill.menu_dlg [::theme background_text]
		dcheckbox.disabledfill.menu_dlg $disabled_colour
		dcheckbox_label.fill.menu_dlg [::theme background_text]
		dcheckbox_label.disabledfill.menu_dlg $disabled_colour
		
		dbutton.shape.menu_dlg round
		dbutton.radius.menu_dlg 25
		dbutton.fill.menu_dlg [::theme button_tertiary]
		dbutton_label.font_family.menu_dlg "Mazzard Regular"
	}]
	
	
}

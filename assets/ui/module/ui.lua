local U={}
local rendercam = require "rendercam.rendercam"
local Button=require "assets.ui.module.button"
local Card=require  "assets.ui.module.card"
local Item = require "assets.ui.module.item"
local Slot = require "assets.ui.module.slot"
local Text = require "assets.ui.module.text"
local Slider=require  "assets.ui.module.slider"
local BOARD = "/board/board"
	function U.init(self)
		self.button={}
		self.card={}
		self.text={}
		self.item={}
		self.slot={}
		self.slider={}
		self.slider_value={}
		self.initial_mouse_pos=vmath.vector3()
		self.initial_value=0
	end
	function U.create_text(self,text,id,option)
		table.insert(self.text, Text.create(text,content,option))
	end
	function U.create_item(self,item,id,type,slot)
		table.insert(self.item, Item.create(item,id,type,slot))
	end
	function U.create_slot(self,slot,id)
		table.insert(self.slot, Slot.create(slot,id))
	end
	function U.create_button(self,button,id)
		table.insert(self.button, Button.create(button,id))
	end
	function U.create_card(self,card,id,value)
		table.insert(self.card, Card.create(card,id,value))
	end
	function U.create_slider(self,slider_button,slider_bar,content,id,option)
		table.insert(self.slider, Slider.create(slider_button,slider_bar,content,id,option))
	end
	function delete(t,id)
		for i = 1, #t do
			if t[i].id == id then
				gui.delete_node(t[i].node)
				table.remove(t,i)
				break
			end
		end
	end
	local function input_item(self, action_id, action, item)
		if action.pressed then
			if gui.pick_node(item.node, action.x, action.y) then
				item.clicked=true
			end
		elseif action.released then
			msg.post("/touch", "item_droped")
			if item.clicked then
				if self.target then
					for j = 1, #self.slot do
						if self.slot[j].node == item.slot then
							self.slot_content[j]=false
							break
						end
					end
					item:drop(self.target)
					delete(self.item,item.id)
					return 1
				else
					for i = 1, #self.item do
						if gui.pick_node(self.item[i].node, action.x, action.y) then
							if self.item[i] ~= item then
								self.item[i].slot=item.slot
								self.item[i]:move_coordinate(gui.get_position(self.item[i].slot))
								print("switch")
								break
							end
						end
					end
					for i = 1, #self.slot do
						if gui.pick_node(self.slot[i].node, action.x, action.y) then
							for j = 1, #self.slot do
								if self.slot[j].node == item.slot then
									self.slot_content[j]=false
									break
								end
							end
							item.slot=self.slot[i].node
							self.slot_content[i]=true
							break
						end
					end
					item:move_coordinate(gui.get_position(item.slot))
				end
				item.clicked=false
				return 0
			end
		else
			if item.clicked then
				local touch_x,touch_y = rendercam.screen_to_gui(action.screen_x, action.screen_y,rendercam.GUI_ADJUST_FIT)
				msg.post("/touch", "item_picked")
				item:move_coordinate(vmath.vector3(touch_x,touch_y,1))
			end
		end
		
	end
	
	local function input_button(self, action_id, action, button)
		if action.pressed then
			if gui.pick_node(button.node, action.x, action.y) then
				button:pressed()
				return 0
			end
		elseif action.released then
			if gui.pick_node(button.node, action.x, action.y) then
				button:released()
				return 0
			end
		else	

		end
	end
	local function input_slider(self, action_id, action, slider)
		local pos = vmath.vector3(action.x,action.y,0)
		if action.pressed then
			if gui.pick_node(slider.node[1], action.x, action.y) then
				slider.clicked=true
				local touch_x,touch_y = rendercam.screen_to_gui(action.screen_x, action.screen_y,rendercam.GUI_ADJUST_FIT)
				self.initial_mouse_pos=vmath.vector3( touch_x,0,0)
				self.initial_pos=gui.get_position(slider.node[1])
				return nil
			end
		elseif action.released then
			if slider.clicked then
				slider.clicked=false
				return slider.value
			end
		else
			if slider.clicked then
				local touch_x,touch_y = rendercam.screen_to_gui(action.screen_x, action.screen_y,rendercam.GUI_ADJUST_FIT)
				slider:change_pos(vmath.vector3(touch_x,0,0)+self.initial_pos-self.initial_mouse_pos)
			end
		end
	end
	function U.on_input(self, action_id, action)
		if action_id == hash("touch") then
			if #self.button>0 then
				for i=1,#self.button do
					local button = self.button[i]
					input_button(self, action_id, action, button)
				end
			end
			if #self.slider>0 then
				for i=1,#self.slider do
					local slider = self.slider[i]
					input_slider(self, action_id, action, slider)
				end
			end
			if #self.item>0 then
				for i=1,#self.item do
					local item = self.item[i]
					local result = input_item(self, action_id, action, item)
					if result== 1 then
						break
					end
				end
			end
			
		end
	end

	function U.set_card_texture(card)
		card:set_texture()
	end
	function U.delete_all_card(self)
		for i = 1, #self.card do
			gui.delete_node(self.card[i].node)
		end
		self.card={}
	end
	function U.hide_all(self)
		for i = 1, #self.button do
			local button = self.button[i]
			button.hide()
		end
		for i = 1, #self.card do
			local card = self.card[i]
			card.hide()
		end
		for i = 1, #self.slider do
			local slider = self.slider[i]
			slider.hide()
		end
	end
	function U.show_all(self)
		for i = 1, #self.button do
			local button = self.button[i]
			button.show()
		end
		for i = 1, #self.card do
			local card = self.card[i]
			card.show()
		end
		for i = 1, #self.slider do
			local slider = self.slider[i]
			slider.show()
		end
	end
return U
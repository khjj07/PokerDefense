local S={}
function S.create(slider_button,slider_bar,content,id,value_max,value_min,value,size_max,size_min,clicked)
	local new_slider={
		node={slider_button,slider_bar},
		content=content or nil, 
		id=id,
		value_max=100,
		value_min= 0,
		value= 50,
		size_max=size_max or 400,
		size_min=size_min or 0,
		clicked=false,
		}
	function new_slider:hide()
		gui.set_enabled(new_slider.node, false)
	end
	function new_slider:show()
		gui.set_enabled(new_slider.node, true)
	end
	function new_slider:change_pos(target)
		local size = gui.get_size(content[1])
		if new_slider.size_min>target.x then
			target.x=new_slider.size_min
		elseif new_slider.size_max<target.x then
			target.x=new_slider.size_max
		end
		size.x=target.x
		gui.set_position(new_slider.node[1], target)
		print(gui.get_position(new_slider.node[1]))
		gui.set_size(new_slider.content[1],size)
		new_slider.value=target.x/(new_slider.size_max-new_slider.size_min)*(new_slider.value_max-new_slider.value_min)
		msg.post(".", "slider_change",{id=new_slider.id})
	end
	function new_slider:set_value(value)
		local target = gui.get_position(new_slider.node[1])
		local size = gui.get_size(content[1])
		new_slider.value=value
		if value>new_slider.value_max then
			new_slider.value=new_slider.value_max
		elseif value<new_slider.value_min then
			new_slider.value=new_slider.value_min
		end
		target.x = new_slider.value/(new_slider.value_max-new_slider.value_min)*(new_slider.size_max-new_slider.size_min)
		size.x=target.x
		gui.set_position(new_slider.node[1], target)
		gui.set_size(new_slider.content[1],size)
		msg.post(".", "slider_change",{id=new_slider.id})
	end
	return new_slider
end
return S
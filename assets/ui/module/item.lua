local I={}

function I.create(item,id,type,slot)
	local new_item={node=item,id=id,type=type,slot=slot,clicked=false}
	function new_item:hide()
		gui.set_enabled(new_item.node, false)
	end
	function new_item:show()
		gui.set_enabled(new_item.node, true)
	end
	function new_item:move_coordinate(pos)
		gui.set_position(new_item.node, pos)
	end
	function new_item:drop(target)
		msg.post(target, "put_item",{item=new_item.type})
	end
	function new_item:set_texture(texture)
		gui.set_texture(new_item.node, "item")
		gui.play_flipbook(new_item.node, texture)
	end
	return new_item
end
return I
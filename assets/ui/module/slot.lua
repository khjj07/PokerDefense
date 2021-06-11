local S={}
function S.create(slot,id)
	local new_slot={node=slot,id=id}
	function new_slot:hide()
		gui.set_enabled(new_slot.node, false)
	end
	function new_slot:show()
		gui.set_enabled(new_slot.node, true)
	end
	return new_slot
end
return S
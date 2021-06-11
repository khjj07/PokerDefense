local C={}

function C.create(card,id,value)
	local new_card={node=card,id=id,value=value or nil,enabled=true}
	function new_card:hide()
		gui.set_enabled(new_card.node, false)
		new_card.enabled=false
	end
	function new_card:show()
		gui.set_enabled(new_card.node, true)
		new_card.enabled=true
	end
	function new_card:set_texture()
		gui.set_texture(new_card.node, "card")
		if new_card.value then
			gui.play_flipbook(new_card.node, "card"..new_card.value[1]..new_card.value[2])
		else
			gui.play_flipbook(new_card.node, "cardBack_red5")
		end
	end
	return new_card
end

return C
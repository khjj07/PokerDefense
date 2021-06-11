local B={}

function B.create(button,id)
	local new_button={node=button,id=id,enabled=true}
	function new_button:hide()
		gui.set_enabled(new_button.node, false)
		new_button.enabled=false
	end
	function new_button:show()
		gui.set_enabled(new_button.node, true)
		new_button.enabled=true
	end
	function new_button:pressed()
		if new_button.show then
			msg.post(".", "button_pressed", {id=id})
		end
	end
	function new_button:released()
		if new_button.show then
			msg.post(".", "button_released", {id=id})
		end
	end
	return new_button
end
return B
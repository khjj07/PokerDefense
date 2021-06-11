local T={}

function T.create(text,id)
	local new_text={node=item,id=id}
	function new_text:hide()
		gui.set_enabled(new_text.node, false)
	end
	function new_text:show()
		gui.set_enabled(new_text.node, true)
	end
	function new_text:set_text(content)
		gui.set_text(new_text.node, content)
	end
	return new_text
end
return T
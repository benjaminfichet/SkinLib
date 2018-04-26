struct SkinHelpers (



	/* Function: isSkinModifierSelected

	   Checks if the Skin modifier <skin_name> is selected.

	   Parameters:

	    	skin_name: - Optional - Defaults to "Skin"

	   Returns:

	    	True or False if the skin was selectionned or not
	*/
	fn isSkinModifierSelected skin_name:undefined = (
		local ret = ReturnCode.new (selection.count == 1) err_reason:"Invalid node selection!"
		if ret.ret then (

			local selectedMod = modPanel.getCurrentObject()
			ret = ReturnCode.new (classof(selectedMod) == Skin) err_reason:"Invalid modifier selection! (needs a Skin)"

			if (ret.ret and (skin_name != undefined)) then (
				ret = ReturnCode.new ((selectedMod.name as name) == (skin_name as name)) err_reason:("Invalid modifier selection! (needs a Skin with name:"+skin_name+")")
			)
		)
		ret
	),	



	/* Function: selectSkinmod

	   Selects the given skin modifier in the modify panel.

	   Parameters:

	    	skn - The skin modifier to select.
	    	node_index:1 - In canse there is multiple nodes referencing the skin, set which index to select

	   Returns:

	    	True or False if the skin was selectionned or not
	*/
	fn selectSkinModifier skn node_index:1 = (
		local nd = refs.dependentNodes skn
		local ret = ReturnCode.new (nd!=undefined and nd.count > 0) err_reason:"Invalid node!"
		if ret.ret then (
			nd = nd[node_index]
			max modify mode
			clearSelection()
			select nd
			setCommandPanelTaskMode #modify
			modPanel.setCurrentObject skn
			ret = true
		)
		ret
	),

	/* Function: fn prepareCommandPanelToNewSkin nd = ()

	   Prepares the command panel to the creation of a new skin modifier for the given <<nd>> by selecting the baseobject.
	   If a #Morpher is present on the node, the morpher will be selected as the baseobject.

	   Parameters:

	    	nd - The node to host a new skin.

	   Returns:

	    	void
	*/
	fn prepareCommandPanelToNewSkin nd = (
		modPanel.setCurrentObject nd.baseObject node:nd ui:true
		if nd.modifiers[#Morpher] != undefined do modPanel.setCurrentObject nd.Morpher node:nd ui:true
	),



	fn integerAsBoolean i = (
		local ret = false
		if i > 0 then (ret = true)
		ret
	),

	fn booleanAsInteger b negativeOne:false = (
		local ret = -1
		if b == true  then ret = 1 else (if negativeOne then (ret = -1) else (ret = 0))
		ret
	),


	on create do ()
)
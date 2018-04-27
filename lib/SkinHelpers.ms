/* Class: SkinHelpers

	Exposes various methods to work with 3dsmax's Skin modifier.
*/
struct SkinHelpers (



	/* Function: isSkinModifierSelected

	   Checks if the Skin modifier *<skin_name>* is selected.

	   Parameters:

	    	skin_name: Optional

	   Returns:

	    	True or False if the skin is selected or not
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



	/* Function: selectSkinModifier

	   Selects the given skin modifier in the modify panel.

	   Parameters:

	    	skn - The skin modifier to select.
	    	node_index:1 - In case there is multiple nodes referencing the skin, set which one to select

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

	/* Function: prepareCommandPanelToNewSkin

	   Prepares the command panel to the creation of a new skin modifier for the given <nd|node> by selecting the baseobject.
	   If a #Morpher is present on the node, the morpher will be selected as the baseobject so that any skin added will be on top of it.

	   Parameters:

	    	nd - The node to host a new skin.

	   Returns:

	    	void
	*/
	fn prepareCommandPanelToNewSkin nd = (
		modPanel.setCurrentObject nd.baseObject node:nd ui:true
		if nd.modifiers[#Morpher] != undefined do modPanel.setCurrentObject nd.Morpher node:nd ui:true
	),


	/* Function: integerAsBoolean <i>

	   Returns a boolean for a given integer. ie  (i > 0) = true, ( i < 0 ) = false
		--- Code
		if i > 0 then (true) else (false)
		---


	   Parameters:

	    	i - The integer to convert from

	   Returns:

	    	true/false
	*/
	fn integerAsBoolean i = (
		local ret = false
		if i > 0 then (ret = true)
		ret
	),


	/* Function: booleanAsInteger

	   Returns an integer for a given boolean. 

		--- Code
		if b == true then (true_int) else (false_int)
		---

	   Parameters:

	    	b - The boolean to convert from
	    	true_int:1  - The integer value to return if true (defaults to 1)
	    	false_int:0 - The integer value to return if false (defaults to 0)

	   Returns:

	    	integer
	*/
	fn booleanAsInteger b true_int:1 false_int:0 = (
		local ret = -1
		if b == true  then (ret = true_int) else (ret = false_int)
		ret
	),


	on create do ()
)
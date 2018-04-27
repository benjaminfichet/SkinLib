--SkinOwner.ms
struct SkinOwner (
	ownerNode     = undefined,
	skinModifier  = undefined,

	fn initFromSkin skn node_index:1 = (
		local cls_of = (classof skn)
		local ret = ReturnCode.new (cls_of == Skin) err_reason:"SkinOwner.initFromSkin requires a (Skin) parameter."
		if ret.ret then (
			
			-- Init skin
			local initSkin = true
			this.skinModifier = skn

			-- Init node
			local ret = this._getSkinNode skn node_index:node_index
			if ret.ret then (
				this.ownerNode = ret.data
			)
		)
		ret
	),

	fn initFromNode nd skin_name:#Skin = (
		local ret = ReturnCode.new (isValidNode nd) err_reason:"SkinOwner.initFromNode requires a validNode!"
		if ret.ret then (
			this.ownerNode = nd

			local ret = this._getSkinModifier nd skin_name:skin_name
			if ret.ret then (
				this.skinModifier = ret.data
			)
		)
		ret
	),

private
	fn _getSkinNode skn node_index:1 = (
		local rdeps = refs.dependentNodes this.skinModifier

		-- if (rdeps.count > 0) evaluates to true, ok_data will be filled, if false, err_reason will be filled, we return all
		ReturnCode.new (rdeps.count > 0) \
						err_reason:"Unable to find the node for the given Skin!" \
						ok_data:rdeps[node_index]
	),

	fn _getSkinModifier node skin_name:#Skin = (
		local sMod = node.modifiers[skin_name]
		ReturnCode.new ((classof sMod) == Skin) \
						err_reason:("Unable to find the Skin for the given (Skin) at #"+skin_name) \
						ok_data:sMod
	),



public
	on create do ()
)

s = SkinOwner()
s.initFromNode $
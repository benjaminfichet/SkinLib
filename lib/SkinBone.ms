struct SkinBone (

public

	-- Variable: _listID
    -- The list index for this bone
	_listID       = undefined,

	-- Variable: _boneID
    -- The true bone index
	_boneID       = undefined,

	-- Variable: _name
    -- The bone name
	_name         = undefined,


	-- Contructor parameters
	init_skin_modifier = undefined,

	-- Constructor
	on create do (
		if this.init_skin_modifier != undefined then (this._skinModifier = this.init_skin_modifier)
	),

	-- Initializer
	fn init bone_index: list_index: bone_name: = (
		local bi_test = (bone_index != unsupplied) and (classof(bone_index as integer) == integer)
		local li_test = (list_index != unsupplied) and (classof(list_index as integer) == integer)
		local nm_test = (bone_name != unsupplied) and (classof(bone_name as name) == Name)

		local ret = ReturnCode.new (bi_test or li_test or nm_test) err_reason:"At least one of (<bone_name> <bone_index> <list_index>) must be passed to SkinBone.new()"
		if ret.ret then (
			if bi_test then (ret = this.init_by_bone_id bone_index)
			if li_test then (ret = this.init_by_list_id list_index)
			if nm_test then (ret = this.init_by_bone_name bone_name)
		)
		ret
	),


	fn asString = (
		local s = "" as StringStream
		format "bone_id:% - list_id:% - bone_name:#%" (this._boneID as string) (this._listID as string) (this._name as string) to:s
		(s as string)
	),

	fn _getSkinModifier    = (this._skinModifier),
	fn _setSkinModifier sm = (this._skinModifier = sm),

private
	-- tRUE INITIALIZERS
	fn init_by_bone_id   id = (
		local ret = this._is_range_valid_index id
		if ret.ret then (
			this._boneID = id
			this._listID = this._skinModifier.ops.GetListIDByBoneID id
			this._name   = (this._skinModifier.ops.GetBoneName id) as name
		)
		ret
	),
	fn init_by_list_id   id = (
		local ret = this._is_range_valid_index id
		if ret.ret then (
			this._listID = id 
			this._boneID = this._skinModifier.ops.GetBoneIDByListID id
			this._name   = (this._skinModifier.ops.GetBoneName this._boneID) as name
		)
		ret
	),
	fn init_by_bone_name nm = (
		local ret = ReturnCode.new (classof(nm) == Name or classof(nm) == String) err_reason:"Invalid arg passed SkinBone.init_by_bone_name!"
		if ret.ret then (
			local idx = -1
			for i=1 to (this._skinModifier.ops.GetNumberBones()) do (
				if (((this._skinModifier.ops.GetBoneName i) as name) == nm) then (idx = i)
			)

			ret = ReturnCode.new (idx > 0) -- err_reason:"Unable to initialize from: " + nm as string + " (bone not found)!"
			if ret.ret then (
				ret = this._is_range_valid_index idx

				this._name   = nm as name
				this._boneID = idx
				this._listID = this._skinModifier.ops.GetListIDByBoneID idx
			)
		)
		ret
	),
	fn _is_range_valid_index i = (ReturnCode.new ((i > 0) and (i <= this._skinModifier.ops.GetNumberBones())) err_reason:"Invalid bone index range!"),


private
	_skinModifier = undefined,

	fn end = ()
)


--skMod = SkinModifier()
--res = skMod.init ($ch_lewis_b00a_mdl_body.modifiers[#Skin]) selected_vertices_only:true
--
--skb = SkinBone _skinModifier:skMod
--
--skb.init bone_index:1
--skb.init list_index:1
--skb.init bone_name:#ch_lewis_b00a_ctrl_l_elbow_art_bot
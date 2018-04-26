struct SkinBone (
private
	_owner_skinmod = undefined,


public

	-- Variable: _name
    -- The bone name
	_name         = undefined,

	-- Variable: _boneID
    -- The true bone index
	_boneID       = undefined,


	-- Variable: _listID
    -- The list index for this bone
	_listID       = undefined,


	-- Contructor parameters
	init_skin_modifier = undefined,

	-- Constructor
	on create do (
		if this.init_skin_modifier != undefined then (this._owner_skinmod = this.init_skin_modifier)
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

	-- Returns the SkinVertex(s) influenced by this SkinBone
	fn getInfluencedVertices = (
		local ret = ReturnCode.new (this._owner_skinmod != undefined) err_reason:"SkinBone.getInfluencedVertices() need _owner_skinmod to be defined! (_setSkinModifier())"
		if ret.ret then (
			local verts = #()
			for skinVert in this._owner_skinmod._vertices do (
				for vBone in skinVert._bones do (
					if (vBone._name as name) == (this._name as name) then (
						append verts skinVert
					) 
				)
			)
			ret.data = verts
		)
		ret
	),

	fn asString = (
		local s = "" as StringStream
		format "bone_id:% - list_id:% - bone_name:#%" (this._boneID as string) (this._listID as string) (this._name as string) to:s
		(s as string)
	),

	-- tRUE INITIALIZERS
	fn init_by_bone_id   id = (
		local ret = this._is_range_valid_index id
		if ret.ret then (
			this._boneID = id
			this._listID = this._owner_skinmod.ops.GetListIDByBoneID id
			this._name   = (this._owner_skinmod.ops.GetBoneName id) as name
		)
		ret
	),
	fn init_by_list_id   id = (
		local ret = this._is_range_valid_index id
		if ret.ret then (
			this._listID = id 
			this._boneID = this._owner_skinmod.ops.GetBoneIDByListID id
			this._name   = (this._owner_skinmod.ops.GetBoneName this._boneID) as name
		)
		ret
	),
	fn init_by_bone_name nm = (
		local ret = ReturnCode.new (classof(nm) == Name or classof(nm) == String) err_reason:"Invalid arg passed SkinBone.init_by_bone_name!"
		if ret.ret then (
			local idx = -1
			for i=1 to (this._owner_skinmod.ops.GetNumberBones()) do (
				if (((this._owner_skinmod.ops.GetBoneName i) as name) == nm) then (idx = i)
			)

			ret = ReturnCode.new (idx > 0) -- err_reason:"Unable to initialize from: " + nm as string + " (bone not found)!"
			if ret.ret then (
				ret = this._is_range_valid_index idx

				this._name   = nm as name
				this._boneID = idx
				this._listID = this._owner_skinmod.ops.GetListIDByBoneID idx
			)
		)
		ret
	),

	fn _getSkinModifier    = (this._owner_skinmod),
	fn _setSkinModifier sm = (this._owner_skinmod = sm),

private
	fn _is_range_valid_index i = (ReturnCode.new ((i > 0) and (i <= this._owner_skinmod.ops.GetNumberBones())) err_reason:"Invalid bone index range!"),

	fn end = ()
)


--skMod = SkinModifier()
--res = skMod.init ($ch_lewis_b00a_mdl_body.modifiers[#Skin]) selected_vertices_only:false
--
--skb = SkinBone init_skin_modifier:skMod
--
--skb.init bone_index:1
--skb.init list_index:1
----skb.init bone_name:#ch_lewis_b00a_help_spine_bone_02
--skb.getInfluencedVertices()
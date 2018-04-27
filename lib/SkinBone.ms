/* Class: SkinBone

	Represents a Bone of a Skin modifier.
*/
struct SkinBone (
private

    -- Variable: _skInt
    -- The SkinInterface owning this SkinBone
	_skInt = undefined,


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

	-- Constructor: Constructor<init_skin_modifier:>
	-- SkinBone's _skInt is automatically set with <init_skin_modifier:> if it is passed at creation. ie.: n = SkinBone init_skin_modifier:theStruct
	--------------------------------------------------------------------------
	on create do (
		if this.init_skin_modifier != undefined then (this._skInt = this.init_skin_modifier)
	),


	-- Function: init(bone_index: / list_index: / bone_name:)
	-- 	Inits this SkinBone, filling all data. At least one of the parameter must be passed to the function!
	--
	-- Parameters:
	-- 	bone_index: - <integer>     The bone_id   to init from
	-- 	list_index: - <integer>     The list_id   to init from
	-- 	bone_name:  - <string/name> The bone_name to init from
	--------------------------------------------------------------------------
	fn init bone_index: list_index: bone_name: SkinInterface: = (

		if ((SkinInterface == unsupplied) and (this._skInt == undefined)) then (throw "SkinBone._skInt must be set!")

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

	-- Function: getInfluencedVertices()
	-- 	Returns an array of SkinVertex(s) influenced by this SkinBone
	--------------------------------------------------------------------------
	fn getInfluencedVertices = (
		local ret = ReturnCode.new (this._skInt != undefined) err_reason:"SkinBone.getInfluencedVertices() need _skInt to be defined! (_setSkinInterface())"
		if ret.ret then (
			local verts = #()
			for skinVert in this._skInt._vertices do (
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

	-- Function: asString()
	-- 	Returns a string representing this SkinBone
	--------------------------------------------------------------------------
	fn asString = (
		local s = "" as StringStream
		format "bone_id:% - list_id:% - bone_name:#%" (this._boneID as string) (this._listID as string) (this._name as string) to:s
		(s as string)
	),

	-- Function: init_by_bone_id(id)
	-- 	Inits this SkinBone from a bone_id
	--------------------------------------------------------------------------
	fn init_by_bone_id   id = (
		local ret = this._is_range_valid_index id
		if ret.ret then (
			this._boneID = id
			this._listID = (skinOps.GetListIDByBoneID this._skInt._skin id) --this._skInt.ops.GetListIDByBoneID id
			this._name   = (skinOps.GetBoneName this._skInt._skin id -1) as name --(this._skInt.ops.GetBoneName id) as name
		)
		ret
	),

	-- Function: init_by_list_id(id)
	-- 	Inits this SkinBone from a list_id
	--------------------------------------------------------------------------
	fn init_by_list_id   id = (
		local ret = this._is_range_valid_index id
		if ret.ret then (
			this._listID = id 
			this._boneID = (skinOps.GetBoneIDByListID this._skInt._skin id) --this._skInt.ops.GetBoneIDByListID id
			this._name   = (skinOps.GetBoneName this._skInt._skin this._boneID -1) as name--(this._skInt.ops.GetBoneName this._boneID) as name
		)
		ret
	),

	-- Function: init_by_bone_name(nm)
	-- 	Inits this SkinBone from a bone_name
	--------------------------------------------------------------------------
	fn init_by_bone_name nm = (
		local ret = ReturnCode.new (classof(nm) == Name or classof(nm) == String) err_reason:"Invalid arg passed SkinBone.init_by_bone_name!"
		if ret.ret then (
			local idx = -1
			for i=1 to (skinOps.GetNumberBones this._skInt._skin) do (
			--for i=1 to (this._skInt.ops.GetNumberBones()) do (
				if (((skinOps.GetBoneName this._skInt._skin i -1) as name) == nm) then (idx = i)
				--if (((this._skInt.ops.GetBoneName i) as name) == nm) then (idx = i)
			)

			ret = ReturnCode.new (idx > 0) -- err_reason:"Unable to initialize from: " + nm as string + " (bone not found)!"
			if ret.ret then (
				ret = this._is_range_valid_index idx

				this._name   = nm as name
				this._boneID = idx
				this._listID = skinOps.GetListIDByBoneID this._skInt._skin idx --this._skInt.ops.GetListIDByBoneID idx
			)
		)
		ret
	),

	-- Function: _getSkinInterface()
	-- 	A SkinBone object needs a SkinInterface in ._skInt, this is how to get it
	--------------------------------------------------------------------------
	fn _getSkinInterface    = (this._skInt),

	-- Function: _setSkinInterface(sm)
	-- 	A SkinBone object needs a SkinInterface in ._skInt, this is how to set it
	--------------------------------------------------------------------------
	fn _setSkinInterface sm = (this._skInt = sm),



	fn isBoneSelected = (skinOps.isBoneSelected this._skInt._skin this._boneID),
	

private

    -- Function: _is_range_valid_index(i)
	-- 	Checks that the given id is in the range 0..bone_count
	--------------------------------------------------------------------------
	fn _is_range_valid_index i = (ReturnCode.new ((i > 0) and (i <= (skinOps.GetNumberBones this._skInt._skin))) err_reason:"Invalid bone index range!"),

	fn end = ()
)


skMod = SkinInterface()
res = skMod.init ($ch_lewis_b00a_mdl_body.modifiers[#Skin]) selected_vertices_only:false
--
skb = SkinBone init_skin_modifier:skMod

skb.init bone_index:1
--skb.init list_index:1
----skb.init bone_name:#ch_lewis_b00a_help_spine_bone_02
--skb.getInfluencedVertices()
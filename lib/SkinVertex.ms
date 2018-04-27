(
	local modo = Modolize init_path:(DEVTREE_BASEPATH)
	modo.filein "SkinLib.lib.SkinVertexBone"
)

/* Sound: Hello */

/* Class: SkinVertex

	Represents a vertex of a Skin modifier.
*/
struct SkinVertex (

	-- Variable: _skinModifier 
	-- Mother instance of type SkinModifier
	_skinModifier = undefined,

	-- Variable: init_id
    -- The constructor optional parameter
	init_id   = undefined,

	-- Variable: _v
    -- Vertex index
	_v          = undefined,

	-- Variable: _skin
    -- Owning Skin modifier
	_skin       = undefined,

	-- Variable: _node
    -- Owning node
	_node       = undefined,

	-- Variable: _selected
    -- Is the vertex selected ?
	_selected   = undefined,

	-- Variable: _normalized
    -- Is the vertex normalized ?
	_normalized = undefined,

	-- Variable: _bones
    -- The SkinVertexBone(s) array
	_bones      = undefined,

	-- Variable: _bonesCount
    -- How many bones do skin this vertex ?
	_bonesCount = undefined,

	/* Function: Constructor <init_id:>

	   Parameters:

	    	init_id: - The vertex's id to init from.

	    Notes:

    		If init_id: param is given at SkinVertex's creation, the init function is automatically called!
    		--- Code
		SkinVertex init_id:theID; -- Will call (this.init this.init_id)
		---

	   Returns:

	    	void
	*/
	on create do (
		this._bones    = #()
		if this.init_id != undefined then (
			this.init this.init_id
		)
	),
  

	/* Function: init

	    Init function, to be called after creation.
	    Inits this SkinVertex, filling all data and loading SkinVertexBone(s).

	   Parameters:

	    	index: - The vertex's index to init from.

	   Returns:

	    	<ReturnCode>
	*/
	fn init index = (
		local ret = SkinHelpers.isSkinModifierSelected()
		if ret.ret then (

			-- Load Vertex infos
			--------------------------------------------------------------------------
			this._v          = index
			this._skin       = modPanel.getCurrentObject()
			this._node       = selection[1]
			this._selected   = (skinOps.IsVertexSelected this._skin this._v) == 1
			this._normalized = (skinOps.isUnNormalizeVertex this._skin this._v) == 0
			this._bonesCount = (skinOps.GetVertexWeightCount this._skin this._v)
			
			this._load_bones()
			-- end
		)
		ret
	),


	-- Function: reload
	-- Reloads this by re-initing with this._v (vertex index).
	--------------------------------------------------------------------------
	fn reload = (this.init this._v),


	-- Function: safeModifyWeight
	-- Loads all the <SkinVertexBone>(s) to this._bones.
	--------------------------------------------------------------------------
	fn safeModifyWeight w = (throw ("\n\n+ To Implement! +\n\n")),


	-- Function: getVertexBoneForSkinBone
	-- Returns the local vertex's bone for the given <sbone> SkinBone.
	--------------------------------------------------------------------------
	fn getVertexBoneForSkinBone sbone = (this.getVertexBoneByBoneID sbone._boneID),


	fn getVertexBoneBy type rvalue = (
		local arr = undefined
		case type of (
			#name:   (arr = for b in this._bones where (b._name as name)   == (rvalue as name) collect b)
			#bone_id:(arr = for b in this._bones where (b._boneID)         == (rvalue) collect b)
			#list_id:(arr = for b in this._bones where (b._listID)         == (rvalue) collect b)
		)
		(ReturnCode.new (arr.count > 0) err_reason:("No VertexBone found with the type:#"+(type as string) + " with a rvalue of: "+(rvalue as string)) ok_data:arr[1])
	),
	fn getVertexBoneByName   nm = (this.getVertexBoneBy #name nm),
	fn getVertexBoneByBoneID id = (this.getVertexBoneBy #bone_id id),
	fn getVertexBoneByListID id = (this.getVertexBoneBy #list_id id),


	fn isRigidVertex       = (skinOps.isRigidVertex       this._skinModifier._skin this._v),
	fn isUnNormalizeVertex = (skinOps.isUnNormalizeVertex this._skinModifier._skin this._v),
	fn IsVertexModified    = (skinOps.IsVertexModified    this._skinModifier._skin this._v),
	fn IsVertexSelected    = (skinOps.IsVertexSelected    this._skinModifier._skin this._v),
	fn rigidVertex         = (skinOps.rigidVertex         this._skinModifier._skin this._v),

	-- Function: _load_bones
	-- *Private*: Loads all the <SkinVertexBone>(s) to this._bones.
	--------------------------------------------------------------------------
	fn _load_bones = (
		for i=1 to this._bonesCount do (
			local bonID   = (skinOps.GetVertexWeightBoneID this._skin this._v i)

			-- Cross with the correct SkinBone already loaded!
			local sBone = _skinModifier.getSkinBone bonID
			sBone       = if sBone.ret then (sBone.data) else (-1) 
			

			local bnmodel = (SkinVertexBone _skinVertex:this \
											_vertexBoneID:i \
											_boneID:bonID \
											_listID:(skinOps.GetListIDByBoneID this._skin bonID) \
											_name:((skinOps.GetBoneName this._skin bonID 0) as name) \
											_weight:(skinops.getvertexweight this._skin this._v i) \
											_skinBone:sBone)
			append this._bones bnmodel
		)
	),

	--------------------------------------------------------------------------
	fn endfunc = ()
)

--skMod = SkinModifier()
--skMod.init ($ch_lewis_b00a_mdl_body.modifiers[#Skin]) selected_vertices_only:false
--
--
--
--sv = SkinVertex init_id:9 _skinModifier:skMod
--sv.getVertexBoneByName "ch_lewis_b00a_help_spine_bone_05"
--
--
--
--skb = SkinBone init_skin_modifier:skMod
--skb.init bone_index:1
--
--
--svb = sv.getVertexBoneForSkinBone skb
--
--print svb.data
--print skb
--0
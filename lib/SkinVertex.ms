(
	local modo = Modolize init_path:(DEVTREE_BASEPATH)
	modo.filein "SkinLib.lib.SkinVertexBone"
)

/* Sound: Hello */

/* Class: SkinVertex

	Represents a vertex of a Skin modifier.
*/
struct SkinVertex (

	/* group: Constructor variable */
	-- Variable: init_id
    -- The constructor optional parameter
	init_id   = undefined,

	/* group: Constructor methods */
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
	fn init index skin_interface:undefined = (
		local ret = SkinHelpers.isSkinModifierSelected()

		if ret.ret then (
			this._skInt = skin_interface

			-- Load Vertex infos
			--------------------------------------------------------------------------
			this._v          = index
			this._load_vertex_bones()
			-- end
		)
		ret
	),


	-- Function: reload
	-- Reloads this by re-initing with this._v (vertex index).
	--------------------------------------------------------------------------
	fn reload = (this.init this._v),



	/* group: Class variables */
	-- Variable: _v
    -- Vertex index
	_v          = undefined,

	-- Variable: _bones
    -- The SkinVertexBone(s) array
	_bones      = undefined,

	-- Variable: _bonesCount
    -- How many bones do skin this vertex ?
	_bonesCount = undefined,

	-- Variable: _skInt 
	-- Mother instance of type SkinInterface
	_skInt = undefined,




	/* group: Public methods */
	-- Function: safeModifyWeight
	-- Loads all the <SkinVertexBone>(s) to this._bones.
	--------------------------------------------------------------------------
	fn safeModifyWeight w = (throw ("\n\n+ To Implement! +\n\n")),


	-- Function: getVertexBoneForSkinBone
	-- Returns the local vertex's bone for the given <sbone> SkinBone.
	--------------------------------------------------------------------------
	fn getVertexBoneForSkinBone sbone = (this.getVertexBoneByBoneID sbone._boneID),

	-- Function: getVertexBoneBy
	-- Returns the local vertex's bone for the given <sbone> SkinBone.
	--------------------------------------------------------------------------
	fn getVertexBoneBy type rvalue = (
		local arr = undefined
		case type of (
			#name:   (arr = for b in this._bones where (b._name as name)   == (rvalue as name) collect b)
			#bone_id:(arr = for b in this._bones where (b._boneID)         == (rvalue) collect b)
			#list_id:(arr = for b in this._bones where (b._listID)         == (rvalue) collect b)
		)
		(ReturnCode.new (arr.count > 0) err_reason:("No VertexBone found with the type:#"+(type as string) + " with a rvalue of: "+(rvalue as string)) ok_data:arr[1])
	),

	-- Function: getVertexBoneByName
	fn getVertexBoneByName   nm = (this.getVertexBoneBy #name nm),
	
	-- Function: getVertexBoneByBoneID
	fn getVertexBoneByBoneID id = (this.getVertexBoneBy #bone_id id),
	
	-- Function: getVertexBoneByListID
	fn getVertexBoneByListID id = (this.getVertexBoneBy #list_id id),


	-- Function: isRigidVertex
	fn isRigidVertex       = (skinOps.isRigidVertex       this._skInt._skin this._v),
	-- Function: isUnNormalizeVertex
	fn isUnNormalizeVertex = (skinOps.isUnNormalizeVertex this._skInt._skin this._v),
	-- Function: IsVertexModified
	fn IsVertexModified    = (skinOps.IsVertexModified    this._skInt._skin this._v),
	-- Function: IsVertexSelected
	fn IsVertexSelected    = (skinOps.IsVertexSelected    this._skInt._skin this._v),
	-- Function: rigidVertex
	fn rigidVertex         = (skinOps.rigidVertex         this._skInt._skin this._v),

	-- Function: bakeVertex
	fn bakeVertex         = (),

		-- Function: resetVertex
	fn resetVertex         = (),



	/* group: Private methods */
	-- Function: _load_vertex_bones
	-- *Private*: Loads all the <SkinVertexBone>(s) to this._bones.
	--------------------------------------------------------------------------
	fn _load_vertex_bones = (
		for i=1 to this._bones.Count do (
			
			local bonID   = (skinOps.GetVertexWeightBoneID this._skin this._v i)

			-- Cross with the correct SkinBone already loaded!
			local sBone = this._skInt.getSkinBone bonID
			sBone       = if sBone.ret then (sBone.data) else (-1) 
			

			local list_id = (skinOps.GetListIDByBoneID this._skInt._skin bonID)
			local namm    = (skinOps.GetBoneName        this._skInt._skin bonID 0)
			local ww      = (skinops.getvertexweight   this._skInt._skin this._v i)


			local bnmodel = (SkinVertexBone _skinVertex:this \
											_vertexBoneID:i \
											_boneID:bonID \
											_listID:list_id \
											_name:(namm as name) \
											_weight:ww \
											_skinBone:sBone)
			append this._bones bnmodel
		)
	),

	--------------------------------------------------------------------------
	fn endfunc = ()
)

skMod = SkinInterface()
skMod.init ($ch_lewis_b00a_mdl_body.modifiers[#Skin]) selected_vertices_only:true



sv = SkinVertex init_id:9 _skInt:skMod
--sv.getVertexBoneByName "ch_lewis_b00a_help_spine_bone_05"



--skb = SkinBone init_skin_modifier:skMod
--skb.init bone_index:1
----
--
--svb = sv.getVertexBoneForSkinBone skb
--
--print svb.data
--print skb
--0
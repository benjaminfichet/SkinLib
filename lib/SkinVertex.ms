(
	local modo = Modolize init_path:(DEVTREE_BASEPATH)
	modo.filein "SkinLib.lib.SkinVertexBone"
)

/* Class: SkinVertex

	Represents a vertex of a Skin modifier.
*/
struct SkinVertex (


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


	-- Constructor: Constructor<init_id:>
	-- SkinVertex's init() is automatically called with <init_id:> if it is passed at creation. ie.: n = SkinVertex init_id:theID
	--------------------------------------------------------------------------
	on create do (
		this._bones    = #()
		if this.init_id != undefined then (
			this.init this.init_id
		)
	),
  

	-- Function: init(index)
	-- 	Inits this SkinVertex, filling all data, and loading SkinVertexBone(s).
	--
	-- Parameters:
	-- 	index - <integer> The vertex index to init from.
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


	-- Function: reload()
	-- Reloads this by re-initing with this._v (vertex index).
	--------------------------------------------------------------------------
	fn reload = (this.init this._v),


	-- Function: safeModifyWeight(weight)
	-- Loads all the <SkinVertexBone>(s) to this._bones.
	--------------------------------------------------------------------------
	fn safeModifyWeight w = (throw ("\n\n+ To Implement! +\n\n")),



	-- Function: _load_bones()
	-- *Private*: Loads all the <SkinVertexBone>(s) to this._bones.
	--------------------------------------------------------------------------
	fn _load_bones = (
		for i=1 to this._bonesCount do (
			local bonID   = (skinOps.GetVertexWeightBoneID this._skin this._v i)
			local bnmodel = (SkinVertexBone _vertexBoneID:i \
											_boneID:bonID \
											_listID:(skinOps.GetListIDByBoneID this._skin bonID) \
											_name:(skinOps.GetBoneName this._skin bonID 0) \
											_weight:(skinops.getvertexweight this._skin this._v i))
			append this._bones bnmodel
		)
	),



	-- Mother instance of type SkinModifier
	_skinModifier = undefined,

	--------------------------------------------------------------------------
	fn endfunc = ()
)
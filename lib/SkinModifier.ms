(
	local modo = Modolize init_path:(DEVTREE_BASEPATH)
	modo.filein "SkinLib.lib.SkinHelpers"
	modo.filein "SkinLib.lib.SkinVertex"
)


struct SkinModifier (

	-- ctor param
	init_skin = undefined,


	-- class params
	_node     = undefined,
	_skin     = undefined,
	_vertices = undefined,


	-- Constructor
	on create do (
		if classof(this.init_skin) == Skin then (this.init this.init_skin)
	),

	-- init
	fn init s selected_vertices_only:false = (
		local ret = ReturnCode.new (classof(s) == Skin) err_reason:"SkinModifier.init takes a Skin as argument!"
		if ret.ret then (
			ret = SkinHelpers.isSkinModifierSelected()
			if ret.ret then (

				-- Load node and skin
				this._node = selection[1]
				this._skin = modPanel.getCurrentObject()

				-- load vertices
				ret = this._load_vertices selected_vertices_only:selected_vertices_only
			)
		)
		ret
	),


	fn _load_vertices selected_vertices_only:false = (
		local ret = ReturnCode ret:false

		-- Make vertices set
		local verticesSet  = #()
		for i=1 to this._node.numverts do (if selected_vertices_only == false or (selected_vertices_only and (skinOps.IsVertexSelected this._skin i)) then (append verticesSet i))

		-- Build SkinVertex
		local svms = #()
		for v in verticesSet do (
			local sv = SkinVertex init_id:v --sv.init v
			append svms (sv)
		)

		(ReturnCode.new (svms.count == verticesSet.count) err_reason:"Something went wrong loading SkinVertex(s)" ok_data:svms)
	),


	on create do ()
)

sm = SkinModifier()
r = sm.init ($ch_lewis_b00a_mdl_body.modifiers[#Skin]) selected_vertices_only:true
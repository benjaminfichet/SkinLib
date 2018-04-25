(
	local modo = Modolize init_path:(DEVTREE_BASEPATH)
	modo.filein "SkinLib.lib.SkinHelpers"
	modo.filein "SkinLib.lib.SkinBone"
	modo.filein "SkinLib.lib.SkinVertex"
)

struct SkinModifierOps (

	_skinmod = undefined,

	fn addBone bn_node redraw:false       = (skinOps.addBone                  this._skinmod._skin bn_node -1),
	fn addBoneFromViewEnd                 = (skinOps.addBoneFromViewEnd                 this._skinmod._skin),
	fn addBoneFromViewStart               = (skinOps.addBoneFromViewStart               this._skinmod._skin),
	fn bakeSelectedVerts                  = (skinOps.bakeSelectedVerts                  this._skinmod._skin),
	fn buttonAdd                          = (skinOps.buttonAdd                          this._skinmod._skin),
	fn buttonAddCrossSection              = (skinOps.buttonAddCrossSection              this._skinmod._skin),
	fn buttonAddGizmo                     = (skinOps.buttonAddGizmo                     this._skinmod._skin),
	fn buttonCopyGizmo                    = (skinOps.buttonCopyGizmo                    this._skinmod._skin),
	fn buttonExclude                      = (skinOps.buttonExclude                      this._skinmod._skin),
	fn buttonInclude                      = (skinOps.buttonInclude                      this._skinmod._skin),
	fn buttonPaint                        = (skinOps.buttonPaint                        this._skinmod._skin),
	fn buttonPasteGizmo                   = (skinOps.buttonPasteGizmo                   this._skinmod._skin),
	fn buttonRemove                       = (skinOps.buttonRemove                       this._skinmod._skin),
	fn buttonRemoveCrossSection           = (skinOps.buttonRemoveCrossSection           this._skinmod._skin),
	fn buttonRemoveGizmo                  = (skinOps.buttonRemoveGizmo                  this._skinmod._skin),
	fn buttonSelectExcluded               = (skinOps.buttonSelectExcluded               this._skinmod._skin),
	fn buttonWeightTable                  = (skinOps.buttonWeightTable                  this._skinmod._skin),
	fn copySelectedBone                   = (skinOps.copySelectedBone                   this._skinmod._skin),
	fn WeightTool                         = (skinOps.WeightTool                         this._skinmod._skin),
	fn closeWeightTool                    = (skinOps.closeWeightTool                    this._skinmod._skin),
	fn isWeightToolOpen                   = (skinOps.isWeightToolOpen                   this._skinmod._skin),
	fn GetNumberBones                     = (skinOps.GetNumberBones                     this._skinmod._skin),
	fn getNumberOfGizmos                  = (skinOps.getNumberOfGizmos                  this._skinmod._skin),
	fn getNumberOfGizmoTypes              = (skinOps.getNumberOfGizmoTypes              this._skinmod._skin),
	fn GetNumberVertices                  = (skinOps.GetNumberVertices                  this._skinmod._skin),
	fn GetSelectedBone                    = (skinOps.GetSelectedBone                    this._skinmod._skin),
	fn getSelectedBonePropEnvelopeVisible = (skinOps.getSelectedBonePropEnvelopeVisible this._skinmod._skin),
	fn getSelectedGizmo                   = (skinOps.getSelectedGizmo                   this._skinmod._skin),
	fn resetAllBones                      = (skinOps.resetAllBones                      this._skinmod._skin),
	fn resetSelectedBone                  = (skinOps.resetSelectedBone                  this._skinmod._skin),
	fn resetSelectedVerts                 = (skinOps.resetSelectedVerts                 this._skinmod._skin),
	fn selectNextBone                     = (skinOps.selectNextBone                     this._skinmod._skin),
	fn selectPreviousBone                 = (skinOps.selectPreviousBone                 this._skinmod._skin),

	on create do ()
)


struct SkinModifier (

	-- ctor param
	init_skin = undefined,


	-- class params
	_node     = undefined,
	_skin     = undefined,
	_vertices = undefined,
	_bones    = undefined,

	-- skinops
	ops   = undefined,


	-- Constructor
	on create do (
		if classof(this.init_skin) == Skin then (this.init this.init_skin)
	),

	-- init
	fn init iskin selected_vertices_only:false = (
		local ret = ReturnCode.new (classof(iskin) == Skin) err_reason:"SkinModifier.init takes a Skin as argument!"
		if ret.ret then (
			ret = SkinHelpers.isSkinModifierSelected()
			if ret.ret then (

				-- Load node and skin
				this._node = selection[1]
				this._skin = modPanel.getCurrentObject()

				-- load vertices
				ret = this.__load_vertices selected_vertices_only:selected_vertices_only
			)
		)
		ret
	),
	fn reload selected_vertices_only:false = (this.init this._skin selected_vertices_only:selected_vertices_only),
	

	fn __load_vertices selected_vertices_only:false = (
		local ret = ReturnCode ret:false
		local verticesSet  = #() -- Make vertices set
		for i=1 to this._node.numverts do (if selected_vertices_only == false or (selected_vertices_only and (skinOps.IsVertexSelected this._skin i)) then (append verticesSet i))

		this._vertices = #()
		for v in verticesSet do (
			local sv = SkinVertex init_id:v --sv.init v
			append this._vertices (sv)
		)
		(ReturnCode.new (this._vertices.count == verticesSet.count) err_reason:"Something went wrong loading SkinVertex(s)" ok_data:sv_obj)
	),

	fn __load_bones selected_vertices_only:false = (
		local ret = ReturnCode ret:false
		
		this._bones = #()
		for i=1 to this.ops.GetNumberBones() do (

		)
		ret
	),
	on create do (this.ops = SkinModifierOps _skinmod:this)
)

skMod = SkinModifier()
res = skMod.init ($ch_lewis_b00a_mdl_body.modifiers[#Skin]) selected_vertices_only:true




/*
skinOps.GetBoneName <Skin> <bone_index> <nameflag_index> 
skinOps.GetListIDByBoneID <Skin> <BoneID_integer>
skinOps.GetBoneIDByBoneID <Skin> <bone_index> <nameflag_index> 
skinOps.GetBoneIDByListID <Skin> <bone_index> <nameflag_index> 
skinOps.getNumberCrossSections <Skin> <bone_integer> 
skinOps.GetOuterRadius <Skin> <bone_integer> <CrossSectionID_integer> 
skinOps.GetVertexWeight <Skin> <vertex_integer> <vertex_bone_integer> 
skinOps.GetVertexWeightBoneID <Skin> <vertex_integer> <vertex_bone_integer> 
skinOps.GetVertexWeightCount <Skin> <vertex_integer> 
skinOps.Invalidate <Skin> <integer> 
skinOps.isBoneSelected <Skin> <BoneID_integer> 
skinOps.isRigidVertex <Skin> <vertex_integer> 
skinOps.removebone <Skin><BoneID_integer> 
skinOps.ReplaceVertexWeights <Skin> <vertex_integer> \ ( <vertex_bone_integer> | <vertex_bone_array> ) \ ( <weight_float> | <weight_array> ) 
skinOps.SelectBone <Skin> <bone_integer> 
skinOps.SelectVertices <Skin> \ ( <vertex_integer> | <vertex_array > | <<vertex_bitarray> 
skinOps.SetWeight <Skin> <weight_float> 
*
/* Class: SkinVertex

	Represents a vertex of a Skin modifier.
	3dsmax's vertices weights representation is a bit akward, SkinVertex aims to clean it up.
*/
struct SkinVertex (

	init_id   = undefined,

	_v          = undefined,
	_skin       = undefined,
	_node       = undefined,
	_selected   = undefined,
	_normalized = undefined,
	_bones      = undefined,
	_bonesCount = undefined,

	fn init index = (
		local ret = SkinHelpers.isSkinModifierSelected()
		if ret.ret then (

			-- Load Vertex infos
			--------------------------------------------------------------------------
			this._v          = index
			this._skin       = modPanel.getCurrentObject()
			this._node       = selection[1]
			this._selected   = (skinOps.IsVertexSelected this._skin this._v) == 1
			this._normalized = ((skinOps.isUnNormalizeVertex this._skin this._v) == 0)
			this._bonesCount = (skinOps.GetVertexWeightCount this._skin this._v)


			-- Load SkinVertexBone (s)
			--------------------------------------------------------------------------
			for i=1 to this._bonesCount do (
				local bonID   = (skinOps.GetVertexWeightBoneID this._skin this._v i)
				local bnmodel = (
									SkinVertexBone \
										_boneID:bonID \
										_vertexBoneID:i\
										_listID:(skinOps.GetListIDByBoneID this._skin bonID) \
										_name:(skinOps.GetBoneName this._skin bonID 0) \
										_weight:(skinops.getvertexweight this._skin this._v i)
								)
				append this._bones bnmodel
			)

			-- end
		)
		ret
	),

	-- Default max's weighting
	fn modifyWeight     = (throw ("\n\n+ To Implement! +\n\n")),

	-- Custom weighting, we compute new weight with locked bones influences
	fn safeModifyWeight = (throw ("\n\n+ To Implement! +\n\n")),

	on create do (
		this._bones    = #()
		if this.init_id != undefined then (
			this.init this.init_id
		)
	)
)
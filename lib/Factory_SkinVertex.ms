/* Class: Factory_SkinVertex

	Exports various methods to build sets of SkinVertex(s) as SkinVertex.init takes a single vertex id
*/
struct Factory_SkinVertex (
	fn initFromSelection = (
		local ret = SkinHelpers.isSkinModifierSelected()
		if ret.ret then (
			local nde = selection[1]
			local skn  = modPanel.getCurrentObject()

			local selectedVerts  = #()
			for i=1 to nde.numverts do (if (skinOps.IsVertexSelected skn i) then (append selectedVerts i))

			local svms = #()
			for v in selectedVerts do (
				local sv = SkinVertex init_id:v --sv.init v
				append svms (sv)
			)
			ret.data = svms
		)
		ret
	),
	on create do ()
)
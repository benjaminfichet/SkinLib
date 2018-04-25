--poc.ms
(
	-- WPTE sources
	local modo = Modolize init_path:DEVTREE_BASEPATH
	modo.filein "CodeHelpers.Skin.SkinHelpers"
)


(
	local fact         = Factory_SkinVertex()
	local factory_init = fact.initFromSelection()

	local verts = undefined
	if factory_init.ret then (
		verts = factory_init.data
		print verts
	)

	print verts[1]._bones
)
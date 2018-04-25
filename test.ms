--poc.ms
(
	-- WPTE sources
	local modo = Modolize init_path:DEVTREE_BASEPATH
	modo.filein "CodeHelpers.Skin.SkinHelpers"
	modo.filein "SkinLib.lib.SkinModifier"
)


(
	skMod = SkinModifier()
	skMod.init ($ch_lewis_b00a_mdl_body.modifiers[#Skin]) selected_vertices_only:true
)
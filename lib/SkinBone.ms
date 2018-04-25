struct SkinBone (
	-- Variable: _listID
    -- The list index for this bone
	_listID       = undefined,

	-- Variable: _boneID
    -- The true bone index
	_boneID       = undefined,

	-- Variable: _vertexBoneID
    -- The bone index for the root vertex
	_vertexBoneID = undefined,

	-- Variable: _name
    -- The bone name
	_name         = undefined,



	fn new bone_name: bone_index: list_index: = (
		--local ret = 



	),

	on create do ()
)



-- 1 to bone count do 
-- boneid = trueindex 
-- bonelistid = skinOps.GetBoneIDByBoneID <Skin> trueindex <nameflag_index> 
-- bonename = skinOps.GetBoneName <Skin> trueindex <nameflag_index> 

ss = $.modifiers[#Skin]
for bone_id=1 to skinOps.GetNumberBones ss do (
	local bname = skinOps.GetBoneName ss bone_id 0
	local listid = skinOps.GetListIDByBoneID ss bone_id
	format "bone_id:% \nname: %\nlist_id: %\n\n" bname (bone_id as string) (listid as string)
)
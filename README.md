# SkinLib

###Problem

**3dsmax Skin Maxscript interface (SkinOps)** inner data model is a bit akward. As an example a bone can be defined by its:
- bone_id
- bone_list_id
- bone_list_name_id
- vertice_bone_id

Some funcs signatures:
```maxscript
skinOps.GetListIDByBoneID <Skin> <BoneID_integer>
skinOps.GetBoneIDByListID <Skin> <ListID_integer>
skinOps.GetBoneNameByListID <Skin> <bone_index> <nameflag_index> 
```
This can get a bit frustrating to work with.

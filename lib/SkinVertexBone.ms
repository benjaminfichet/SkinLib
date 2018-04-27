/* Class: SkinVertexBone

	Represents a bone owned by a SkinVertex.
*/
struct SkinVertexBone (

	-- Variable: _name
    -- The bone name
	_name         = undefined,

	-- Variable: _weight
    -- The bone weight for the root vertex
	_weight       = undefined,

	-- Variable: _lock_weight
    -- Are we locking weight on this bone/vertex paur ?
	_lock_weight  = false,

	-- Variable: _vertexBoneID
    -- The bone index for the root vertex
	_vertexBoneID = undefined,

	-- Variable: _boneID
    -- The true bone index
	_boneID       = undefined,

	-- Variable: _listID
    -- The list index for this bone ! DEPRECATED AS WE KNOW REFER TO _skinBone directly!
	_listID       = undefined,

	-- Variable: _skinVertex
	-- The SkinVertex owning this VertexBone
	_skinVertex   = undefined,

	-- Variable: _skinBone
	-- The SkinBone Relating to this
	_skinBone     = undefined,


	on create do ()
)
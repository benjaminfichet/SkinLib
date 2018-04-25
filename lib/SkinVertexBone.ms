print "Sourcing SkinVertexBone"
/* Struct: SkinVertexBone

	Represents a bone owned by a SkinVertex.
*/
struct SkinVertexBone (

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

	-- Variable: _weight
    -- The bone weight for the root vertex
	_weight       = undefined,

	-- Variable: _lock_weight
    -- Are we locking weight on this bone/vertex paur ?
	_lock_weight  = false
)
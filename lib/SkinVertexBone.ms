/* Class: SkinVertexBone

	Represents a bone owned by a skin's vertex.

	_vertex is the owning vertex
	_listID is the skin's list bone id
	_boneID is the true bone id
	_vertexBoneID is the id of this bone using vertex's indexing
	_name is the bone name
*/
struct SkinVertexBone (
	_listID       = undefined,
	_boneID       = undefined,
	_vertexBoneID = undefined,
	_name         = undefined,
	_weight       = undefined,
	_lock_weight  = false
)
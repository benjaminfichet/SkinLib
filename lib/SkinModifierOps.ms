/* Class: SkinModifierOps

	Access to 3dsmax's SkinOps are made through this struct.
*/
struct SkinModifierOps (

	_skinmod = undefined,

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
	fn getCurrentSelectGizmoType          = (skinOps.getCurrentSelectGizmoType          this._skinmod._skin),
	fn GetNumberBones                     = (skinOps.GetNumberBones                     this._skinmod._skin),
	fn getNumberOfGizmos                  = (skinOps.getNumberOfGizmos                  this._skinmod._skin),
	fn getNumberOfGizmoTypes              = (skinOps.getNumberOfGizmoTypes              this._skinmod._skin),
	fn GetNumberVertices                  = (skinOps.GetNumberVertices                  this._skinmod._skin),
	
	fn GetSelectedBone                    = (skinOps.GetSelectedBone                    this._skinmod._skin),
	fn getSelectedBonePropEnvelopeVisible = (skinOps.getSelectedBonePropEnvelopeVisible this._skinmod._skin),
	fn getSelectedBonePropFalloff         = (skinOps.getSelectedBonePropFalloff         this._skinmod._skin),
	fn getSelectedBonePropRelative        = (skinOps.getSelectedBonePropRelative        this._skinmod._skin),
	fn getSelectedGizmo                   = (skinOps.getSelectedGizmo                   this._skinmod._skin),
	
	fn loadEnvelopeAsASCII                = (skinOps.loadEnvelopeAsASCII                this._skinmod._skin),
	fn multiRemove                        = (skinOps.multiRemove                        this._skinmod._skin),
	
	fn paintOptionsButton                 = (skinOps.paintOptionsButton                 this._skinmod._skin),
	fn paintOptionsButton                 = (skinOps.paintOptionsButton                 this._skinmod._skin),
	fn paintWeightsButton                 = (skinOps.paintWeightsButton                 this._skinmod._skin),
	
	fn pasteToAllBones                    = (skinOps.pasteToAllBones                    this._skinmod._skin),
	fn pasteToSelectedBone                = (skinOps.pasteToSelectedBone                this._skinmod._skin),
	
	fn RemoveCrossSection                 = (skinOps.RemoveCrossSection                 this._skinmod._skin),
	fn resetAllBones                      = (skinOps.resetAllBones                      this._skinmod._skin),
	fn resetSelectedBone                  = (skinOps.resetSelectedBone                  this._skinmod._skin),
	fn resetSelectedVerts                 = (skinOps.resetSelectedVerts                 this._skinmod._skin),
	
	fn selectEndPoint                     = (skinOps.selectEndPoint                     this._skinmod._skin),
	fn selectNextBone                     = (skinOps.selectNextBone                     this._skinmod._skin),
	fn selectPreviousBone                 = (skinOps.selectPreviousBone                 this._skinmod._skin),
	fn selectStartPoint                   = (skinOps.selectStartPoint                   this._skinmod._skin),
	
	fn WeightTool                         = (skinOps.WeightTool                         this._skinmod._skin),
	fn isWeightToolOpen                   = (skinOps.isWeightToolOpen                   this._skinmod._skin),
	fn closeWeightTool                    = (skinOps.closeWeightTool                    this._skinmod._skin),
	fn GetListIDByBoneID bone_id          = (skinOps.GetListIDByBoneID                  this._skinmod._skin bone_id),
	fn GetBoneIDByListID list_id          = (skinOps.GetBoneIDByListID                  this._skinmod._skin list_id),
	fn GetBoneName bone_id name_flag:1    = (skinOps.GetBoneName                        this._skinmod._skin bone_id name_flag),
	fn addBone bn_node redraw:false       = (skinOps.addBone                            this._skinmod._skin bn_node -1),

	fn SetWeight     w                    = (skinOps.SetWeight     this._skinmod._skin w),
	fn ZoomToBone    b                    = (skinOps.ZoomToBone    this._skinmod._skin b), 
	fn ZoomToGizmo   b                    = (skinOps.ZoomToGizmo   this._skinmod._skin b), 
	fn pasteAllBones b                    = (skinOps.pasteAllBones this._skinmod._skin b), 
	fn pasteAllVerts b                    = (skinOps.pasteAllVerts this._skinmod._skin b), 

	fn enableGizmo gizmo_id enable_bool   = (skinOps.enableGizmo this._skinmod._skin gizmo_id enable_bool), 
	   
	on create do ()
)
/* Class: SkinInterfaceOps

	Access to 3dsmax's SkinOps are made through this struct.
*/
struct SkinInterfaceOps (

	_skInt = undefined,

	/*fn addBoneFromViewEnd                 = (skinOps.addBoneFromViewEnd                 this._skInt._skin),
	fn addBoneFromViewStart               = (skinOps.addBoneFromViewStart               this._skInt._skin),
	fn bakeSelectedVerts                  = (skinOps.bakeSelectedVerts                  this._skInt._skin),

	fn buttonAdd                          = (skinOps.buttonAdd                          this._skInt._skin),
	fn buttonAddCrossSection              = (skinOps.buttonAddCrossSection              this._skInt._skin),
	fn buttonAddGizmo                     = (skinOps.buttonAddGizmo                     this._skInt._skin),
	fn buttonCopyGizmo                    = (skinOps.buttonCopyGizmo                    this._skInt._skin),
	fn buttonExclude                      = (skinOps.buttonExclude                      this._skInt._skin),
	fn buttonInclude                      = (skinOps.buttonInclude                      this._skInt._skin),
	fn buttonPaint                        = (skinOps.buttonPaint                        this._skInt._skin),
	fn buttonPasteGizmo                   = (skinOps.buttonPasteGizmo                   this._skInt._skin),
	fn buttonRemove                       = (skinOps.buttonRemove                       this._skInt._skin),
	fn buttonRemoveCrossSection           = (skinOps.buttonRemoveCrossSection           this._skInt._skin),
	fn buttonRemoveGizmo                  = (skinOps.buttonRemoveGizmo                  this._skInt._skin),
	fn buttonSelectExcluded               = (skinOps.buttonSelectExcluded               this._skInt._skin),
	fn buttonWeightTable                  = (skinOps.buttonWeightTable                  this._skInt._skin),

	fn copySelectedBone                   = (skinOps.copySelectedBone                   this._skInt._skin),
	fn getCurrentSelectGizmoType          = (skinOps.getCurrentSelectGizmoType          this._skInt._skin),
	fn GetNumberBones                     = (skinOps.GetNumberBones                     this._skInt._skin),
	fn getNumberOfGizmos                  = (skinOps.getNumberOfGizmos                  this._skInt._skin),
	fn getNumberOfGizmoTypes              = (skinOps.getNumberOfGizmoTypes              this._skInt._skin),
	fn GetNumberVertices                  = (skinOps.GetNumberVertices                  this._skInt._skin),
	
	fn GetSelectedBone                    = (skinOps.GetSelectedBone                    this._skInt._skin),
	fn getSelectedBonePropEnvelopeVisible = (skinOps.getSelectedBonePropEnvelopeVisible this._skInt._skin),
	fn getSelectedBonePropFalloff         = (skinOps.getSelectedBonePropFalloff         this._skInt._skin),
	fn getSelectedBonePropRelative        = (skinOps.getSelectedBonePropRelative        this._skInt._skin),
	fn getSelectedGizmo                   = (skinOps.getSelectedGizmo                   this._skInt._skin),
	
	fn loadEnvelopeAsASCII                = (skinOps.loadEnvelopeAsASCII                this._skInt._skin),
	fn multiRemove                        = (skinOps.multiRemove                        this._skInt._skin),
	
	fn paintOptionsButton                 = (skinOps.paintOptionsButton                 this._skInt._skin),
	fn paintOptionsButton                 = (skinOps.paintOptionsButton                 this._skInt._skin),
	fn paintWeightsButton                 = (skinOps.paintWeightsButton                 this._skInt._skin),
	
	fn pasteToAllBones                    = (skinOps.pasteToAllBones                    this._skInt._skin),
	fn pasteToSelectedBone                = (skinOps.pasteToSelectedBone                this._skInt._skin),
	
	fn RemoveCrossSection                 = (skinOps.RemoveCrossSection                 this._skInt._skin),
	fn resetAllBones                      = (skinOps.resetAllBones                      this._skInt._skin),
	fn resetSelectedBone                  = (skinOps.resetSelectedBone                  this._skInt._skin),
	fn resetSelectedVerts                 = (skinOps.resetSelectedVerts                 this._skInt._skin),
	
	fn selectEndPoint                     = (skinOps.selectEndPoint                     this._skInt._skin),
	fn selectNextBone                     = (skinOps.selectNextBone                     this._skInt._skin),
	fn selectPreviousBone                 = (skinOps.selectPreviousBone                 this._skInt._skin),
	fn selectStartPoint                   = (skinOps.selectStartPoint                   this._skInt._skin),
	
	fn WeightTool                         = (skinOps.WeightTool                         this._skInt._skin),
	fn isWeightToolOpen                   = (skinOps.isWeightToolOpen                   this._skInt._skin),
	fn closeWeightTool                    = (skinOps.closeWeightTool                    this._skInt._skin),
	fn GetListIDByBoneID bone_id          = (skinOps.GetListIDByBoneID                  this._skInt._skin bone_id),
	fn GetBoneIDByListID list_id          = (skinOps.GetBoneIDByListID                  this._skInt._skin list_id),
	fn GetBoneName bone_id name_flag:1    = (skinOps.GetBoneName                        this._skInt._skin bone_id name_flag),
	fn addBone bn_node redraw:false       = (skinOps.addBone                            this._skInt._skin bn_node -1),

	fn SetWeight     w                    = (skinOps.SetWeight     this._skInt._skin w),
	fn ZoomToBone    b                    = (skinOps.ZoomToBone    this._skInt._skin b), 
	fn ZoomToGizmo   b                    = (skinOps.ZoomToGizmo   this._skInt._skin b), 
	fn pasteAllBones b                    = (skinOps.pasteAllBones this._skInt._skin b), 
	fn pasteAllVerts b                    = (skinOps.pasteAllVerts this._skInt._skin b), 

	fn enableGizmo gizmo_id enable_bool   = (skinOps.enableGizmo this._skInt._skin gizmo_id enable_bool), */
	   
	on create do ()
)
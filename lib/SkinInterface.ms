(
	local modo = Modolize init_path:(DEVTREE_BASEPATH)
	
	print (modo.filein "SkinLib.lib.SkinHelpers")
	print (modo.filein "SkinLib.lib.SkinBone")
	print (modo.filein "SkinLib.lib.SkinVertex")
	print (modo.filein "SkinLib.lib.SkinInterfaceOps")
)

/* Class: SkinInterface

	About: Synopsys
	Represents a Skin modifier, has a lot of useful custom made functions to work with Skin modifiers.
	It also exports the entire *skinOps* interface, version, customized, and original.

	--- code
	-- Original/Customized prototypes :
	skinOps.GetOuterRadius <Skin> <bone_integer> <CrossSectionID_integer> 
	SkinInterface.GetOuterRadius <bone_integer/bone_name/SkinBone> <CrossSectionID_integer> 
	---

	About: Exemples

	--- code
	skMod = SkinInterface()
	skMod.init ($ch_xxxx_b00a_xxx_body.modifiers[#Skin]) selected_vertices_only:false

	outerRadius = skMod.GetOuterRadius "theBoneName" section_id

	-- or 

	myBone = skMod.getSkinBone "theBoneName" -- Get the bone
	outerRadius = myBone.GetOuterRadius section_id

	-- continue working with the bone ..
	-- vrts = myBone.getInfluencedVertices()
	-- for v in vrts ...

	---

*/
struct SkinInterface (


	
	/* group: Constructor variable */
	-- Variable: init_skin
    -- Constructor param, if this is set at SkinInterface creation, the init method is automatically called with it
	init_skin = undefined,

	/* group: Constructor methods */
	/* Function: create/constructor

	   Parameters:

	    	init_skin: - The skin modifier to init from.

	    Notes:

    		If init_skin: param is given at SkinInterface creation, the init function is automatically called!
    	--- Code
		SkinInterface init_skin:theSkin; -- Will call (this.init this.init_skin)
		---

	   Returns:

	    	void
	*/
	on create do (
		if classof(this.init_skin) == Skin then (this.init this.init_skin)
	),


	/* Function: init
		Initialization method. Must be called after SkinInterface creation if init_skin: was not passed to its constructor.

	   Parameters:

	    	iskin: - The skin modifier to init from.
	    	selected_bone_only:false - Will only load selected bone.
	    	selected_vertices_only:false - Will only load selected vertices.

	   Returns:
	    	ReturnCode
	*/
	fn init iskin selected_bone_only:false selected_vertices_only:false = (
		local ret = ReturnCode.new (classof(iskin) == Skin) err_reason:"SkinInterface.init takes a Skin as argument!"
		if ret.ret then (
			ret = SkinHelpers.isSkinModifierSelected()
			if ret.ret then (

				-- Load node and skin
				this._node = selection[1]
				this._skin = modPanel.getCurrentObject()

				-- Load Bones
				ret = this.__load_bones selected_bone_only:selected_bone_only
				if ret.ret then (

					-- load vertices
					ret = this.__load_vertices selected_vertices_only:selected_vertices_only

					-- We are initialized if ret.ret == true
				)
			)
		)
		ret
	),

	/* Function: reload
		Reloads this SkinInterface instance. (Re-call init())

	   Parameters:
	    	selected_bone_only:false - Will only load selected bone.
	    	selected_vertices_only:false - Will only load selected vertices.

	   Returns:
	    	ReturnCode
	*/
	fn reload selected_bone_only:false selected_vertices_only:false = (this.init this._skin selected_vertices_only:selected_vertices_only selected_bone_only:selected_bone_only),


	/* group: Class variables */
	-- Variable: _node
    -- The node holding the skin modifier
	_node     = undefined,

	-- Variable: _skin
    -- The inner skin modifier
	_skin     = undefined,

	-- Variable: _vertices
    -- An array of SkinVertex(s), initialized at SkinInterface.init()
	_vertices = undefined,

	-- Variable: _bones
    -- An array of SkinBone(s), initialized at SkinInterface.init()
	_bones    = undefined,

	-- Variable: ops
    -- The access to the remixed skinOps.functions
	ops       = undefined, -- skinops


	/* group: Public methods */
	/* Function: getSkinBone
		Returns a SkinBone by its name or its bone_index. You can not retrieve a SkinBone using a list_index using this method. Use getSkinBoneBy #list_id instead.

	   Parameters:

	    	bn_identifier: - The bone identifier, can be an int or a string/name

	    Notes:
	    You can not select bone by list_id from here, use getSkinBoneBy #list_id myID instead
    	--- Code
		ret = getSkinBone "aBoneName"  -- Will select a bone named "aBoneName"
		ret = getSkinBone 1            -- Will select the bone with the bone_id 1
		ret = getSkinBoneBy #list_id 1 -- Use getSkinBoneBy to select from the list id
		---

	   Returns:

	    	ReturnCode
	*/
	fn getSkinBone bn_identifier = (
		local cls = classof(bn_identifier)
		local ret = ReturnCode.new (cls == integer or cls == string or cls == name or cls == SkinBone) err_reason:"Invalid in value!"
		if ret.ret then (
			case cls of (
				(integer): (ret = this.getSkinBoneBy #bone_id bn_identifier)
				(string):  (ret = this.getSkinBoneBy #name bn_identifier)
				(name):    (ret = this.getSkinBoneBy #name bn_identifier)
				(SkinBone):(ret = this.getSkinBoneBy #bone_id bn_identifier._boneID)
			)
		)
		ret
	),



	/* Function: getSkinBoneBy
		Selects SkinBone(s) by type and value

	   Parameters:

	    	select_type: - The discrimatory type (#name, #bone_id, #list_id)
	    	rvalue: - The value the type must have to be selected

	    Notes:
    	--- Code
		... ret = getSkinBoneBy #bone_id anID ...
		---

	   Returns:

	    	ReturnCode
	*/
	fn getSkinBoneBy select_type rvalue = (
		local arr = #()
		case select_type of (
			#name:   (arr = for b in this._bones where (b._name as name)   == (rvalue as name) collect b)
			#bone_id:(arr = for b in this._bones where (b._boneID)         == (rvalue) collect b)
			#list_id:(arr = for b in this._bones where (b._listID)         == (rvalue) collect b)
		)
		(ReturnCode.new (arr.count > 0) err_reason:("No SkinBone found with the select_type:#"+(select_type as string) + " with a rvalue of: "+(rvalue as string)) ok_data:arr[1])
	),


	/* Function: getSelectedVertices
		Returns an array of SkinVertex(s) initialized with the Skin's selected vertices
	   
	   Returns:
	    	ReturnCode
	*/
	fn getSelectedVertices = (
		local data = for i=1 to this._node.numverts where (skinOps.IsVertexSelected this._skin i) collect (SkinVertex init_id:i _skInt:this)
		(ReturnCode ret:true data:data)
	),

	/* Function: getSkinVertex
		Returns a SkinVertex given an id.

	   Parameters:
	    	id: - Integer to get the vertex from.

	   Returns:
	    	ReturnCode
	*/	
	fn getSkinVertex id = (this.getSkinVertexByID id),


	/* Function: getSkinVertexByID
		Returns a SkinVertex given an id.

	   Parameters:
	    	id: - Integer to get the vertex from.

	   Returns:
	    	ReturnCode
	*/	
	fn getSkinVertexByID id = (
		local arr = for v in this._vertices where v._v == id collect v
		(ReturnCode.new (arr.count > 0) err_reason:("No SkinVertex found with the id:#"+(id as string) + "!") ok_data:arr[1])
	),



	/* Function: getSkinVertexBone
		Returns a getSkinVertexBone given a vertex id and a vertex_bone id.

	   Parameters:
	    	vid: - vertex_id
	    	vbone - vertex_bone id

	   Returns:
	    	ReturnCode
	*/	
	fn getSkinVertexBone vid vbone = (this.getSkinVertexByID id),



	/* Function: getSkinVertexBones
		Returns all SkinVertexBone(s) given a vertex id.

	   Parameters:
	    	vid: - vertex_id

	   Returns:
	    	ReturnCode
	*/	
	fn getSkinVertexBones vid = (this.getSkinVertexByID id),




	/* Function: addBone
		Adds a new bone to the skin modifier. 
		The bone won't be added if another one with the same name is already loaded. 

	   Parameters:

	    	wannaBeBone: - The bone to be added, can be $aNode, or "aNode"
	    	redraw:false - Force a redraw ?
	    	force:false  - Do we force the add of the bone even if this will create a dup ? 

	    Notes:
	    	Will trigger a reload()

	   Returns:

	    	ReturnCode
	*/	
	fn addBone wannaBeBone redraw:false force:false reload_skInt:true = (
		local nd = undefined
		if (isKindof wannaBeBone Node) do (nd = wannaBeBone)
		if (classof(wannaBeBone) == string or classOf(wannaBeBone) == name) do (nd = getNodeByName (wannaBeBone as string))

		local ret = ReturnCode.new (nd != undefined) err_reason:"Unable to find the node to add!"
		if ret.ret then (

			ret = ReturnCode.new (((selectBoneByName nd.name).ret == false) or force == true) err_reason:(nd.name+" can not be added as a bone with the same name already exists!")
			if ret.ret then (

				ret = ReturnCode.new (nd != undefined) err_reason:"Unable to find the node to add!"
				if ret.ret then (
		
					ret.ret = (this.ops.addBone nd redraw:redraw) == OK

					-- In case we are importing a large bone set, we'll reload at the end!
					if reload_skInt == true then (this.reload())
				)
			)
		)
		ret
	),

	/* Function: removeSkinBone
		Removes a bone from a SkinInterface, triggers a reload(). 
		The bone can be specified by bone_id, name, or SkinBone instance.

	   Parameters:

	    	b: - The bone to be removed, can be a bone_id, name, or SkinBone instance.

	    Notes:
	    	Will trigger a reload()

	   Returns:

	    	ReturnCode
	*/	
	fn removeSkinBone b reload_skInt:true = (
		local ret = getSkinBone b
		if ret.ret then (
			skinOps.removebone this._skin ret.data._boneID
			if reload_skInt == true then (this.reload())
		)
		ret
	),

	

	/* Function: selectBone
		Selects a bone from the bonelist.
		The bone can be specified by bone_id, name, or SkinBone instance.

	   Parameters:
	    	b: - The bone to be selected, can be a bone_id, name, or SkinBone instance.

	   Returns:
	    	ReturnCode
	*/	
	fn selectBone b = (
		local ret = this.getSkinBone b
		if ret.ret then (skinOps.SelectBone this._skin ret.data._boneID)
		ret
	),

	/* group: SkinOps Interface
		The is mostly the same as the original SkinOps interface. You can refer to 3dsmax's doc for the most part.

		Notes:
			- you don't need to pass the <Skin> parameter
			- an int, a name/string, or a SkinBone can be passed when a Bone_ID is originally required.

		List: The methods list
			- GetSelectedBone
			- GetNumberBones
			- GetNumberVertices
			- resetSelectedBone
			- resetSelectedVerts
			- addBoneFromViewEnd
			- addBoneFromViewStart
			- bakeSelectedVerts
			- buttonAdd
			- buttonAddCrossSection
			- buttonAddGizmo
			- buttonCopyGizmo
			- buttonExclude
			- buttonInclude
			- buttonPaint
			- buttonPasteGizmo
			- buttonRemove
			- buttonRemoveCrossSection
			- buttonRemoveGizmo
			- buttonSelectExcluded
			- buttonWeightTable
			- copySelectedBone
			- getCurrentSelectGizmoType
			- getNumberOfGizmos
			- getNumberOfGizmoTypes
			- getSelectedBonePropEnvelopeVisible
			- getSelectedBonePropFalloff
			- getSelectedBonePropRelative
			- getSelectedGizmo
			- multiRemove
			- paintOptionsButton
			- paintOptionsButton
			- paintWeightsButton
			- pasteToAllBones
			- pasteToSelectedBone
			- RemoveCrossSection
			- resetAllBones
			- selectEndPoint
			- selectNextBone
			- selectPreviousBone
			- selectStartPoint
			- WeightTool
			- isWeightToolOpen
			- closeWeightTool
			- addCrossSection
			- Invalidate
			- isRigidHandle
			- rigidHandle
			- selectCrossSection
			- selectGizmo
			- selectGizmoType
			- SetWeight
			- ZoomToBone
			- ZoomToGizmo
			- pasteAllBones
			- pasteAllVerts
			- enableGizmo
			- getBonePropFalloff
			- getBonePropRelative
			- getEndPoint
			- getNumberCrossSections
			- getStartPoint
			- getBonePropEnvelopeVisible
			- setBonePropEnvelopeVisible
			- setBonePropFalloff
			- setBonePropRelative
			- setSelectedBonePropEnvelopeVisible
			- setSelectedBonePropFalloff
			- setSelectedBonePropRelative
			- SetEndPoint
			- SetStartPoint
			- GetCrossSectionU
			- GetInnerRadius
			- GetOuterRadius
			- SetCrossSectionU
			- SetInnerRadius
			- SetOuterRadius
	*/
	fn GetSelectedBone                               = (skinOps.GetSelectedBone                                this._skin),
	fn GetNumberBones                                = (skinOps.GetNumberBones                                 this._skin),
	fn GetNumberVertices                             = (skinOps.GetNumberVertices                              this._skin),
	fn resetSelectedBone                             = (skinOps.resetSelectedBone                              this._skin),
	fn resetSelectedVerts                            = (skinOps.resetSelectedVerts                             this._skin),
	fn addBoneFromViewEnd                            = (skinOps.addBoneFromViewEnd                             this._skin),
	fn addBoneFromViewStart                          = (skinOps.addBoneFromViewStart                           this._skin),
	fn bakeSelectedVerts                             = (skinOps.bakeSelectedVerts                              this._skin),
	fn buttonAdd                                     = (skinOps.buttonAdd                                      this._skin),
	fn buttonAddCrossSection                         = (skinOps.buttonAddCrossSection                          this._skin),
	fn buttonAddGizmo                                = (skinOps.buttonAddGizmo                                 this._skin),
	fn buttonCopyGizmo                               = (skinOps.buttonCopyGizmo                                this._skin),
	fn buttonExclude                                 = (skinOps.buttonExclude                                  this._skin),
	fn buttonInclude                                 = (skinOps.buttonInclude                                  this._skin),
	fn buttonPaint                                   = (skinOps.buttonPaint                                    this._skin),
	fn buttonPasteGizmo                              = (skinOps.buttonPasteGizmo                               this._skin),
	fn buttonRemove                                  = (skinOps.buttonRemove                                   this._skin),
	fn buttonRemoveCrossSection                      = (skinOps.buttonRemoveCrossSection                       this._skin),
	fn buttonRemoveGizmo                             = (skinOps.buttonRemoveGizmo                              this._skin),
	fn buttonSelectExcluded                          = (skinOps.buttonSelectExcluded                           this._skin),
	fn buttonWeightTable                             = (skinOps.buttonWeightTable                              this._skin),
	fn copySelectedBone                              = (skinOps.copySelectedBone                               this._skin),
	fn getCurrentSelectGizmoType                     = (skinOps.getCurrentSelectGizmoType                      this._skin),
	fn getNumberOfGizmos                             = (skinOps.getNumberOfGizmos                              this._skin),
	fn getNumberOfGizmoTypes                         = (skinOps.getNumberOfGizmoTypes                          this._skin),
	fn getSelectedBonePropEnvelopeVisible            = (skinOps.getSelectedBonePropEnvelopeVisible             this._skin),
	fn getSelectedBonePropFalloff                    = (skinOps.getSelectedBonePropFalloff                     this._skin),
	fn getSelectedBonePropRelative                   = (skinOps.getSelectedBonePropRelative                    this._skin),
	fn getSelectedGizmo                              = (skinOps.getSelectedGizmo                               this._skin),
	fn multiRemove                                   = (skinOps.multiRemove                                    this._skin),
	fn paintOptionsButton                            = (skinOps.paintOptionsButton                             this._skin),
	fn paintOptionsButton                            = (skinOps.paintOptionsButton                             this._skin),
	fn paintWeightsButton                            = (skinOps.paintWeightsButton                             this._skin),
	fn pasteToAllBones                               = (skinOps.pasteToAllBones                                this._skin),
	fn pasteToSelectedBone                           = (skinOps.pasteToSelectedBone                            this._skin),
	fn RemoveCrossSection                            = (skinOps.RemoveCrossSection                             this._skin),
	fn resetAllBones                                 = (skinOps.resetAllBones                                  this._skin),
	fn selectEndPoint                                = (skinOps.selectEndPoint                                 this._skin),
	fn selectNextBone                                = (skinOps.selectNextBone                                 this._skin),
	fn selectPreviousBone                            = (skinOps.selectPreviousBone                             this._skin),
	fn selectStartPoint                              = (skinOps.selectStartPoint                               this._skin),
	fn WeightTool                                    = (skinOps.WeightTool                                     this._skin),
	fn isWeightToolOpen                              = (skinOps.isWeightToolOpen                               this._skin),
	fn closeWeightTool                               = (skinOps.closeWeightTool                                this._skin), 
	fn addCrossSection                    v          = (skinOps.addCrossSection                                this._skin v),
	fn Invalidate                         i          = (skinOps.Invalidate                                     this._skin i),
	fn isRigidHandle                      i          = (skinOps.isRigidHandle                                  this._skin i),
	fn rigidHandle                        i          = (skinOps.rigidHandle                                    this._skin i),
	fn selectCrossSection                 i u        = (skinOps.selectCrossSection                             this._skin i u),
	fn selectGizmo                        i          = (skinOps.selectGizmo                                    this._skin i),
	fn selectGizmoType                    i          = (skinOps.selectGizmoType                                this._skin i),
	fn SetWeight                          w          = (skinOps.SetWeight                                      this._skin w),
	fn ZoomToBone                         b          = (skinOps.ZoomToBone                                     this._skin b), 
	fn ZoomToGizmo                        b          = (skinOps.ZoomToGizmo                                    this._skin b), 
	fn pasteAllBones                      b          = (skinOps.pasteAllBones                                  this._skin b), 
	fn pasteAllVerts                      b          = (skinOps.pasteAllVerts                                  this._skin b), 
	fn enableGizmo                        g b        = (skinOps.enableGizmo                                    this._skin g b),
	fn getBonePropFalloff                 bon        = (this._executeSkinOpsByBoneID #getBonePropFalloff                 bon),
	fn getBonePropRelative                bon        = (this._executeSkinOpsByBoneID #getBonePropRelative                bon),
	fn getEndPoint                        bon        = (this._executeSkinOpsByBoneID #getEndPoint                        bon),
	fn getNumberCrossSections             bon        = (this._executeSkinOpsByBoneID #getNumberCrossSections             bon),
	fn getStartPoint                      bon        = (this._executeSkinOpsByBoneID #getStartPoint                      bon),
	fn getBonePropEnvelopeVisible         bon        = (this._executeSkinOpsByBoneID #getBonePropEnvelopeVisible         bon),
	fn setBonePropEnvelopeVisible         bon i      = (this._executeSkinOpsByBoneID #setBonePropEnvelopeVisible         bon arg2:i),
	fn setBonePropFalloff                 bon i      = (this._executeSkinOpsByBoneID #setBonePropFalloff                 bon arg2:i),
	fn setBonePropRelative                bon i      = (this._executeSkinOpsByBoneID #setBonePropRelative                bon arg2:i),
	fn setSelectedBonePropEnvelopeVisible bon i      = (this._executeSkinOpsByBoneID #setSelectedBonePropEnvelopeVisible bon arg2:i),
	fn setSelectedBonePropFalloff         bon i      = (this._executeSkinOpsByBoneID #setSelectedBonePropFalloff         bon arg2:i),
	fn setSelectedBonePropRelative        bon i      = (this._executeSkinOpsByBoneID #setSelectedBonePropRelative        bon arg2:i),
	fn SetEndPoint                        bon p3     = (this._executeSkinOpsByBoneID #SetEndPoint                        bon arg2:p3),
	fn SetStartPoint                      bon p3     = (this._executeSkinOpsByBoneID #SetStartPoint                      bon arg2:p3),
	fn GetCrossSectionU                   bon sectid = (this._executeSkinOpsByBoneID #GetCrossSectionU                   bon arg2:sectid),
	fn GetInnerRadius                     bon sectid = (this._executeSkinOpsByBoneID #GetInnerRadius                     bon arg2:sectid),
	fn GetOuterRadius                     bon sectid = (this._executeSkinOpsByBoneID #GetOuterRadius                     bon arg2:sectid),
	fn SetCrossSectionU                   bon i f    = (this._executeSkinOpsByBoneID #SetCrossSectionU                   bon arg2:i arg3:f),
	fn SetInnerRadius                     bon i f    = (this._executeSkinOpsByBoneID #SetInnerRadius                     bon arg2:i arg3:f),
	fn SetOuterRadius                     bon i f    = (this._executeSkinOpsByBoneID #SetOuterRadius                     bon arg2:i arg3:f),



	/* group: Private methods */
private

	/* Function: _executeSkinOpsByBoneID
		*PRIVATE* Executes a skinOps function base on #op, on a given <bon:name/id/SkinBone>, with variable params count.

	   Parameters:
	    	op: - The function to call. ex:#getNumberCrossSections  
	    	bon: - The bone. (name/id/SkinBone)
	    	arg2:false - In case more arguments are needed
	    	arg3:false - In case more arguments are needed
	    	arg4:false - In case more arguments are needed

	   Returns:
	    	ReturnCode
	*/	
	fn _executeSkinOpsByBoneID op bon arg2:false arg3:false arg4:false = (
		local ret = this.getSkinBone bon
		local exe = undefined
		if ret.ret then (
			case op of (
				#getBonePropEnvelopeVisible         : (skinOps.getBonePropEnvelopeVisible)
				#getBonePropFalloff                 : (skinOps.getBonePropFalloff)
				#getBonePropRelative                : (skinOps.getBonePropRelative)
				#getEndPoint                        : (skinOps.getEndPoint)
				#getNumberCrossSections             : (skinOps.getNumberCrossSections)
				#getStartPoint                      : (skinOps.getStartPoint)
				#GetCrossSectionU                   : (skinOps.GetCrossSectionU)
				#GetInnerRadius                     : (skinOps.GetInnerRadius)
				#GetOuterRadius                     : (skinOps.GetOuterRadius)
				#setBonePropEnvelopeVisible         : (skinOps.setBonePropEnvelopeVisible)
				#setBonePropFalloff                 : (skinOps.setBonePropFalloff)
				#setBonePropRelative                : (skinOps.setBonePropRelative)
				#setSelectedBonePropEnvelopeVisible : (skinOps.setSelectedBonePropEnvelopeVisible)
				#setSelectedBonePropFalloff         : (skinOps.setSelectedBonePropFalloff)
				#setSelectedBonePropRelative        : (skinOps.setSelectedBonePropRelative)
				#SetEndPoint                        : (skinOps.SetEndPoint)
				#SetStartPoint                      : (skinOps.SetStartPoint)
				#SetCrossSectionU                   : (skinOps.SetCrossSectionU)
				#SetInnerRadius                     : (skinOps.SetInnerRadius)
				#SetOuterRadius                     : (skinOps.SetOuterRadius)
			)
			if (arg2 == false) and (arg3 == false) and (arg4 == false) then (ret.ret = exe ret.data._boneID)
			if (arg2 != false) and (arg3 == false) and (arg4 == false) then (ret.ret = exe ret.data._boneID arg2)
			if (arg2 != false) and (arg3 != false) and (arg4 == false) then (ret.ret = exe ret.data._boneID arg2 arg3)
			if (arg2 != false) and (arg3 != false) and (arg4 != false) then (ret.ret = exe ret.data._boneID arg2 arg3 arg4)
		)
		ret
	),


	/* Function: __load_vertices
		*PRIVATE* Load the array of ._vertices with SkinVertex on init.

	   Parameters:
	    	selected_vertices_only: - Set to true to only load selected vertices.

	   Returns:
	    	ReturnCode
	*/	
	fn __load_vertices selected_vertices_only:false = (
		local ret = ReturnCode ret:false
		local verticesSet  = #() -- Make vertices set
		for i=1 to this._node.numverts do (if selected_vertices_only == false or (selected_vertices_only and (skinOps.IsVertexSelected this._skin i)) then (append verticesSet i))

		this._vertices = #()
		for v in verticesSet do (
			local sv = SkinVertex init_id:v _skInt:this --sv.init v
			append this._vertices (sv)
		)
		(ReturnCode.new (this._vertices.count == verticesSet.count) err_reason:"Something went wrong loading SkinVertex(s)")
	),

	/* Function: __load_bones
		*PRIVATE* Load the array of ._vertices with SkinVertex on init.

	   Parameters:
	    	selected_bone_only: - Set to true to only load selected bones. (IRRELEVANT!)

	   Returns:
	    	ReturnCode
	*/
	fn __load_bones selected_bone_only:false = (
		local ret = ReturnCode ret:false
		local bCount = this.GetNumberBones()

		this._bones = #()
		for i=1 to bCount do (
			
			local bn = SkinBone init_skin_modifier:this
			ret = bn.init bone_index:i
			if ret.ret then (
				append this._bones bn
			)
		)
		(ReturnCode.new (this._bones.count == bCount) err_reason:"Something went wrong loading SkinBone(s)")
	),

	/*
	skinOps.ReplaceVertexWeights <Skin> <vertex_integer> \ ( <vertex_bone_integer> | <vertex_bone_array> ) \ ( <weight_float> | <weight_array> ) 
	skinOps.SetVertexWeights <Skin> <vertex_integer> \ ( <vertex_bone_integer> | <vertex_bone_array> ) \ ( <weight_float> | <weight_array> ) 
	skinOps.unNormalizeVertex <Skin> <vertex_integer> <boolean> 
	*/

public
	on create do (this.ops = SkinInterfaceOps _skInt:this)
)


skm = SkinInterface()
skm.init ($ch_lewis_b00a_mdl_body.modifiers[#Skin]) selected_vertices_only:true
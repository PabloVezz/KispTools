
struct KispToolsV3
(
	--ROLLOUT REFERENCES
	myInst=undefined,
	
	--DOTNET OBJECT REFERENCES	
	thePanel2=undefined,
	myToolTip=undefined,
	
	--DOCK&COLLAPSE
	docked=false,

	--SHOW FLAGS
	showPMUI=false,
	showPropsUI=false,
	showShadingUI=false,
	showUVWMappingUI=false,
	showRenderUI=false,
	showRandomUtilsUI=false,

		
	--UI VARIABLES
	maxBackColor=colorMan.getColor #background,
	
	doRefresh = true,
	
	--------------------------------------------
	--------------------------------------------
	-- DOTNET UTILITIES
	-- DOTNET UTILITIES
	--------------------------------------------
	--------------------------------------------	
	include "\\\\COMPARTIDA\Renderings\Resources\KispTools\KispToolsUtils.ms" 
	
	/************************************
		METHOD : DoCategoryButton		
		USE: Returns a formatted category button.
		These are the buttons that are used 
		to expand each of the categories
		ARGUMENTS : 
			theName : The Text that  will be displayed 
						in the button
	*/	
	fn DoCategoryButton theName =
	(
		dnButton=dotNetObject "button"
		dnButton.backColor =KispToolsV3.dnColor c:[120,120,120] a:255
		dnbutton.flatStyle=dnbutton.flatStyle.Flat
		dnButton.margin= dnbutton.margin.empty
		
		dnButton.bounds = KispToolsV3.dnRec s:[KispToolsV3.thePanel2.width, 30]
		dnButton.text=theName
		
		dnButton
	),
	
	/************************************
			METHOD :DoFlowLayout
			USE:Returns a FlowLayoutPanel of the provided height
				This is where the category tools will be placed
			ARGUMENTS :
				theHeight: INT-- the height of the returned panel
	*/
	fn DoFlowLayout theHeight =
	(	
		dnFlow= dotNetObject "flowLayoutPanel"
		dnFlow.Flowdirection = dnFlow.Flowdirection.LeftToRight
		dnFlow.bounds =KispToolsV3.dnRec s:[KispToolsV3.thePanel2.width, theHeight]
		dnFlow.margin = dnFlow.margin.empty
		
		dnFlow.backColor =KispToolsV3.dnColor c:[50,50,50] a:255
		dnFlow.BorderStyle=dnFlow.BorderStyle.none		
		
		dnFlow
	),
	
	/************************************
		METHOD :DoToolButton
		USE: Returns a dotnet Button that will be used for a tool
		ARGUMENTS :
					theImage: dotnet image
					theSize:[int, int] the size of the button
	*/
	fn DoToolButton theImage theSize =
	(
				dnbutton= dotnetObject "button"
				--Set the Text
				--dnButton.text=theName
				--Set the size
				dnbutton.Size = dnSize s:[theSize, theSize]		
				--Set the Margin
				dnbutton.Margin= dnbutton.Margin.empty		
				--Set the backcolor
				dnbutton.backcolor = dnColor c:[200,200,200] a:255
				--Set Hover Colors				
				dnbutton.flatStyle=dnbutton.flatStyle.popup		
				--ADD the Image
				dnbutton.backgroundImage = theImage	
		
		
				dnbutton
	),
	
	--------------------------------------------
	--------------------------------------------
	-- TOOL UTILITIES
	-- TOOL UTILITIES
	--------------------------------------------
	--------------------------------------------
	
	/************************************
		METHOD :TryDock
		USE: Switches between docked and undocked UI to the left
	*/
	fn TryDock =
	(
		if (KispToolsV3.docked==true) then
		(
			cui.UnRegisterDialogBar KispToolsV3.myInst
		)
		else
		(
			--size = [200 + 15, 25 + 3]
			cui.RegisterDialogBar KispToolsV3.myInst  style:#(#cui_dock_left)
			cui.DockDialogBar KispToolsV3.myInst #cui_dock_left
		)
		KispToolsV3.docked = NOT KispToolsV3.docked
		
	),
	
	
	--------------------------------------------
	--------------------------------------------
	-- CATEGORY PANELS
	-- CATEGORY PANELS
	--------------------------------------------
	--------------------------------------------
	
	/************************************
		METHOD : DoPMUI
		USE: Returns the UI  for the Project Management Category UI
		ARGUMENTS :
				theHeight: the Height of the ProjectManagement UI
	*/
	fn DoPMUI theHeight =
	(		
		
		--create Image Class
		imageClass = dotNetclass "System.Drawing.image"
		--Load all the icons
	
		--Create the Image List
		imageList75 = dotnetobject "System.Windows.Forms.ImageList"
		imageList75.imagesize = dotnetobject "System.Drawing.Size" 75 75
		
		Image1 = imageClass.fromfile ("\\\\COMPARTIDA\Renderings\Resources\KispTools\Images\Icons\Icon256_NewProject.png")		---Create new Project 
		imageList75.images.add Image1
		
		Image2 = imageClass.fromfile ("\\\\COMPARTIDA\Renderings\Resources\KispTools\Images\Icons\Icon256_ExamineProject.png")		---Examine Exisiting Project 
		imageList75.images.add Image2
		
		
		--------------------------------------------
	-- FLOW PANEL
	-- FLOW PANEL
	--------------------------------------------
		
		dnFlow= KispToolsV3.DoFlowLayout theHeight
		
				--------------------------------------------
				-- BUTTON : NEW PROJECT
				-- BUTTON : NEW PROJECT
				--------------------------------------------
				--Create a new Button 				
				dnbuttonPM= DoToolButton imageList75.Images.Item[0] 75					
				dnFlow.controls.add dnbuttonPM				
				dotNet.addEventHandler dnbuttonPM "click" ( 
					fn CreateDirMacro = 
					(
						fileIn "\\\\COMPARTIDA\Renderings\Resources\KispTools\Scripts\ProjectStart\CreateNewProject.ms" 	
						macros.run "Matanga" "CreateNewProject"																				
					)  
				)
				dotNet.setLifetimeControl dnbuttonPM #dotnet
				
				KispToolsV3.myToolTip.SetToolTip dnbuttonPM "Start a new project"		

				
				--------------------------------------------
				-- BUTTON : CREATE  PROJECT
				-- BUTTON : CREATE  PROJECT
				--------------------------------------------
				--Create a new Button 				
				dnbuttonEP= DoToolButton imageList75.Images.Item[1] 75					
				dnFlow.controls.add dnbuttonEP				
				dotNet.addEventHandler dnbuttonEP "click" ( 
					fn CreateDirMacro = 
					(
						fileIn "\\\\COMPARTIDA\Renderings\Resources\KispTools\Scripts\ProjectStart\ExamineProject.ms" 	
						macros.run "Matanga" "ExamineProject"																				
					)  
				)
				dotNet.setLifetimeControl dnbuttonEP #dotnet			

				KispToolsV3.myToolTip.SetToolTip dnbuttonEP "Explore an existing project.\n*.max files can be opened\n*.dwg files can be imported\nPDF,JPG and folders can be opened"		

		
	--------------------------------------------
	-- END FLOW PANEL
	-- END FLOW PANEL
	--------------------------------------------
	--Return the created flow Panel
	dnFlow
	),
	/************************************
		METHOD : DoPropsUI
		USE: Returns the UI  for the Props Category UI
		ARGUMENTS :
				theHeight: the Height of the Props UI
	*/
	fn DoPropsUI theHeight =
	(
		--create Image Class
		imageClass = dotNetclass "System.Drawing.image"
		--Load all the icons
	
		--IMAGE LIST 75
		--IMAGE LIST 75
		--IMAGE LIST 75

		imageList75 = dotnetobject "System.Windows.Forms.ImageList"
		imageList75.imagesize = dotnetobject "System.Drawing.Size" 75 75
		
		Image0 = imageClass.fromfile ("\\\\COMPARTIDA\Renderings\Resources\KispTools\Images\Icons\Icon256_AnalizeBlocks.png")		
		imageList75.images.add Image0	
		
		Image1 = imageClass.fromfile ("\\\\COMPARTIDA\Renderings\Resources\KispTools\Images\Icons\Icon256_ImportProps.png")		
		imageList75.images.add Image1	
		
		--IMAGE LIST 50
		--IMAGE LIST 50
		--IMAGE LIST 50
		
		imageList50 = dotnetobject "System.Windows.Forms.ImageList"
		imageList50.imagesize = dotnetobject "System.Drawing.Size" 50 50
		
		
		---Analize Blocks
		---Analize Blocks
		Image0 = imageClass.fromfile ("\\\\COMPARTIDA\Renderings\Resources\KispTools\Images\Icons\Icon256_PlaceProps.png")		
		imageList50.images.add Image0	
		
		--------------------------------------------
		-- FLOW PANEL
		-- FLOW PANEL
		--------------------------------------------
			
		dnFlow= KispToolsV3.DoFlowLayout theHeight
		
		--------------------------------------------
		-- BUTTON : QUICK MATERIAL
		-- BUTTON : QUICK MATERIAL
		--------------------------------------------		
				--Create a new Button 				
				dnbuttonAB= DoToolButton imageList75.Images.Item[0] 75					
				dnFlow.controls.add dnbuttonAB				
				dotNet.addEventHandler dnbuttonAB "click" ( 
					fn CreateDirMacro = 
					(
						fileIn "\\\\COMPARTIDA\Renderings\Resources\KispTools\Scripts\Props\BlockAnalizer.ms" 	
						--macros.run "Matanga" "QuickAddMaterial"	
					)  
				)
				dotNet.setLifetimeControl dnbuttonAB #dotnet		
			
				KispToolsV3.myToolTip.SetToolTip dnbuttonAB "Analize and do various task on an \n imported cad file"		
				
				
		--------------------------------------------
		-- BUTTON : IMPORT PROPS
		-- BUTTON : IMPORT PROPS
		--------------------------------------------		
				--Create a new Button 				
				dnbuttonIP= DoToolButton imageList75.Images.Item[1] 75					
				dnFlow.controls.add dnbuttonIP				
				dotNet.addEventHandler dnbuttonIP "click" ( 
					fn CreateDirMacro = 
					(
							fileIn "\\\\COMPARTIDA\Renderings\Resources\KispTools\Scripts\Props\PropImporterV2.ms" 
							macros.run "Matanga" "propImporterV2"	
					)  
				)
				dotNet.setLifetimeControl dnbuttonIP #dotnet		
			
				KispToolsV3.myToolTip.SetToolTip dnbuttonIP "Import props from the server and \n place them in the scene dynamically"		
								
				
		--------------------------------------------
		-- BUTTON : PLACE PROPS
		-- BUTTON : PLACE PROPS
		--------------------------------------------		
				--Create a new Button 				
				dnbuttonPP= DoToolButton imageList50.Images.Item[0] 50				
				dnFlow.controls.add dnbuttonPP				
				dotNet.addEventHandler dnbuttonPP "MouseDown" ( 
					fn CreateDirMacro eve = 
					(
						if (eve.Button != Eve.Button.Right) do
						(
							NewObj=PickObject()							 
							if(NewObj!= undefined) then 
							(							
								global importedProp =NewObj
								global startMousePos= Mouse.pos.x
								global propPlaced=false
								global aborted=false
								
								global thePlane = Plane length:10000 lengthsegs:1 width:10000 widthsegs:1 pos:[0,0,0] isSelected:off name:"plainito" wirecolor:(color 128 128 128)
								myMaterial= StandardMaterial()
								myMaterial.opacity=0
								thePlane.material=myMaterial							
								
								 if( eve.Button == Eve.Button.Left) do 
								(
									--print "Placing Single"
									--Declare the global for the tool
									global placeMultiple=false
									--Run the Tool
									fileIn "\\\\COMPARTIDA\Renderings\Resources\KispTools\Scripts\Props\Tool_PlaceProp.ms"
								)
							
								 --if( eve.Button == Eve.Button.Middle) do print "Middle"
								 if( eve.Button == Eve.Button.Middle) do
								(							
									--print "Placing Multiple"
									--Declare the global for the tool
									global placeMultiple=true
									--Run the Tool
									fileIn "\\\\COMPARTIDA\Renderings\Resources\KispTools\Scripts\Props\Tool_PlaceProp.ms"	
								)		
							)
							else	messagebox "No object was selected."	
						)  
					)
				)
				dotNet.setLifetimeControl dnbuttonPP #dotnet		
			
				KispToolsV3.myToolTip.SetToolTip dnbuttonPP "Place a prop from the scene over any surface\
Left click:\
\t1:Pick an object.\
\t2:Move around the scene to position object.\
\t3:Click and drag to position and rotate.\
\tRIGHT CLICK ABORTS\
Middle click:\
\t1:Pick an object.\
\t2:Move around the scene to position object.\
\t3:Click and drag to position and rotate\
\tRIGHT CLICK ABORTS"	
					
				
				
				
				
				
				
				
				
				--RETURN FLOW LAYOUT
				--RETURN FLOW LAYOUT
				--RETURN FLOW LAYOUT			
				dnFlow
	),
	/************************************
		METHOD : DoShadingUI
		USE: Returns the UI  for the Shading Category UI
		ARGUMENTS :
				theHeight: the Height of the Shading UI
	*/		
	fn DoShadingUI theHeight=
	(
		--create Image Class
		imageClass = dotNetclass "System.Drawing.image"
		--Load all the icons
	
		--IMAGE LIST 75
		--IMAGE LIST 75
		--IMAGE LIST 75
/*
		imageList75 = dotnetobject "System.Windows.Forms.ImageList"
		imageList75.imagesize = dotnetobject "System.Drawing.Size" 75 75
		
		Image1 = imageClass.fromfile ("\\\\COMPARTIDA\Renderings\Resources\KispTools\Images\Icons\Icon256_NewProject.png")		---Create new Project 
		imageList75.images.add Image1		
*/
		
		--IMAGE LIST 50
		--IMAGE LIST 50
		--IMAGE LIST 50
		imageList50 = dotnetobject "System.Windows.Forms.ImageList"
		imageList50.imagesize = dotnetobject "System.Drawing.Size" 50 50
		
		
		---Quick Material
		---Quick Material
		Image0 = imageClass.fromfile ("\\\\COMPARTIDA\Renderings\Resources\KispTools\Images\Icons\Icon256_QuickMaterial.png")		
		imageList50.images.add Image0	
		
		---Remove Material
		---Remove Material
		Image1 = imageClass.fromfile ("\\\\COMPARTIDA\Renderings\Resources\KispTools\Images\Icons\Icon256_RemoveMaterials.png")		
		imageList50.images.add Image1	
		
		---Transfer Material
		---Transfer Material
		Image2 = imageClass.fromfile ("\\\\COMPARTIDA\Renderings\Resources\KispTools\Images\Icons\Icon256_TransferMaterials.png")		---Create new Project 
		imageList50.images.add Image2			
		
		
		---AssignMaterialMultipleTimes
		---AssignMaterialMultipleTimes
		Image3 = imageClass.fromfile ("\\\\COMPARTIDA\Renderings\Resources\KispTools\Images\Icons\Icon256_AssignMultipleTimes.png")		
		imageList50.images.add Image3			

		--------------------------------------------
		-- FLOW PANEL
		-- FLOW PANEL
		--------------------------------------------
			
		dnFlow= KispToolsV3.DoFlowLayout theHeight
		
		
		--------------------------------------------
		-- BUTTON : QUICK MATERIAL
		-- BUTTON : QUICK MATERIAL
		--------------------------------------------		
				--Create a new Button 				
				dnbuttonQM= DoToolButton imageList50.Images.Item[0] 50					
				dnFlow.controls.add dnbuttonQM				
				dotNet.addEventHandler dnbuttonQM "click" ( 
					fn CreateDirMacro = 
					(
						fileIn "\\\\COMPARTIDA\Renderings\Resources\KispTools\Scripts\Shaders\QuickCreateMaterial.ms" 	
						macros.run "Matanga" "QuickAddMaterial"	
					)  
				)
				dotNet.setLifetimeControl dnbuttonQM #dotnet		
			
				KispToolsV3.myToolTip.SetToolTip dnbuttonQM "Interface for adding a quick material\n to the selected objects"		
		
		
		--------------------------------------------
		-- BUTTON : REMOVE MATERIAL
		-- BUTTON : REMOVE MATERIAL
		--------------------------------------------		
				--Create a new Button 				
				dnbuttonPM= DoToolButton imageList50.Images.Item[1] 50					
				dnFlow.controls.add dnbuttonPM				
				dotNet.addEventHandler dnbuttonPM "click" ( 
					fn CreateDirMacro = 
					(
						undo on
						(
							if(selection.count>0) do
							(
									for o in selection do o.material=undefined
							)		
						)																
					)  
				)
				dotNet.setLifetimeControl dnbuttonPM #dotnet		
			
				KispToolsV3.myToolTip.SetToolTip dnbuttonPM "Remove the material from all selected objects \n"
	
				
		--------------------------------------------
		-- BUTTON : TRANSFER MATERIAL
		-- BUTTON : TRANSFER MATERIAL
		--------------------------------------------		
				--Create a new Button 				
				dnbuttonTM= DoToolButton imageList50.Images.Item[2] 50					
				dnFlow.controls.add dnbuttonTM				
				dotNet.addEventHandler dnbuttonTM "click" ( 
					fn CreateDirMacro = 
					(						
						include "\\\\COMPARTIDA\Renderings\Resources\KispTools\Scripts\Shaders\Tool_TransferMaterial.ms"		
						startTool TransferMaterial prompt:"Hello!"																			
					)  
				)
				dotNet.setLifetimeControl dnbuttonTM #dotnet	
				
				KispToolsV3.myToolTip.SetToolTip dnbuttonTM "Transfer material from one object to another \n Step 1: Click the object with the material \n Step 2: Click the object that will receive the material"
				
				
		--------------------------------------------
		-- BUTTON : ASSIGN MATERIAL MULTIPLE TIMES
		-- BUTTON : ASSIGN MATERIAL MULTIPLE TIMES
		--------------------------------------------		
				--Create a new Button 				
				dnbuttonAMMT= DoToolButton imageList50.Images.Item[3] 50					
				dnFlow.controls.add dnbuttonAMMT				
				dotNet.addEventHandler dnbuttonAMMT "click" ( 
					fn CreateDirMacro = 
					(						
						include "\\\\COMPARTIDA\Renderings\Resources\KispTools\Scripts\Shaders\Tool_AssignMaterialMultipleTimes.ms"		
						startTool AsignMaterialMultipleTimes prompt:"Hello!"																			
					)  
				)
				dotNet.setLifetimeControl dnbuttonAMMT #dotnet	
				
				KispToolsV3.myToolTip.SetToolTip dnbuttonAMMT "Assign current material multiple timesl"
								
				
				
				
				--RETURN FLOW LAYOUT
				--RETURN FLOW LAYOUT
				--RETURN FLOW LAYOUT
				
				dnFlow
	),
	/************************************
		METHOD : DoUVWMappinUI
		USE: Returns the UI  for the UVMapping Category UI
		ARGUMENTS :
				theHeight: the Height of the UVMapping UI
	*/	
	fn DoUVWMappinUI theHeight=
	(
		--create Image Class
		imageClass = dotNetclass "System.Drawing.image"
		--Load all the icons
	
		--IMAGE LIST 75
		--IMAGE LIST 75
		--IMAGE LIST 75
/*
		imageList75 = dotnetobject "System.Windows.Forms.ImageList"
		imageList75.imagesize = dotnetobject "System.Drawing.Size" 75 75
		
		Image1 = imageClass.fromfile ("\\\\COMPARTIDA\Renderings\Resources\KispTools\Images\Icons\Icon256_NewProject.png")		---Create new Project 
		imageList75.images.add Image1		
*/
		
		--IMAGE LIST 50
		--IMAGE LIST 50
		--IMAGE LIST 50
		imageList50 = dotnetobject "System.Windows.Forms.ImageList"
		imageList50.imagesize = dotnetobject "System.Drawing.Size" 50 50
		

		---Quick UVW 8 
		---Quick UVW 8 
		Image1 = imageClass.fromfile ("\\\\COMPARTIDA\Renderings\Resources\KispTools\Images\Icons\Icon256_QuickUV8.png")
		imageList50.images.add Image1					
		
		---Quick UVW 24 
		---Quick UVW 24
		Image2 = imageClass.fromfile ("\\\\COMPARTIDA\Renderings\Resources\KispTools\Images\Icons\Icon256_QuickUV24.png")
		imageList50.images.add Image2			
		
		---Quick UVW Custom
		---Quick UVW Custom
		Image3 = imageClass.fromfile ("\\\\COMPARTIDA\Renderings\Resources\KispTools\Images\Icons\Icon256_QuickUVCustom.png")
		imageList50.images.add Image3			
		
		---Quick UVW Rotate
		---Quick UVW Rotate
		Image4 = imageClass.fromfile ("\\\\COMPARTIDA\Renderings\Resources\KispTools\Images\Icons\Icon256_QuickUVRotate.png")
		imageList50.images.add Image4				
		
				
		--------------------------------------------
		-- FLOW PANEL
		-- FLOW PANEL
		--------------------------------------------
			
		dnFlow= KispToolsV3.DoFlowLayout theHeight

		--------------------------------------------
		-- BUTTON : QUICK UVW8
		-- BUTTON : QUICK UVW8
		--------------------------------------------		
				--Create a new Button 				
				dnbuttonQUVW8= DoToolButton imageList50.Images.Item[0] 50					
				dnFlow.controls.add dnbuttonQUVW8				
				dotNet.addEventHandler dnbuttonQUVW8 "click" ( 
					fn CreateDirMacro = 
					(						
						fileIn "\\\\COMPARTIDA\Renderings\Resources\KispTools\Scripts\Shaders\QuickUVW8.ms"		
						macros.run "Matanga" "AddUVW8Inches"																			
					)  
				)
				dotNet.setLifetimeControl dnbuttonQUVW8 #dotnet	
				
				KispToolsV3.myToolTip.SetToolTip dnbuttonQUVW8 "Add an 8 inches quick UVW cube"
								
		--------------------------------------------
		-- BUTTON : QUICK UVW24
		-- BUTTON : QUICK UVW24
		--------------------------------------------		
				--Create a new Button 				
				dnbuttonQUVW24= DoToolButton imageList50.Images.Item[1] 50					
				dnFlow.controls.add dnbuttonQUVW24				
				dotNet.addEventHandler dnbuttonQUVW24 "click" ( 
					fn CreateDirMacro = 
					(						
						fileIn "\\\\COMPARTIDA\Renderings\Resources\KispTools\Scripts\Shaders\QuickUVW24.ms"		
						macros.run "Matanga" "AddUVW24Inches"																			
					)  
				)
				dotNet.setLifetimeControl dnbuttonQUVW24 #dotnet	
				
				KispToolsV3.myToolTip.SetToolTip dnbuttonQUVW24 "Add an 24 inches quick UVW cube"
				
				
		--------------------------------------------
		-- BUTTON : CUSTOM UVW
		-- BUTTON : CUSTOM UVW
		--------------------------------------------		
				--Create a new Button 				
				dnbuttonQUVWCust= DoToolButton imageList50.Images.Item[2] 50					
				dnFlow.controls.add dnbuttonQUVWCust				
				dotNet.addEventHandler dnbuttonQUVWCust "click" ( 
					fn CreateDirMacro = 
					(						
						fileIn "\\\\COMPARTIDA\Renderings\Resources\KispTools\Scripts\Shaders\QuickUVWCustom.ms"		
						macros.run "Matanga" "AddSpecificUVW"																			
					)  
				)
				dotNet.setLifetimeControl dnbuttonQUVWCust #dotnet	
				
				KispToolsV3.myToolTip.SetToolTip dnbuttonQUVWCust "Add a custom UVW cube"				
				
		--------------------------------------------
		-- BUTTON :  UVW ROTATE
		-- BUTTON :  UVW ROTATE
		--------------------------------------------		
				--Create a new Button 				
				dnbuttonQUVWRot= DoToolButton imageList50.Images.Item[3] 50					
				dnFlow.controls.add dnbuttonQUVWRot				
				dotNet.addEventHandler dnbuttonQUVWRot "click" ( 
					fn CreateDirMacro = 
					(						
						fileIn "\\\\COMPARTIDA\Renderings\Resources\KispTools\Scripts\Shaders\QuickUVWRotate.ms"		
						macros.run "Matanga" "QuickUVWRotate"																			
					)  
				)
				dotNet.setLifetimeControl dnbuttonQUVWRot #dotnet	
				
				KispToolsV3.myToolTip.SetToolTip dnbuttonQUVWRot "Quick UVW Map rotation \nStep 1: Only one object with one UVW Map must be selected"				
				
								
				
				
				
				--RETURN FLOW LAYOUT
				--RETURN FLOW LAYOUT
				--RETURN FLOW LAYOUT
				dnFlow
	),	
	/************************************
		METHOD : DoRenderUI
		USE: Returns the UI  for the Render Category UI
		ARGUMENTS :
				theHeight: the Height of the Render UI
	*/	
	fn DoRenderUI theHeight=
	(
		--create Image Class
		imageClass = dotNetclass "System.Drawing.image"
		--Load all the icons
	
		--IMAGE LIST 75
		--IMAGE LIST 75
		--IMAGE LIST 75
/*
		imageList75 = dotnetobject "System.Windows.Forms.ImageList"
		imageList75.imagesize = dotnetobject "System.Drawing.Size" 75 75
		
		Image1 = imageClass.fromfile ("\\\\COMPARTIDA\Renderings\Resources\KispTools\Images\Icons\Icon256_NewProject.png")		---Create new Project 
		imageList75.images.add Image1		
*/
		
		--IMAGE LIST 50
		--IMAGE LIST 50
		--IMAGE LIST 50
		imageList50 = dotnetobject "System.Windows.Forms.ImageList"
		imageList50.imagesize = dotnetobject "System.Drawing.Size" 50 50
		
		
		---Setup Vray Steresocopic
		---Setup Vray Steresocopic
		Image0 = imageClass.fromfile ("\\\\COMPARTIDA\Renderings\Resources\KispTools\Images\Icons\Icon256_SetupStereo.png")		
		imageList50.images.add Image0	
		
	
		
		--------------------------------------------
		-- FLOW PANEL
		-- FLOW PANEL
		--------------------------------------------
			
		dnFlow= KispToolsV3.DoFlowLayout theHeight
		
		
		--------------------------------------------
		-- BUTTON : SETUP VRAY STEREOSCOPIC
		-- BUTTON : SETUP VRAY STEREOSCOPIC
		--------------------------------------------		
				--Create a new Button 				
				dnbuttonQS= DoToolButton imageList50.Images.Item[0] 50					
				dnFlow.controls.add dnbuttonQS				
				dotNet.addEventHandler dnbuttonQS "click" ( 
					fn CreateDirMacro = 
					(
						fileIn "\\\\COMPARTIDA\Renderings\Resources\KispTools\Scripts\Render\SetupVRayStereoRender.ms" 	
						macros.run "Matanga" "SetupVRayStereoCamera"	
					)  
				)
				dotNet.setLifetimeControl dnbuttonQS #dotnet		
			
				KispToolsV3.myToolTip.SetToolTip dnbuttonQS "Setup the scene to render a Steresocopic image"		
		
		

				
				--RETURN FLOW LAYOUT
				--RETURN FLOW LAYOUT
				--RETURN FLOW LAYOUT
				dnFlow
	),	
	/************************************
		METHOD : DoRenderUI
		USE: Returns the UI  for the Random Utilities Category UI
		ARGUMENTS :
				theHeight: the Height of the Random Utilities UI
	*/	
	fn DoRandomutilsUI theHeight=
	(
		--create Image Class
		imageClass = dotNetclass "System.Drawing.image"
		--Load all the icons
	
		--IMAGE LIST 75
		--IMAGE LIST 75
		--IMAGE LIST 75
/*
		imageList75 = dotnetobject "System.Windows.Forms.ImageList"
		imageList75.imagesize = dotnetobject "System.Drawing.Size" 75 75
		
		Image1 = imageClass.fromfile ("\\\\COMPARTIDA\Renderings\Resources\KispTools\Images\Icons\Icon256_NewProject.png")		---Create new Project 
		imageList75.images.add Image1		
*/
		
		--IMAGE LIST 50
		--IMAGE LIST 50
		--IMAGE LIST 50
		imageList50 = dotnetobject "System.Windows.Forms.ImageList"
		imageList50.imagesize = dotnetobject "System.Drawing.Size" 50 50
		
		
		---Quick Material
		---Quick Material
		Image0 = imageClass.fromfile ("\\\\COMPARTIDA\Renderings\Resources\KispTools\Images\Icons\Icon256_CadCleaner.png")		
		imageList50.images.add Image0	
		
		
		
		--------------------------------------------
		-- FLOW PANEL
		-- FLOW PANEL
		--------------------------------------------
			
		dnFlow= KispToolsV3.DoFlowLayout theHeight
		
		
		--------------------------------------------
		-- BUTTON : QUICK MATERIAL
		-- BUTTON : QUICK MATERIAL
		--------------------------------------------		
				--Create a new Button 				
				dnbuttonQM= DoToolButton imageList50.Images.Item[0] 50					
				dnFlow.controls.add dnbuttonQM				
				dotNet.addEventHandler dnbuttonQM "click" ( 
					fn CreateDirMacro = 
					(
						fileIn "\\\\COMPARTIDA\Renderings\Resources\KispTools\Scripts\Utilities\CadCleaner.ms" 	
						macros.run "Matanga" "CadCleanerV1"	
					)  
				)
				dotNet.setLifetimeControl dnbuttonQM #dotnet		
			
				KispToolsV3.myToolTip.SetToolTip dnbuttonQM "Cleans imported dwg files"		

				
				
				
				
				
		--RETURN FLOW LAYOUT
		--RETURN FLOW LAYOUT
		--RETURN FLOW LAYOUT
				dnFlow
	),	
	--------------------------------------------
	--------------------------------------------
	-- MAIN PANELS
	-- MAIN PANELS
	--------------------------------------------
	--------------------------------------------	
	
	/************************************
		METHOD :initContentPanel
		USE: Initializes the Content Panel with all the necessary UI Categories Buttons
		ARGUMENTS :
					Sender: dotNetObject Panel
	*/
	fn initContentPanel sender =
	(
		if(sender.controls.count !=0)do	sender.controls.clear()
		
		--------------------------------------------
		--FLOW PANEL
		--FLOW PANEL
		--------------------------------------------	
		dnFlow= dotNetObject "flowLayoutPanel"
		dnFlow.Flowdirection = dnFlow.Flowdirection.TopDown
		dnFlow.bounds =KispToolsV3.dnRec s:[sender.width, sender.height]
		dnFlow.BorderStyle=dnFlow.BorderStyle.none
	
		sender.controls.add dnFlow	

		--------------------------------------------
		--BUTTON PROJECT MANAGEMENT
		--BUTTON PROJECT MANAGEMENT
		--------------------------------------------
		dnButtonPM=KispToolsV3.DoCategoryButton "Project Management"
		
		dnFlow.controls.add dnButtonPM
		
		dotNet.addEventHandler dnButtonPM "click" ( fn CreateDirMacro = 
																								(
																										KispToolsV3.showPMUI =not KispToolsV3.showPMUI
																										KispToolsV3.initContentPanel KispToolsV3.thePanel2
																								)
																	)
		dotNet.setLifetimeControl dnButtonPM #dotnet		
		
		
		--------------------------------------------
		--PM MENU
		--PM MENU
		--------------------------------------------

		if(KispToolsV3.showPMUI ==true) do
		(
			pmUi=KispToolsV3.DoPMUI 75
			dnFlow.controls.add pmUi			
		)
			
			
		--------------------------------------------
		--BUTTON PROPS
		--BUTTON PROPS
		--------------------------------------------
		dnButtonProps=KispToolsV3.DoCategoryButton "Props"

		dnFlow.controls.add dnButtonProps		
		
		dotNet.addEventHandler dnButtonProps "click" ( fn CreateDirMacro = 
																								(
																										KispToolsV3.showPropsUI =not KispToolsV3.showPropsUI
																										KispToolsV3.initContentPanel KispToolsV3.thePanel2
																								)	)
		dotNet.setLifetimeControl dnButtonProps #dotnet		
				
		--------------------------------------------
		--PROPS MENU
		--PROPS MENU
		--------------------------------------------

		if(KispToolsV3.showPropsUI ==true) do
		(
			propsUi=KispToolsV3.DoPropsUI 125
			dnFlow.controls.add propsUi			
		)
		
		--------------------------------------------
		--BUTTON SHADERS
		--BUTTON SHADERS
		--------------------------------------------
		dnButtonShading=KispToolsV3.DoCategoryButton "Shaders"
		
		dnFlow.controls.add dnButtonShading
		
		dotNet.addEventHandler dnButtonShading "click" ( fn CreateDirMacro = 
																								(
																										KispToolsV3.showShadingUI =not KispToolsV3.showShadingUI
																										KispToolsV3.initContentPanel KispToolsV3.thePanel2
																								)	)
		dotNet.setLifetimeControl dnButtonShading #dotnet		
	
		--------------------------------------------
		--SHADING MENU
		--SHADING MENU
		--------------------------------------------

		if(KispToolsV3.showShadingUI ==true) do
		(
			propsUi=KispToolsV3.DoShadingUI 100
			dnFlow.controls.add propsUi			
		)
		
		--------------------------------------------
		--BUTTON UVWMAPPING
		--BUTTON UVWMAPPING
		--------------------------------------------
		dnButtonUVWMapping=KispToolsV3.DoCategoryButton "UVW Mapping"
		
		dnFlow.controls.add dnButtonUVWMapping
		
		dotNet.addEventHandler dnButtonUVWMapping "click" ( fn CreateDirMacro = 
																								(
																										KispToolsV3.showUVWMappingUI =not KispToolsV3.showUVWMappingUI
																										KispToolsV3.initContentPanel KispToolsV3.thePanel2
																								)	)
		dotNet.setLifetimeControl dnButtonUVWMapping #dotnet		
	
		--------------------------------------------
		--UVWMAPPING MENU
		--UVWMAPPING MENU
		--------------------------------------------

		if(KispToolsV3.showUVWMappingUI ==true) do
		(
			mappingUI=KispToolsV3.DoUVWMappinUI 100
			dnFlow.controls.add mappingUI			
		)		
		
		
		
		
		
		--------------------------------------------
		--BUTTON RENDER
		--BUTTON RENDER
		--------------------------------------------
		dnButtonRE=KispToolsV3.DoCategoryButton "Render"
		
		dnFlow.controls.add dnButtonRE
		
		dotNet.addEventHandler dnButtonRE "click" ( fn CreateDirMacro = 
																								(
																										KispToolsV3.showRenderUI =not KispToolsV3.showRenderUI
																										KispToolsV3.initContentPanel KispToolsV3.thePanel2
																								)
																	)
		dotNet.setLifetimeControl dnButtonRE #dotnet		
		
		
		--------------------------------------------
		--RANDOM UTILITIES MENU
		--RANDOM UTILITIES MENU
		--------------------------------------------

		if(KispToolsV3.showRenderUI ==true) do
		(
			renderUI=KispToolsV3.DoRenderUI 50
			dnFlow.controls.add renderUI			
		)
		
		
		--------------------------------------------
		--BUTTON RANDOM UTILITIES
		--BUTTON RANDOM UTILITIES
		--------------------------------------------
		dnButtonRU=KispToolsV3.DoCategoryButton "Utilities"
		
		dnFlow.controls.add dnButtonRU
		
		dotNet.addEventHandler dnButtonRU "click" ( fn CreateDirMacro = 
																								(
																										KispToolsV3.showRandomUtilsUI =not KispToolsV3.showRandomUtilsUI
																										KispToolsV3.initContentPanel KispToolsV3.thePanel2
																								)
																	)
		dotNet.setLifetimeControl dnButtonRU #dotnet		
		
		
		--------------------------------------------
		--RANDOM UTILITIES MENU
		--RANDOM UTILITIES MENU
		--------------------------------------------

		if(KispToolsV3.showRandomUtilsUI ==true) do
		(
			pmRU=KispToolsV3.DoRandomutilsUI 50
			dnFlow.controls.add pmRU			
		)
		
		
	
	),	
	
	/************************************
		METHOD :initHeader
		USE:Initialiazes the header of the KispTools
		ARGUMENTS :
					Sender:dotNetObject Panel
	*/
	fn initHeader sender =
	(
		------------------------------DOCK----------------------------------------
		------------------------------DOCK----------------------------------------
		dnButtonDock=dotNetObject "button"
		dnButtonDock.bounds = KispToolsV3.dnRec s:[sender.width, sender.height]
		dnButtonDock.text="Matanga`s Kisp Tools"
		dnButtonDock.flatStyle=dnButtonDock.flatStyle.Flat
		dnButtonDock.backColor =KispToolsV3.dnColor c:[200,200,200] a:255

		sender.controls.add dnButtonDock		
		
		
		dotNet.addEventHandler dnButtonDock "click" ( fn CreateDirMacro = (
																											KispToolsV3.TryDock()
																									)  
																					)
	    dotNet.setLifetimeControl dnButtonDock #dotnet

		------------------------------DOCK----------------------------------------
		------------------------------DOCK----------------------------------------			
	),
	/************************************
		METHOD :initToolTip
		USE:Initializes and returns a dotnetObject Tooltip 
	*/
	fn initToolTip = 
	(
		newTooltip = dotnetObject "ToolTip"

		newTooltip.AutoPopDelay = 5000
		newTooltip.InitialDelay = 300
		newTooltip.ReshowDelay = 300
		newTooltip.ShowAlways = true	
		
		newTooltip
	),
	/************************************
		METHOD : initSplicContainer
		USE:Initializes the Main dotnetObject SplitContainer that the tools will use
		ARGUMENTS :
					Sender:dotnetObject 
	*/	
	fn initSplicContainer sender =
	(
		--Configure the SplitContainer Preferences
		sender.panel1.backColor =KispToolsV3.dnColor c:(maxBackColor*255) a:255
		sender.panel2.backColor =KispToolsV3.dnColor c:(maxBackColor*255) a:255
		sender.orientation = sender.orientation.horizontal
		sender.splitterDistance=50
		sender.splitterWidth=1
		sender.isSplitterFixed=true
		
		------------------------------------------------
		----TOOLTIP
		----TOOLTIP
		------------------------------------------------
		KispToolsV3.myToolTip = KispToolsV3.initToolTip()


		
		------------------------------------------------
		----TOOLTIP
		----TOOLTIP
		------------------------------------------------		
		sender.padding= sender.padding.empty
		sender.margin= sender.margin.empty
		
		sender.panel1.padding= sender.padding.empty
		sender.panel1.margin= sender.margin.empty
		
		sender.panel2.padding= sender.padding.empty
		sender.panel2.margin= sender.margin.empty
		
		--Initialize the Header
		initHeader sender.panel1
		
		--Initialize the Content Panel

		KispToolsV3.thePanel2=sender.panel2

		initContentPanel sender.panel2
		
		
	),
	
	--------------------------------------------
	--------------------------------------------
	-- LAUNCH  UI
	--------------------------------------------
	--------------------------------------------
	/************************************
		METHOD : ui
		USE: Starts the tool`s UI
	*/
	fn ui =
	(	
		rollout KispToolsUI "KispTools" width:150 height:950
		(
			
			dotnetcontrol splitCon "system.windows.forms.splitContainer"  \
			width: (KispToolsUI.width)\
			height:(KispToolsUI.height)\
			offset:[-13,-5]

			
			on KispToolsUI open do
			(
				initSplicContainer splitCon
				splitCon.padding= splitCon.padding.empty
				splitCon.margin= splitCon.margin.empty
			)
			
			on splitCon Paint args do
			(
				if (KispToolsV3.doRefresh==true) then
				(
				   KispToolsV3.doRefresh = false
				   splitCon.refresh()
				   KispToolsV3.doRefresh = true
				 )
			)			
			
			
		)		
		createDialog KispToolsUI
		KispToolsV3.myInst =KispToolsUI
	),
	/************************************
		METHOD :run
		USE: Method that starts everything
	*/
	fn run=
	(	--Try to destroy Kisp Tools if it already exists
		try
		( 
			t=windows.getChildHWND 0 "KispTools"
			UIAccessor.CloseDialog t[1]
		)
		catch()
			
		if(KispToolsV3.myInst == undefined) then
		(
			ui()
		)
		else
		(
			KispToolsV3.myInst=undefined
		)		
	)	
)

global KispToolsV3=KispToolsV3()
KispToolsV3.run()

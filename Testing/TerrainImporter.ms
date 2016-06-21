
		--thePos=polyop.getVert $ 1
		--polyop.setVert $ #(1) [thePos.x,thePos.y,10]


global RLTTerrainFromRaw
global myTerrain

struct TerrainGrid
(
	--General Settings
	myBitmap=undefined,
	terrainSegmentsCount=undefined,
	terrainTotalSubdivisions=undefined,
	
	--Terrain
	terrainSize =[0,0],
	terrainHeight=undefined,
	
	--Nodes
	nodeGrid=#(),	
	nodeSize=undefined,
	terrainNodeSubdivisions=undefined,
	
	--Bitmap
	bitmapGrid=#(),
	

	
	
	----------------------------
	--DATA INITIALIZATION
	--DATA INITIALIZATION -- for now must be done in the same order that the functions appear
	--DATA INITIALIZATION
	----------------------------
	function SetBitmap theBitmap = 
	( 
		myBitmap = theBitmap 
		terrainTotalSubdivisions=theBitmap.width-1
		print ("My bitmap is "+theBitmap.filename as string +". There are "+terrainTotalSubdivisions as string+" total terrain subdivisions.")
	),
	function SetSegmentCount theSegmentCount = 
	( 
		terrainSegmentsCount = theSegmentCount
		terrainNodeSubdivisions=terrainTotalSubdivisions/theSegmentCount
		print ("The segment count is "+terrainSegmentsCount as string+". Nodes will have "+terrainNodeSubdivisions as string+" subdivisions.")
	),
	function SetTerrainSize theSize = 
	( 
		terrainSize = theSize 
		nodeSize = terrainSize.x / terrainSegmentsCount
		print ("The total terrain size will be "+terrainSize.x as string+". Nodes will have a size of "+nodeSize as string)
	),		
	function SetHeight theHeight = ( terrainHeight = theHeight ),
	
	
	----------------------------
	--GRID INITIALIZATION
	--GRID INITIALIZATION
	--GRID INITIALIZATION
	----------------------------
	function GetBitmapRegion origin regionSize =
	(
		theRegion=#()
		startPosX=origin.x
		startPosY=origin.y	
		
		for x =0 to (regionSize) by 1 do
		(
			theNodeRow =getPixels myBitmap [startPosX , startPosY ] (regionSize+1)
			if (theNodeRow.count != 0) do append theRegion theNodeRow
			startPosY=startPosY+1
		)
		
		theRegion
	),
	
	function CreateBitmapGrid =
	(
		bitmapGrid=#()
		offsetX=0
		
		for x =1 to terrainSegmentsCount by 1 do
		(
			offsetY=0
			gridRow=#()			
			for y=1 to terrainSegmentsCount by 1 do
			(				
				append gridRow (GetBitmapRegion [offsetX ,offsetY ] terrainNodeSubdivisions  )
				offsetY =offsetY+ terrainNodeSubdivisions
			)
			append bitmapGrid gridRow
			offsetX=offsetX +terrainNodeSubdivisions
		)
	),		

	function DebugGridNode =
	(
		for o=1 to bitmapGrid.count by 1 do
		(
			for y=1 to bitmapGrid[o].count by 1 do
			(
					print bitmapGrid[o][y]
					print (" +++++++++++++++++ ")
			)
			print (" ----------------------------- ")
		)
		
	),
	
	----------------------------
	--TERRAIN INITIALIZATION
	--TERRAIN INITIALIZATION
	--TERRAIN INITIALIZATION
	----------------------------
	function GetHeightFromColor theColor = 
	(
		theVal=theColor.r as float
		theVertexHeight= (theVal*terrainHeight)/255.0
		theVertexHeight
	),
	
	function ApplyHeightToNode theNode theHeightInfo =
	(
		print ("Applying height" + theNode.name)
		
		vertexCounter=1
		for o=1 to theHeightInfo.count by 1 do
		(
			for y=1 to theHeightInfo[o].count by 1 do
			(					
					thePos=polyop.getVert theNode vertexCounter
					polyop.setVert theNode #{vertexCounter} [thePos.x,thePos.y,(GetHeightFromColor theHeightInfo[o][y] )]
					vertexCounter=vertexCounter+1
			)
		)
		
	),
	
	function CreateTerrainNodes = 
	(
		offsetY=0
		for x=1 to terrainSegmentsCount do
		(
			newRow=#()	--Row for the array of the next row
			offsetX=0		
			for y=1 to terrainSegmentsCount do
			(
				newNode= Plane length:nodeSize width:nodeSize pos:[offsetX,offsetY,0] widthsegs:(terrainNodeSubdivisions) lengthsegs:(terrainNodeSubdivisions) 
				newNode.backfacecull = on					
				ConvertTo newNode Editable_Poly
				rotate newNode (angleaxis -180 [1,0,0])
				
				newMod= Normalmodifier()
				newMod.flip=true
				addmodifier newNode (newMod)
				resetxform newNode
				maxOps.CollapseNode newNode off	
				
				--ApplyHeightToNode newNode bitmapGrid[x][y]
				
				append newRow newNode
				offsetX=offsetX+nodeSize
			)
			append nodeGrid  newRow
			offsetY=offsetY-nodeSize
		)		
	),
	
	
	----------------------------
	--UTILITIES
	--UTILITIES
	--UTILITIES
	----------------------------

	function SetTerrainPixel theCoords theValue =
	(
	

		
	),	
	function GetBitmapPixelsRow =
	(
		
		for o=0 to (terrainNodeSubdivisions-1) by 1 do
		(
			theNodeRow =getPixels myBitmap [0 , o ] terrainNodeSubdivisions
			
		)
		
	)
	
)

--**************************************************  ****************************
--*
--*  extractBitmapChannel
--*  by Ofer Zelichover (c) 
--*  Started: 2008/08/20
--*  http://www.oferz.com  ; maxscripts@oferz.com
--*
--**************************************************  ****************************


   -- This function uses the dotNet graphics object with color matrix to extract
   -- a specific channel from a bitmap.
   -- Valid chan values: #Red, #Green, #Blue, #R, #G, #B
   fn ConvertToDotnetBitmap bm  =
   (	   
	   -- Copy the bitmap to the clipboard to pass it to dotNet
	   setClipboardBitmap  bm
	   -- Create a dotNet clipboard object.
	   local clipboardObj = dotNetClass "System.Windows.Forms.Clipboard"
	   -- Get the image from the clipboard into a dotNet image object.
	   local imgObj = clipboardObj.GetImage()
	   -- Create a dotNet colorMatrix object.
	   local colorMatArray = #( \
		   #(if chan == #R then 1 else 0, 0, 0, 0, 0), \
		   #(0, if chan == #G then 1 else 0, 0, 0, 0), \
		   #(0, 0, if chan == #B then 1 else 0, 0, 0), \
		   #(0, 0, 0, 1, 0), \
		   #(0, 0, 0, 0, 1) 
	   )
	   local colorMatrixObj = dotNetObject "System.Drawing.Imaging.ColorMatrix" colorMatArray
	   -- Create a dotNet ImageAttributes object to assign the color matrix to the image.
	   local imageAttrsObj = dotNetObject "System.Drawing.Imaging.ImageAttributes"
	   imageAttrsObj.SetColorMatrix colorMatrixObj (dotNetClass "System.Drawing.Imaging.ColorMatrixFlag").Default (dotNetClass "System.Drawing.Imaging.ColorAdjustType").Default
	   
	   -- Create a dotNet graphics object. This will be used to render the image using the color matrix.
	   local graphicsObj = (dotNetClass "System.Drawing.Graphics").FromImage(imgObj)
	   -- Render the image using the color matrix:
	   local rect = dotNetObject "System.Drawing.Rectangle" 0 0 imgObj.Width imgObj.Height
	   local graphicsUnit = (dotNetClass "System.Drawing.GraphicsUnit").Pixel
	   graphicsObj.DrawImage imgObj rect 0 0 imgObj.Width imgObj.Height graphicsUnit imageAttrsObj
	  

	   -- copy the rendered image into the clipboard.
	   clipboardObj.setImage(imgObj)
	   -- Get the image from the clipboard back into maxscript
	   local newBm = getClipboardBitmap()
	   
	   --Clean up
	   clipboardObj = undefined
	   graphicsObj.Dispose(); graphicsObj = undefined
	   rect = undefined
	   graphicsUnit = undefined
	   imgObj.Dispose(); imgObj = undefined
	   imageAttrsObj.Dispose(); imageAttrsObj = undefined
	   colorMatrixObj = undefined
	   -- You may wish to comment out the GC command if it's too slow.
	   gc light:true
	   -- Return the new bitmap
	   newBM
   )


function CreateTerrain =	
(
		myTerrain= TerrainGrid()	
		myTerrain.SetBitmap (RLTTerrainFromRaw.choosemap.map.bitmap)
		myTerrain.SetSegmentCount (RLTTerrainFromRaw.spnSegments.value)
		myTerrain.SetTerrainSize ([RLTTerrainFromRaw.spnTerrainSize.value,RLTTerrainFromRaw.spnTerrainSize.value])
		myTerrain.SetHeight 100
		myTerrain.CreateBitmapGrid()
		myTerrain.CreateTerrainNodes()	

		--myTerrain.DebugGridNode()
)



function createTerrainSegment startCoords =
(
	
	currMasterPixel=0
	currCountPixel=0	-- uses segment.count
	theCountSize = (texmap.width-1)/segment.count
	

)




rollout RLTTerrainFromRaw "Terrain From Raw "
(
	mapbutton choosemap "<<none>>" tooltip:"Select Background Map" width:120
	
	label lblMapWidth "Width:" align:#left
	
	spinner spnTerrainSize	"Size:          "	align:#left	range:[1,100000,1000] type:#integer 	
	spinner spnSegments 	"Segments: " 	align:#left	range:[1,100000,4] type:#integer	
	
	button btnDoIt "Do IT" 
	
	on choosemap picked texmap do
  (
		choosemap.text= texmap as string
		showproperties texmap
		lblMapWidth.text =("Width: "+texmap.bitmap.width as string)	
		print texmap.filename
		global bmpDisplayed = dotNetObject "System.Drawing.Bitmap" (texmap.filename as string)	  
  )
	
	on btnDoIt pressed do
	(
		btnDoIt.enabled=false
		CreateTerrain()		
	)
	
)




createDialog RLTTerrainFromRaw width:200 height:200
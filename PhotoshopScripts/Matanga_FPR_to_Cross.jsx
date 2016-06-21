var originalDocRef= app.activeDocument

var originalUnit =preferences.rulerUnits
preferences.rulerUnits = Units.PIXELS


/*
	CREATE THE FLIPPED TEMP DOCUMENT 
*/
var tempDocRef = app.documents.add( 9216, 1536 ) 
/*Go to the original document*/
app.activeDocument=originalDocRef
/*Define the area to be used*/
var cubemapArea= [ [0,0],[9216,0],[9216,1536],[0,1536] ]
/*Select it*/
app.activeDocument.selection.select(cubemapArea)
/*Copy the selection*/
app.activeDocument.selection.copy()
/*Switch to the temp document*/
app.activeDocument= tempDocRef
/*Paste the info*/
app.activeDocument.paste()
app.activeDocument.flipCanvas(Direction.HORIZONTAL)


/*
	Start copying the faces from the temp document to the final one
*/


var crossDocRef= app.documents.add( 6144, 4608 ) 
crossDocRef.name=originalDocRef.name

///FACE 6
///FACE 6
		/*Define bounds for Face 6*/
		//var currSel= [ [0,0],[0,1536],[1536,1536],[1536,0] ]
		CutFromOriginal([ [0,0],[0,1536],[1536,1536],[1536,0] ])
		PasteInNew([ [4608,1536],[6144,1536],[6144,3072],[4608,3072] ])

///FACE 5
///FACE 5
/*Face 5*/
		CutFromOriginal([ [1536,0],[3072,0],[3072,1536],[1536,1536] ])
		PasteInNew([ [1536,1536],[3072,1536],[3072,3072],[1536,3072] ])

///FACE 4
///FACE 4
/*Face 4*/
		CutFromOriginal([ [3072,0],[4608,0],[4608,1536],[3072,1536] ])
		PasteInNew([ [1536,3072],[3072,3072],[3072,4608],[1536,4608] ])

///FACE 3
///FACE 3
/*Face 3*/
		CutFromOriginal([ [4608,0],[6144,0],[6144,1536],[4608,1536] ])
		PasteInNew([ [1536,0],[3072,0],[3072,1536],[1536,1536] ] )

///FACE 2
///FACE 2
/*Face 2*/
		CutFromOriginal([ [6144,0],[7680,0],[7680,1536],[6144,1536] ])
 		PasteInNew([ [3072,1536],[4608,1536],[4608,3072],[3072,3072] ])

///FACE 2
///FACE 2
/*Face 1*/
		CutFromOriginal([ [7680,0],[9216,0],[9216,1536],[7680,1536] ])
		PasteInNew([ [0,1536],[1536,1536],[1536,3072],[0,3072] ])

//NAME OF THE NEW FILE
//NAME OF THE NEW FILE


var theString =originalDocRef.name
var res = theString.substring(0, theString.length-4);
var last =originalDocRef.path.toString()+ "/"+ res+"_360.jpg"


jpgFile = new File( last )
jpgSaveOptions = new JPEGSaveOptions()
jpgSaveOptions.embedColorProfile = true
jpgSaveOptions.formatOptions = FormatOptions.STANDARDBASELINE
jpgSaveOptions.matte = MatteType.NONE
jpgSaveOptions.quality = 12
crossDocRef.saveAs(jpgFile, jpgSaveOptions, true,Extension.LOWERCASE)


last=null
res=null
theString=null

function CutFromOriginal(cutPosition)
{
		/*Go to the Temp Document*/
		app.activeDocument= tempDocRef
		/*Select it*/
		app.activeDocument.selection.select(cutPosition)
		/*Copy the selection*/
		app.activeDocument.selection.copy()
		/*Switch to the temp document*/

}


function PasteInNew(pastePosition)
{
		/*Switch to the temp document*/
		app.activeDocument= crossDocRef
		/*Select it*/
		app.activeDocument.selection.select(pastePosition)
		/*Paste the info*/
		app.activeDocument.paste(true)
}


tempDocRef.close(SaveOptions.DONOTSAVECHANGES)
//originalDocRef.close(SaveOptions.DONOTSAVECHANGES)



app.preferences.rulerUnits=originalUnit

originalUnit=null

originalDocRef=null
crossDocRef=null
tempDocRef=null
currSel=null

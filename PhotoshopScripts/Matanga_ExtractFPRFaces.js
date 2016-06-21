var originalDocRef= app.activeDocument
var originalUnit =preferences.rulerUnits
preferences.rulerUnits = Units.PIXELS



/*Go to the original document*/
//app.activeDocument=originalDocRef

/*
	Start copying the faces from the temp document to the final one
*/

var counter = 1 
//First create the document of size 1536 * 1536 )
var tempDocRef = app.documents.add( 1536, 1536 ) 


///FACE 1
		CutFromOriginal([ [0,0],[0,1536],[1536,1536],[1536,0] ])
		PasteInNewDocInPlace(tempDocRef, [ [0,0],[0,1536],[1536,1536],[1536,0] ])
		SaveCurrentFace()

///FACE 2
		CutFromOriginal([ [1536,0],[3072,0],[3072,1536],[1536,1536] ])
		PasteInNewDocInPlace(tempDocRef,[ [0,0],[0,1536],[1536,1536],[1536,0] ])
		SaveCurrentFace()
///FACE 3
		CutFromOriginal([ [3072,0],[4608,0],[4608,1536],[3072,1536] ])
		PasteInNewDocInPlace(tempDocRef,[ [0,0],[0,1536],[1536,1536],[1536,0] ])
		SaveCurrentFace()
///FACE 4
		CutFromOriginal([ [4608,0],[6144,0],[6144,1536],[4608,1536] ])
		PasteInNewDocInPlace(tempDocRef,[ [0,0],[0,1536],[1536,1536],[1536,0] ])
		SaveCurrentFace()
///FACE 5
		CutFromOriginal([ [6144,0],[7680,0],[7680,1536],[6144,1536] ])
		PasteInNewDocInPlace(tempDocRef,[ [0,0],[0,1536],[1536,1536],[1536,0] ])
		SaveCurrentFace()
///FACE 6
		CutFromOriginal([ [7680,0],[9216,0],[9216,1536],[7680,1536] ])
		PasteInNewDocInPlace(tempDocRef,[ [0,0],[0,1536],[1536,1536],[1536,0] ])
		SaveCurrentFace()
///FACE 7
		CutFromOriginal([ [9216,0],[10752,0],[10752,1536],[9216,1536] ])
		PasteInNewDocInPlace(tempDocRef,[ [0,0],[0,1536],[1536,1536],[1536,0] ])
		SaveCurrentFace()
///FACE 8
		CutFromOriginal([ [10752,0],[12288,0],[12288,1536],[10752,1536] ])
		PasteInNewDocInPlace(tempDocRef,[ [0,0],[0,1536],[1536,1536],[1536,0] ])
		SaveCurrentFace()
///FACE 9
		CutFromOriginal([ [12288,0],[13824,0],[13824,1536],[12288,1536] ])
		PasteInNewDocInPlace(tempDocRef,[ [0,0],[0,1536],[1536,1536],[1536,0] ])
		SaveCurrentFace()
///FACE 10
		CutFromOriginal([ [13824,0],[15360,0],[15360,1536],[13824,1536] ])
		PasteInNewDocInPlace(tempDocRef,[ [0,0],[0,1536],[1536,1536],[1536,0] ])
		SaveCurrentFace()
///FACE 11
		CutFromOriginal([ [15360,0],[16896,0],[16896,1536],[15360,1536] ])
		PasteInNewDocInPlace(tempDocRef,[ [0,0],[0,1536],[1536,1536],[1536,0] ])
		SaveCurrentFace()
///FACE 12
		CutFromOriginal([ [16896,0],[18432,0],[18432,1536],[16896,1536] ])
		PasteInNewDocInPlace(tempDocRef,[ [0,0],[0,1536],[1536,1536],[1536,0] ])
		SaveCurrentFace()



counter=null
tempDocRef.close(SaveOptions.DONOTSAVECHANGES)
//originalDocRef.close(SaveOptions.DONOTSAVECHANGES)



app.preferences.rulerUnits=originalUnit

originalUnit=null

originalDocRef=null
tempDocRef=null
currSel=null


function SaveCurrentFace()
{
	//Create the name of the file
	var theString =originalDocRef.name
	var res = theString.substring(0, theString.length-4);
	var last =originalDocRef.path.toString()+ "/"+ res +"_"+counter.toString()
	counter=counter+1
	jpgFile = new File( last )
	jpgSaveOptions = new JPEGSaveOptions()
	jpgSaveOptions.embedColorProfile = true
	jpgSaveOptions.formatOptions = FormatOptions.STANDARDBASELINE
	jpgSaveOptions.matte = MatteType.NONE
	jpgSaveOptions.quality = 12
	tempDocRef.saveAs(jpgFile, jpgSaveOptions, true,Extension.LOWERCASE)
	last=null
	res=null
	theString=null
}

function PasteInNewDocInPlace(theDoc,pastePosition)
{
		/*Switch to the temp document*/
		app.activeDocument= theDoc
		/*Select it*/
		//app.activeDocument.selection.select(pastePosition)
		theDoc.selection.select(pastePosition)
		/*Paste the info*/
		
		//app.activeDocument.paste(true)
		theDoc.paste(true)
}

function CutFromOriginal(cutPosition)
{
		/*Go to the Temp Document*/
		app.activeDocument= originalDocRef
		/*Select it*/
		app.activeDocument.selection.select(cutPosition)
		/*Copy the selection*/
		app.activeDocument.selection.copy()

}
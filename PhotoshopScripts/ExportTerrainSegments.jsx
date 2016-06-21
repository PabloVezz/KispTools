#target photoshop

var originalDocRef= app.activeDocument;
var originalUnit =preferences.rulerUnits;
var segmentCount = 4;
var gridSize= originalDocRef.width -1;
var segmentSize=(gridSize /4)+1;
preferences.rulerUnits = Units.PIXELS;




/*
    $.writeln ((originalDocRef.width).toString ());
    $.writeln ((originalDocRef.height).toString ());
    $.writeln ((gridSize).toString ());
    $.writeln ((segmentSize).toString ());
*/

function SaveCurrentFace(theDoc,theName)
{
	var last =originalDocRef.path.toString()+ "/"+ theName

	jpgFile = new File( last )
	jpgSaveOptions = new JPEGSaveOptions()
	jpgSaveOptions.embedColorProfile = true
	jpgSaveOptions.formatOptions = FormatOptions.STANDARDBASELINE
	jpgSaveOptions.matte = MatteType.NONE
	jpgSaveOptions.quality = 12
	theDoc.saveAs(jpgFile, jpgSaveOptions, true,Extension.LOWERCASE)
	last=null
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


		
        
var newDoc = app.documents.add( (segmentSize), (segmentSize) )
var segmentSelectionSize= [ [0,0],[0,segmentSize],[segmentSize,segmentSize],[segmentSize,0] ]

function SaveTerrainTiles()
{
       //Flip the Image
    originalDocRef.flipCanvas(Direction.VERTICAL)  
    //Setup the reference offset values
    var originX=0;
    var originY=0;
    //Itarate over the image and extract all tiles
    for(x=1;x<=segmentCount;x++)
    {
        originX=1;
        for(y=1;y<=segmentCount;y++)
        {
             CutFromOriginal([ [originX,originY],[originX,originY+segmentSize],[originX+segmentSize,originY+segmentSize],[originX+segmentSize,originY] ])
            PasteInNewDocInPlace(newDoc, segmentSelectionSize)
             SaveCurrentFace ( newDoc, ( (x).toString() + (y).toString() ) )         
             originX=originX+(segmentSize-1);
        }       
        originY=originY+(segmentSize-1);
     }
    originX=null
    originY=null
    
    originalDocRef.flipCanvas(Direction.VERTICAL)
}




    
    
    SaveTerrainTiles()
    
    
    
    app.preferences.rulerUnits=originalUnit;

     originalDocRef=null;
     originalUnit =null;
     segmentCount =null;
     gridSize=null;
     segmentSize=null;
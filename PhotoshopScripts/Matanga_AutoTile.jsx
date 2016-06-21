//Initial References
var originalDocRef= app.activeDocument
var originalUnit =preferences.rulerUnits
//Change Preferences
preferences.rulerUnits = Units.PIXELS



var theWidth=originalDocRef.width.value
var theHeight=originalDocRef.height.value

var halfWidth = theWidth/2
var halfHeight = theHeight/2

var widthTenth = theWidth/10
var heightTenth = theHeight/10

var horizontalStrip = [ [halfWidth-widthTenth,0],[halfWidth + widthTenth,0],[halfWidth + widthTenth,theHeight],[halfWidth - widthTenth,theHeight] ]

var verticalStrip = [ [0,halfHeight - heightTenth],[theWidth, halfHeight- heightTenth],[theWidth,halfHeight + heightTenth],[0,halfHeight  + heightTenth] ]

//Duplicate Background Layer
originalDocRef.activeLayer.duplicate()
//Reference the newLayer
var layerRef = originalDocRef.artLayers[0]

//Create the Offset Values
myWidthUnit = new UnitValue (halfWidth, "px");
myHeightUnit = new UnitValue (halfHeight, "px");
//Offset the layer
layerRef.applyOffset(myWidthUnit,myHeightUnit,OffsetUndefinedAreas.WRAPAROUND)




originalDocRef.activeLayer=originalDocRef.artLayers[0]
/*Select it*/
app.activeDocument.selection.select(horizontalStrip)


app.activeDocument.selection.select(verticalStrip,SelectionType.EXTEND)




app.activeDocument.selection.feather(10)

/*
//Debug Logic
var artLayerRef = originalDocRef.artLayers.add()
artLayerRef.kind=LayerKind.TEXT

var textItemRef= artLayerRef.textItem
textItemRef.contents = originalDocRef.height.toString()

var artLayerRef2 = originalDocRef.artLayers.add()
artLayerRef2.kind=LayerKind.TEXT

var textItemRef= artLayerRef2.textItem
textItemRef.contents = originalDocRef.width.toString()

*/







//Reset Preferences
app.preferences.rulerUnits=originalUnit


//Garbage Collection

theWidth=null
theHeight=null

halfWidth = null
halfHeight = null

widthTenth = null
heightTenth = null

horizontalStrip = null

verticalStrip =null




originalDocRef=null
originalUnit=null
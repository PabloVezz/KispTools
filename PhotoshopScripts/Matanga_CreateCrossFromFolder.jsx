// Import Folder as Layers - Adobe Photoshop Script
// Description: imports a folder of images as named layers within a new document
// Requirements: Adobe Photoshop CS2, or higher
// Version: 2.0.0, 5/July/2009
// Author: Trevor Morris (trevor@morris-photographics.com)
// Website: http://morris-photographics.com/
// ============================================================================
// Installation:
// 1. Place script in 'C:\Program Files\Adobe\Adobe Photoshop CS#\Presets\Scripts\'
// 2. Restart Photoshop
// 3. Choose File > Scripts > Import Folder as Layers
// ============================================================================

// enable double-clicking from Mac Finder or Windows Explorer
// this command only works in Photoshop CS2 and higher
#target photoshop

// bring application forward for double-click events
app.bringToFront();

///////////////////////////////////////////////////////////////////////////////
// main - main function
///////////////////////////////////////////////////////////////////////////////
function main() {
	// user settings
	var prefs = new Object();
	prefs.sourceFolder         = '~';  // default browse location (default: '~')
	prefs.removeFileExtensions = true; // remove filename extensions for imported layers (default: true)
	prefs.savePrompt           = false; // display save prompt after import is complete (default: false)
	prefs.closeAfterSave       = false; // close import document after saving (default: false)

	// prompt for source folder
	var sourceFolder = Folder.selectDialog('Please select the folder to be imported:', Folder(prefs.sourceFolder));

	// ensure the source folder is valid
	if (!sourceFolder) {
		return;
	}
	else if (!sourceFolder.exists) {
		alert('Source folder not found.', 'Script Stopped', true);
		return;
	}

	// add source folder to user settings
	prefs.sourceFolder = sourceFolder;

	// get a list of files
	var fileArray = getFiles(prefs.sourceFolder);

	// if files were found, proceed with import
	if (fileArray.length) {
		importFolderAsLayers(fileArray, prefs);
		DoHorizontalCrossProcess();
	}
	// otherwise, diplay message
	else {
		alert("The selected folder doesn't contain any recognized images.", 'No Files Found', false);
	}
}


function DoHorizontalCrossProcess()
{
	myWidthUnit = new UnitValue (6144, "px");
	myHeightUnit = new UnitValue (4608, "px");
	app.activeDocument.resizeCanvas(myWidthUnit,myHeightUnit,AnchorPosition.TOPLEFT)

	//Do Back Layer
	SelectLayer("_BK");
	MoveLayerTo(1536,1536);

	//Do Front Layer
	SelectLayer("_FR");
	MoveLayerTo(4608,1536);

	//Do Left Layer
	SelectLayer("_LF");
	MoveLayerTo(0,1536);

	//Do Right Layer
	SelectLayer("_RT");
	MoveLayerTo(3072,1536);

	//Do Up Layer
	SelectLayer("_UP");
	MoveLayerTo(1536,0);

	//Do Down Layer
	SelectLayer("_DN");
	MoveLayerTo(1536,3072);

}


//******************************************
// MOVE LAYER TO
// Author: Max Kielland
//
// Moves layer fLayer to the absolute
// position fX,fY. The unit of fX and fY are
// the same as the ruler setting. 

function MoveLayerTo(fX,fY) {

  var Position = activeDocument.activeLayer.bounds;
  Position[0] = fX - Position[0];
  Position[1] = fY - Position[1];

  activeDocument.activeLayer.translate(-Position[0],-Position[1]);
}




function SelectLayer(searchTerm) {
	// declare local variables
	var layers = app.activeDocument.layers;
	var len = layers.length;

	// iterate through layers to find a match
	for (var i = 0; i < len; i++) {
		// test for matching layer
		var layer = layers[i];
		var thisName=layer.name;

		if (thisName.indexOf(searchTerm) > -1)
		{
			activeDocument.activeLayer = layer;
			break;
		}

	}
}
function findLayerOriginal(ref, name) {
	// declare local variables
	var layers = ref.layers;
	var len = layers.length;
	var match = false;

	// iterate through layers to find a match
	for (var i = 0; i < len; i++) {
		// test for matching layer
		var layer = layers[i];
		if (layer.name.toLowerCase() == name.toLowerCase()) {
			// select matching layer
			activeDocument.activeLayer = layer;
			match = true;
			break;
		}
		// handle groups (layer sets)
		else if (layer.typename == 'LayerSet') {
			match = findLayer(layer, name);
			if (match) {
				break;
			}
		}
	}
	return match;
}





///////////////////////////////////////////////////////////////////////////////
// getFiles - get all files within the specified source
///////////////////////////////////////////////////////////////////////////////
function getFiles(sourceFolder) {
	// declare local variables
	var fileArray = new Array();
	var extRE = /\.(?:png|gif|jpg|bmp|tif|psd)$/i;

	// get all files in source folder
	var docs = sourceFolder.getFiles();
	var len = docs.length;
	for (var i = 0; i < len; i++) {
		var doc = docs[i];

		// only match files (not folders)
		if (doc instanceof File) {
			// store all recognized files into an array
			var docName = doc.name;
			if (docName.match(extRE)) {
				fileArray.push(doc);
			}
		}
	}

	// return file array
	return fileArray;
}

///////////////////////////////////////////////////////////////////////////////
// importFolderAsLayers - imports a folder of images as named layers
///////////////////////////////////////////////////////////////////////////////
function importFolderAsLayers(fileArray, prefs) {
	// create a new document
	var newDoc = documents.add(300, 300, 72, 'Imported Layers', NewDocumentMode.RGB, DocumentFill.TRANSPARENT, 1);
	var newLayer = newDoc.activeLayer;

	// loop through all files in the source folder
	for (var i = 0; i < fileArray.length; i++) {
		// open document
		var doc = open(fileArray[i]);

		// get document name (and remove file extension)
		var name = doc.name;
		if (prefs.removeFileExtensions) {
			name = name.replace(/(?:\.[^.]*$|$)/, '');
		}

		// convert to RGB; convert to 8-bpc; merge visible
		doc.changeMode(ChangeMode.RGB);
		doc.bitsPerChannel = BitsPerChannelType.EIGHT;
		doc.artLayers.add();
		doc.mergeVisibleLayers();

		// rename layer; duplicate to new document
		var layer = doc.activeLayer;
		layer.name = name;
		layer.duplicate(newDoc, ElementPlacement.PLACEATBEGINNING);

		// close imported document
		doc.close(SaveOptions.DONOTSAVECHANGES);
	}	

	// delete empty layer; reveal and trim to fit all layers
	newLayer.remove();
	newDoc.revealAll();
	newDoc.trim(TrimType.TRANSPARENT, true, true, true, true);

	// save the final document
	if (prefs.savePrompt) {
		// PSD save options
		var saveOptions = new PhotoshopSaveOptions();
		saveOptions.layers = true;
		saveOptions.embedColorProfile = true;

		// prompt for save name and location
		var saveFile = File.saveDialog('Save the new document as:');
		if (saveFile) {
			newDoc.saveAs(saveFile, saveOptions, false, Extension.LOWERCASE);
		}

		// close import document
		if (prefs.closeAfterSave) {
			newDoc.close(SaveOptions.DONOTSAVECHANGES);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// isCorrectVersion - check for Adobe Photoshop CS2 (v9) or higher
///////////////////////////////////////////////////////////////////////////////
function isCorrectVersion() {
	if (parseInt(version, 10) >= 9) {
		return true;
	}
	else {
		alert('This script requires Adobe Photoshop CS2 or higher.', 'Wrong Version', false);
		return false;
	}
}

///////////////////////////////////////////////////////////////////////////////
// showError - display error message if something goes wrong
///////////////////////////////////////////////////////////////////////////////
function showError(err) {
	if (confirm('An unknown error has occurred.\n' +
		'Would you like to see more information?', true, 'Unknown Error')) {
			alert(err + ': on line ' + err.line, 'Script Error', true);
	}
}


// test initial conditions prior to running main function
if (isCorrectVersion()) {
	// remember ruler units; switch to pixels
	var originalRulerUnits = preferences.rulerUnits;
	preferences.rulerUnits = Units.PIXELS;

	try {
		main();
	}
	catch(e) {
		// don't report error on user cancel
		if (e.number != 8007) {
			showError(e);
		}
	}

	// restore original ruler unit
	preferences.rulerUnits = originalRulerUnits;
}

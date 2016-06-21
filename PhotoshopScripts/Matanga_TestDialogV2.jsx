var isDone, s2t, waitForRedraw, win, windowResource;

// Shortcut function
s2t = function(stringID) {
  return app.stringIDToTypeID(stringID);
};

waitForRedraw = function() {
  var d;
  d = new ActionDescriptor();
  d.putEnumerated(s2t('state'), s2t('state'), s2t('redrawComplete'));
  return executeAction(s2t('wait'), d, DialogModes.NO);
};

//sentinel variable
isDone = false;




windowResource = "palette {  \
    orientation: 'column', \
    alignChildren: ['fill', 'top'],  \
    preferredSize:[300, 130], \
    text: 'ScriptUI Window - palette',  \
    margins:15, \
                \
           sliderPanel: Panel { \
                orientation: 'row', \
                alignChildren: 'right', \
                margins:5, \
                text: ' SELECT FACE ', \
                Face1: Button { text: '1', properties:{name:'face1'}, size: [24,24], alignment:['left', 'center'] }, \
                Face2: Button { text: '2', properties:{name:'face2'}, size: [24,24], alignment:['left', 'center'] }, \
                Face3: Button { text: '3', properties:{name:'face3'}, size: [24,24], alignment:['left', 'center'] }, \
                Face4: Button { text: '4', properties:{name:'face4'}, size: [24,24], alignment:['left', 'center'] }, \
                Face5: Button { text: '5', properties:{name:'face5'}, size: [24,24], alignment:['left', 'center'] }, \
                Face6: Button { text: '6', properties:{name:'face6'}, size: [24,24], alignment:['left', 'center'] }, \
                Face7: Button { text: '7', properties:{name:'face7'}, size: [24,24], alignment:['left', 'center'] }, \
                Face8: Button { text: '8', properties:{name:'face8'}, size: [24,24], alignment:['left', 'center'] }, \
                Face9: Button { text: '9', properties:{name:'face9'}, size: [24,24], alignment:['left', 'center'] }, \
                Face10: Button { text: '10', properties:{name:'face10'}, size: [24,24], alignment:['left', 'center'] }, \
                Face11: Button { text: '11', properties:{name:'face11'}, size: [24,24], alignment:['left', 'center'] }, \
                Face12: Button { text: '12', properties:{name:'face12'}, size: [24,24], alignment:['left', 'center'] } \
           } \
            \
            bottomGroup: Group{ \
            cd: Checkbox { text:'Checkbox value', value: true }, \
            cancelButton: Button { text: 'Cancel', properties:{name:'cancel'}, size: [120,24], alignment:['right', 'center'] }, \
            applyButton: Button { text: 'Apply', properties:{name:'apply'}, size: [120,24], alignment:['right', 'center'] }, \
    }\ }";





win = new Window(windowResource);


// Button listeners
win.sliderPanel.Face1.onClick = function() { app.activeDocument.selection.select( [ [0,0],[0,1536],[1536,1536],[1536,0] ] ) };
win.sliderPanel.Face2.onClick = function() { app.activeDocument.selection.select ([ [1536,0],[3072,0],[3072,1536],[1536,1536] ]) };
win.sliderPanel.Face3.onClick = function() { app.activeDocument.selection.select([ [3072,0],[4608,0],[4608,1536],[3072,1536] ]) };
win.sliderPanel.Face4.onClick = function() { app.activeDocument.selection.select([ [4608,0],[6144,0],[6144,1536],[4608,1536] ]) };
win.sliderPanel.Face5.onClick = function() { app.activeDocument.selection.select([ [6144,0],[7680,0],[7680,1536],[6144,1536] ]) };
win.sliderPanel.Face6.onClick = function() { app.activeDocument.selection.select([ [7680,0],[9216,0],[9216,1536],[7680,1536] ]) };
win.sliderPanel.Face7.onClick = function() { app.activeDocument.selection.select([ [9216,0],[10752,0],[10752,1536],[9216,1536] ]) };
win.sliderPanel.Face8.onClick = function() { app.activeDocument.selection.select([ [10752,0],[12288,0],[12288,1536],[10752,1536] ]) };
win.sliderPanel.Face9.onClick = function() { app.activeDocument.selection.select([ [12288,0],[13824,0],[13824,1536],[12288,1536] ]) };
win.sliderPanel.Face10.onClick = function() { app.activeDocument.selection.select([ [13824,0],[15360,0],[15360,1536],[13824,1536] ]) };
win.sliderPanel.Face11.onClick = function() { app.activeDocument.selection.select([ [15360,0],[16896,0],[16896,1536],[15360,1536] ]) };
win.sliderPanel.Face12.onClick = function() { app.activeDocument.selection.select([ [16896,0],[18432,0],[18432,1536],[16896,1536] ]) };




// Button listeners
win.bottomGroup.cancelButton.onClick = function() {
  return isDone = true;
};
win.bottomGroup.applyButton.onClick = function() {
  return isDone = true;
};




// don't forget this one!
win.onClose = function() {
  return isDone = true;
};

win.show();

while (isDone === false) {
  app.refresh(); // or, alternatively, waitForRedraw();
}

	--------------------------------------------
	--------------------------------------------
	-- DOTNET UTILITIES
	-- DOTNET UTILITIES
	--------------------------------------------
	--------------------------------------------
	/************************************
		METHOD :formatProps
		USE: Prints all the properties of any passed dotnetObject for debuuging purposes
		ARGUMENTS : the dotnetObject to be debugged
	*/
	fn formatProps sender option:#All =
	(
		clearListener()
		if classof sender == dotnetObject or classof sender ==dotnetClass then
		(
				if option == #All or option  ==#constructor do
				(
					format "\nConstructors***************************************************:\n"
					dotNet.ShowConstructors sender
				)
				if option == #All or option  ==#properties do
				(
					format "\nProperties***************************************************:\n"
					ShowProperties sender
				)
				if option == #All or option  ==#methods do
				(
					format "\nMethods***************************************************:\n"
					ShowMethods sender
				)
				if option == #All or option  ==#events do
				(
					format "\nevents***************************************************:\n"
					ShowEvents sender
				)
				
				
		)else( format "not a dotNetObject or dotNetClass!:%\n" sender)			
	),
	fn dnColor c:[0,0,0] a:255 =((dotNetClass "system.drawing.color").FromArgb a c.x c.y c.z),	
	fn dnRec  p:[0,0] s:[10,10] =(dotNetObject "system.drawing.rectangle" p.x p.y s.x s.y ),
	fn dnSize s:[10,10] = (dotnetObject "system.drawing.size" s.x s.y),	
	fn dnPadding l:10 t:10 r:10 b:10 = (dotnetObject "system.windows.forms.Padding" l t r b),
	
	
	/************************************
		METHOD : dnHeaderButton
		USE: returns a dotnetObject "button" initialized with the given name
		ARGUMENTS :
	*/
	
	/*
	fn dnHeaderButton  theName =
	(
		--Create a new Button 
		dnButton = dotNetObject "button"
		--Set the Text
		dnButton.text=theName
		--Set the size
		dnButton.Size = dnSize s:[80, 30]		
		--Set the Margin
		dnButton.Margin= dnButton.Margin.empty
		
		
		--Set the backcolor
		dnButton.backcolor = dnColor c:[200,200,200] a:255
		--Set Hover Colors
		dnButton.flatStyle=dnButton.flatStyle.popup
		

		dnButton
	),
	*/
	/************************************
		METHOD :
		USE:
		ARGUMENTS :
	*/
	
	/*
	fn dnContentButton  theName theDescription  =
	(		
		dnFlowHorizontal= dotNetObject "flowLayoutPanel"
		dnFlowHorizontal.Flowdirection = dnFlowHorizontal.Flowdirection.LeftToRight
		dnFlowHorizontal.bounds =KispTools.dnRec s:[kispTools.theContentPanel.width, 30]
		dnFlowHorizontal.BorderStyle=dnFlowHorizontal.BorderStyle.none
		
		
		--Create a new Button 
		dnButton = dotNetObject "button"
		--Set the Text
		dnButton.text=theName
		--Set the size
		dnButton.Size = dnSize s:[80, 30]		
		--Set the Margin		
		dnButton.Margin= dnButton.Margin.empty
		dnButton.Padding= dnButton.Padding.empty
		--dnButton.Margin.all= 10
		--dnButton.Padding.all= 10	
		
		--Set the backcolor
		dnButton.backcolor = dnColor c:[110,110,110] a:255
		--Set Hover Colors
		dnButton.flatStyle=dnButton.flatStyle.popup
		
		dnFlowHorizontal.controls.add dnButton		
		
		--Create a new Button 
		dnLabel = dotNetObject "button"
		--Set the Text
		dnLabel.text=theDescription
		--Set the size
		dnLabel.Size = dnSize s:[kispTools.theContentPanel.width-85, 30]		
		--Set the Margin
		dnLabel.Margin= dnButton.Margin.empty
		dnLabel.Padding= dnLabel.Padding.empty
		--dnLabel.Margin.all= 10
		--dnLabel.Padding.all= 10

		--Set the backcolor
		dnLabel.backcolor = dnColor c:[90,90,90] a:255
		--Set Hover Colors
		dnLabel.flatStyle=dnButton.flatStyle.flat
		dnFlowHorizontal.controls.add dnLabel		
		
		dnFlowHorizontal
	),
	*/

	
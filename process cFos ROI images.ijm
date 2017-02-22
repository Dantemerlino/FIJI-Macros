setBatchMode(true);
RO=isOpen("Results");
if(RO==1){
selectWindow("Results");
run("Close");
}
Home=getDirectory("home");
dir=getDirectory("Choose the area with the ROI images");
previousFolder=File.getParent(dir);
previousFolder=previousFolder+"/";
//print(previousFolder);
list = getFileList(dir);
listB=Array.sort(list);
colors=newArray("Magenta", "Blue", "Green", "Red", "Cyan", "Yellow");
setBatchMode(true);

colorfix();


L=listB.length;
for(i=0; i<L; i++){
path=dir+listB[i];
open(path);
Title=getTitle();
RO=isOpen("Results");

ScaledPNGwithInsetAndStats();
}

Dialog.create("Done!");
Dialog.show();


function colorfix(){
Dialog.create("Choose brightness and contrast for folder to be processed");
		Dialog.addNumber("CY5 Minimum:", 90);
		Dialog.addNumber("CY5 Maximum:", 500);
		Dialog.addChoice("What color would you like your Cy5 Channel?", colors, colors[4]);
		Dialog.addNumber("DAPI Minimum:", 0);
		Dialog.addNumber("DAPI Maximum:", 2500);
		Dialog.addChoice("What color would you like your DAPI Channel?", colors, colors[1]);
		Dialog.addNumber("GFP Minimum:", 50);
		Dialog.addNumber("GFP Maximum:", 1000);
		Dialog.addChoice("What color would you like your GFP Channel?", colors, colors[2]);
		Dialog.addNumber("TxRed Minimum:", 0);
		Dialog.addNumber("TxRed Maximum:", 2000);
		Dialog.addChoice("What color would you like your TxRed Channel?", colors, colors[3]);
		Dialog.show();
CY5Min=Dialog.getNumber();
CY5Max=Dialog.getNumber();
CY5COLOR=Dialog.getChoice();
DAPIMin=Dialog.getNumber();
DAPIMax=Dialog.getNumber();
DAPICOLOR=Dialog.getChoice();
GFPMin=Dialog.getNumber();
GFPMax=Dialog.getNumber();
GFPCOLOR=Dialog.getChoice();
RedMin=Dialog.getNumber();
RedMax=Dialog.getNumber();
TXREDCOLOR=Dialog.getChoice();
listB=Array.sort(list);
setBatchMode(true);
L=listB.length;
for(i=0; i<L; i++){
path=dir+listB[i];
open(path);
Title=getTitle();
fixthecolor();
run("Save");
close();
}


function fixthecolor(){
Stack.setDisplayMode("color");
Stack.setChannel(1);
run(CY5COLOR);
setMinAndMax(CY5Min, CY5Max);
Stack.setChannel(2);
run(DAPICOLOR);
setMinAndMax(DAPIMin, DAPIMax);
Stack.setChannel(3);
run(GFPCOLOR);
setMinAndMax(GFPMin, GFPMax);
Stack.setChannel(4);
run(TXREDCOLOR);
setMinAndMax(RedMin, RedMax);
Stack.setDisplayMode("composite");
}
}



function ScaledPNGwithInsetAndStats(){
if(RO==1){
selectWindow("Results");
run("Close");
}
Title=getTitle();
run("Set Measurements...", "area mean center bounding integrated stack display redirect=None decimal=3");

close("ROI*");
	run("To ROI Manager");

ROICOUNT=roiManager("count");
LeftROI=0;
RightROI=0;
NumOfNuclei=0;
for(i=0;i<ROICOUNT; i++){
	roiManager("select", i);
	run("Measure");
	
}
LeftArea=getResult("Area", 0);
LeftArea=LeftArea/10000;
RightArea=getResult("Area", 1);
RightArea=RightArea/10000;
RightBX=getResult("BX", 1);

for(i=0;i<ROICOUNT; i++){
ThisBX=getResult("BX", i);
	if(ThisBX>RightBX){
		RightROI=RightROI+1;
	}
	else{
		LeftROI=LeftROI+1;
	}
}

for(i=0;i<ROICOUNT; i++){
ThisArea=getResult("Area", i);
	if(ThisArea>15000){
		NumOfNuclei=NumOfNuclei+1;
	}
}

LeftROI=LeftROI-NumOfNuclei;

LeftCellsPerArea=LeftROI/LeftArea;
RightCellsPerArea=RightROI/RightArea;
RightArea=toString(RightArea, 1);
LeftArea=toString(LeftArea, 1);
LeftCellsPerArea=toString(LeftCellsPerArea, 2);
RightCellsPerArea=toString(RightCellsPerArea, 2);



close(Title);
open(path);
run("Labels...", "color=white font=8 draw");


		Stack.setActiveChannels("1011");

		roiManager("deselect");
		run("Select None");



run("Flatten");
getDimensions(width, height, channels, slices, frames);
w=width/2;
h=height/2;
//wait(1000);
run("Scale...", "x=0.5 y=0.5 z=1.0 width="+w+" height="+h+" depth=1 interpolation=Bilinear average");
//print("width: "+width);
//print("height: "+height);

NewXOrigin=width/4;
//print("NewXOrigin:"+NewXOrigin);
NewYOrigin=height/4;
//print("NewYOrigin:"+NewYOrigin);
NewWidth=NewXOrigin*2;
//print("NewWidth:"+NewWidth);
NewHeight=NewYOrigin*3;
//print("NewHeight:"+NewHeight);

Ylocation= NewYOrigin*2.2;
//print("Ylocation:"+Ylocation);



makeRectangle(NewXOrigin, NewYOrigin, NewWidth, NewHeight);
run("Crop");


FontSize=NewHeight/30;
smallFont=NewHeight/35;

setFont("Helvetica", FontSize, "bold antialiased");
setColor("white");
Overlay.drawString("Left Side:", 104, Ylocation);
Overlay.show();

Overlay.drawString("Right Side:", NewXOrigin, Ylocation);
Overlay.show();
//getSelectionBounds(x, y, width, height);
FONTHEIGHT=getValue("font.height");
FONTHEIGHT1=FONTHEIGHT*1.1;
FONTHEIGHT2=FONTHEIGHT*2.2;
FONTHEIGHT3=FONTHEIGHT*3.3;
//print("OverlaySize:"+OverlaySize);
BelowYLocation1 = Ylocation+FONTHEIGHT1;
BelowYLocation2 = Ylocation+FONTHEIGHT2;
BelowYLocation3=Ylocation+FONTHEIGHT3;
setFont("Helvetica", smallFont, "antialiased");
Overlay.drawString("Area: "+LeftArea, 104, BelowYLocation1);
Overlay.show();
Overlay.drawString("Count: "+LeftROI, 104, BelowYLocation2);
Overlay.show();

Overlay.drawString("Cells per Area: "+LeftCellsPerArea, 104, BelowYLocation3);
Overlay.show();


Overlay.drawString("Area: "+RightArea, NewXOrigin, BelowYLocation1);
Overlay.show();
Overlay.drawString("Count: "+RightROI, NewXOrigin, BelowYLocation2);
Overlay.show();
Overlay.drawString("Cells per Area: "+RightCellsPerArea, NewXOrigin, BelowYLocation3);
Overlay.show();


//setBatchMode("Exit and Display");
run("Flatten");

dir2="/Users/dantemerlino/Dropbox (Waldman Lab)/";
Overlay.drawString(Title, 100, 100);
Overlay.show();
run("Flatten");
//Dialog.create("Save your file");
//Dialog.addString("Save As:",path+" scaled image with stats.png",180 );
//Dialog.show();
//NEWTITLE=Dialog.getString();
saveAs("PNG", dir2+Title+", Scaled with Stats.png");
close();
close();

}



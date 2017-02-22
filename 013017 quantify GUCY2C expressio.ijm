
var HOME=getDirectory("home");
run("Set Measurements...", "area mean center integrated stack display add redirect=None decimal=3");

var ChannelOI=3;

Dialog.create("Choose your nucleus ");
		Dialog.addString("What nucleus will you be quantifying?", 80 );
		Dialog.show();
		 SELECTION = Dialog.getString();

setBatchMode(true);
dir=getDirectory("Choose your directory");
//dir=File.directory();
list=getFileList(dir);
for (i=0; i<list.length; i++){
	RO=isOpen("Results");
if(RO==1){
selectWindow("Results");
run("Close");
}
//for (i=0; i<1; i++){	
path=dir+list[i];
open(path);
Title=getTitle();


setTool("polygon");
selectWindow(Title);
	close("ROI Manager");
	
Stack.setDisplayMode("color");
Stack.setChannel(1);
setMinAndMax(100, 500);
Stack.setChannel(2);
setMinAndMax(100, 2000);
Stack.setChannel(3);
setMinAndMax(100, 1000);
Stack.setChannel(4);
setMinAndMax(0, 500);
Stack.setDisplayMode("Composite");

	setBatchMode("exit and display");
	waitForUser("Create a region of interest around the nuclei to be measured. Then,  select a region with no staining to use as a background control. Then, press OK.");
	setBatchMode(true);
	
	
	run("To ROI Manager");
	ROICOUNT=roiManager("count");
	close(Title);
//print(ROICOUNT);
RO=isOpen("Results");
if(RO==1){
selectWindow("Results");
run("Close");
}
open(path);
for (m=0; m<ROICOUNT; m++){
	roiManager("Select", m);
	Stack.setDisplayMode("color");
Stack.setChannel(ChannelOI);
run("Measure");
}
RESULTS=newArray();
for (m=0; m<ROICOUNT; m++){
Area=getResult("Area", m);
//print(Area);
IntDen=getResult("IntDen", m);
//print(IntDen);
Mean=getResult("Mean", m);

//print(Mean);
RESULTS1=newArray(m, Area, IntDen, Mean);
RESULTS=Array.concat(RESULTS,RESULTS1);
}

roiManager("Show All with labels");
Stack.setDisplayMode("Composite");
//Stack.setActiveChannels("1011");
saveAs("Tif", path);
close(Title);
//saveAs("Tiff", HOME+"Dropbox (Waldman Lab)/"+Title+"-Drawn ROIs.tif");
open(path);
run("Overlay Options...", "stroke=white width=7 fill=none apply show");
run("Labels...", "color=yellow font=72 show draw bold");
run("Flatten");
ScaledPNGwithInsetAndStats();
selectWindow("Results");
run("Close");
roiManager("deselect");
roiManager("Delete");
}





function ScaledPNGwithInsetAndStats(){
getDimensions(width, height, channels, slices, frames);
SF=width/2000;
print("SF: "+SF);
w=width/SF;
print("w: "+w);
h=height/SF;
print("h: "+h);
SFdenom=1/SF;
print("SFdenom: "+SFdenom);

run("Scale...", "x="+SFdenom+" y="+SFdenom+" z=1.0 width="+w+" height="+h+" depth=1 interpolation=Bilinear average  title=[Scaled Title]");

NewXOrigin=(width-w)/2;
print("NewXOrigin:"+NewXOrigin);
NewYOrigin=(height-h)/2;
print("NewYOrigin:"+NewYOrigin);
NewWidth=2000;
print("NewWidth:"+NewWidth);
NewHeight=NewYOrigin+h;
NewHeight=NewHeight+NewYOrigin;
print("NewHeight:"+NewHeight);
Ylocation=h*1.05;
print("Ylocation:"+Ylocation);
makeRectangle(NewXOrigin, NewYOrigin, NewWidth, NewHeight);
run("Crop");
FontSize=NewWidth/50;
smallFont=NewWidth/60;

setFont("Helvetica", FontSize, "bold antialiased");
setColor("white");
Overlay.drawString("Title: "+Title, 104, Ylocation);
Overlay.show();
FONTHEIGHT=getValue("font.height");
setFont("Helvetica", smallFont, "antialiased");
Background=RESULTS.length-1;
Array.print(RESULTS);
BackgroundMFI=RESULTS[Background];
for (o=0; o<ROICOUNT; o++){
	IntDenValue=2;
	AreaValue=1;
	MeanValue=3;
	Multiple=o*4;
	IntDenNum=IntDenValue+Multiple;
	MeanNum=MeanValue+Multiple;
	AreaNum=AreaValue+Multiple;
	ROIIntDensity=RESULTS[IntDenNum];
	ROIArea=RESULTS[AreaNum];
	BxA=ROIArea*BackgroundMFI;
	CTCF=ROIIntDensity - BxA;
	n=o+1;
	N=ROICOUNT+o;
	CTCFA=CTCF/ROIArea;
	setResult("CTCFperArea", N, CTCFA);
	setResult("CTCF", N, CTCF);	
Label2=getResultLabel(o);
Area2=getResult("Area", o);
Mean2=getResult("Mean", o);
IntDen2=getResult("IntDen", o);
CH2=getResult("Ch", o);
	setResult("Label", N, Label2);
	setResult("Area", N, Area2);
		setResult("Mean", N, Mean2);
			setResult("IntDen", N, IntDen2);
			setResult("Ch", N, CH2);
	updateResults();

//	print("Area "+n+" CTCF: "+CTCF);
//	print("FONTHEIGHT: "+FONTHEIGHT);
	Ylocation=Ylocation+FONTHEIGHT;
//		print("Ylocation: "+Ylocation);
Overlay.drawString("CTFCA, Area "+n+": "+CTCFA, 104, Ylocation);
Overlay.show();
}
ROICOUNT=ROICOUNT-1;
IJ.deleteRows(0, ROICOUNT);
saveAs("results", dir+SELECTION+" "+Title+", Results.xls");
run("Flatten");
saveAs("PNG", dir+SELECTION+" "+Title+", GUCY2C quantification image with Stats.png");
close();
close();

}



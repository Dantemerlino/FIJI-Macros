QuantifyIFExpression ();



function QuantifyIFExpression (){
var HOME=getDirectory("home");
run("Overlay Options...", "stroke=yellow width=5 fill=none set");

Channels=newArray("1","2","3","4");

AutoT=newArray("Default", "Huang", "Intermodes", "IsoData", "Li", "MaxEntropy", "Mean", "MinError(I)", "Minimum", "Moments", "Otsu", "Percentile", "RenyiEntropy", "Shanbhag", "Triangle", "Yen");




Dialog.create("Waldman Lab Automated Cell Counting Macro");
Dialog.addChoice("What channel do you need to quantify?", Channels);
Dialog.addChoice("What thresholding method do you want to use?", AutoT, AutoT[9]);
	Dialog.show();
ChannelOI=Dialog.getChoice();
ThresholdMethod=Dialog.getChoice();




setBatchMode(true);
dir=getDirectory("Choose your directory");
//dir=File.directory();
list=getFileList(dir);
for (i=0; i<list.length; i++){
//for (i=0; i<1; i++){
	RO=isOpen("Results");
if(RO==1){
selectWindow("Results");
run("Close");
}
//for (i=0; i<1; i++){	
path=dir+list[i];
open(path);
Title=getTitle();
Stack.setDisplayMode("Color");
Stack.setChannel(1);
run("Blue");
Stack.setChannel(2);
run("Red");
Stack.setChannel(ChannelOI);
run("Duplicate...", "title=[Binary] duplicate channels="+ChannelOI);
close(Title);
selectWindow("Binary");
run("Auto Threshold", "method="+ThresholdMethod+" ignore_black ignore_white white");
run("Smooth");
run("Smooth");
run("Despeckle");
//setOption("BlackBackground", true);

run("Make Binary");
close("ROI*");
setTool("wand");
setBatchMode("exit and display");
waitForUser("Click on a region to outline it, then press cmd+B. Do this for all regions of interest. Then, press OK.");
setTool("rectangle");
waitForUser("Now, make a box around a region with no real staining, to establish a background reading. Again, press Cmd+B, then press OK.");
	run("To ROI Manager");
	ROICOUNT=roiManager("count");
//print(ROICOUNT);
RO=isOpen("Results");
if(RO==1){
selectWindow("Results");
run("Close");
}
close("Binary");
open(path);
for (m=0; m<ROICOUNT; m++){
		setBatchMode(true);
run("Set Measurements...", "area mean integrated stack display redirect=None decimal=3");
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


run("Labels...", "color=white font=8 show use draw");
roiManager("Show All with labels");
roiManager("Draw");
saveAs("results", HOME+"Dropbox (Waldman Lab)/"+Title+" Results.xls");
ScaledPNGwithInsetAndStats();
saveAs("Tiff", HOME+"Dropbox (Waldman Lab)/"+Title+"-Drawn ROIs.tif");
selectWindow("Results");
run("Close");
}





function ScaledPNGwithInsetAndStats(){
Stack.setDisplayMode("Composite");
run("Flatten");
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
FontSize=NewWidth/80;
smallFont=NewWidth/100;

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
	print("Area "+n+" CTCF: "+CTCF);
	FONTHEIGHT=FONTHEIGHT*j;
	print("FONTHEIGHT: "+FONTHEIGHT);
	Ylocation=Ylocation+FONTHEIGHT;
		print("Ylocation: "+Ylocation);
Overlay.drawString("CTFC, Area "+n+": "+CTCF, 104, Ylocation);
Overlay.show();
}
run("Flatten");
PNGImages=dir+"PNG images/";
PNGImagesQ=File.exists(PNGImages);
if (PNGImagesQ==0){
	File.makeDirectory(PNGImages);
}
saveAs("PNG", PNGImages+Title+", guanylin quantification image with Stats.png");
close();
close();

}
}
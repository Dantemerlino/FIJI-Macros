
var HOME=getDirectory("home");
var CellSize=60;
var ChannelOI=1;
var Threshold=150;

setBatchMode(true);
dir=getDirectory("Choose your directory");
//dir=File.directory();
list=getFileList(dir);
for (i=0; i<list.length; i++){
//for (i=0; i<1; i++){	
path=dir+list[i];
open(path);
Title=getTitle();


//run("Subtract Background...", "rolling=50");
Stack.setChannel(ChannelOI);
run("Despeckle", "slice");
run("Despeckle", "slice");
run("Despeckle", "slice");
run("Gaussian Blur...", "sigma=2 slice");


run("Duplicate...", "title=["+Title+" Binary] duplicate duplicate channels="+ChannelOI);

selectWindow(Title+" Binary");
//run("Robust Automatic Threshold Selection", "noise=25 lambda=3 min=271 verbose");

run("Auto Threshold", "method=Moments ignore_black ignore_white white");
run("Watershed");




/*
Stack.setDisplayMode("composite");
run("8-bit");
Stack.setDisplayMode("color");
Stack.setChannel(1);
run("Make Binary", "method=Moments background=Dark only black list");
Stack.setChannel(2);
run("Make Binary", "method=Otsu background=Dark only black list");
Stack.setChannel(3);
run("Make Binary", "method=RenyiEntropy background=Dark only black list");
Stack.setChannel(4);
run("Make Binary", "method=Yen background=Dark only black list");
run("Watershed", "stack");
*/





close(Title);
open(path);
setTool("polygon");
selectWindow(Title);
	close("ROI*");
	
		Stack.setDisplayMode("color");
		Stack.setChannel(4);
		setMinAndMax(50, 200);
		Stack.setDisplayMode("Composite");
		Stack.setActiveChannels("0111");
	setBatchMode("exit and display");
	waitForUser("Create a region of interest around the nuclei to be measured. Then, Press OK.");
	run("To ROI Manager");

ROICOUNT=roiManager("count");
//print(ROICOUNT);

for (m=0; m<ROICOUNT; m++){
		setBatchMode(true);
	run("Set Measurements...", "area mean integrated stack display redirect=["+Title+"] decimal=3");
roiManager("Select", m);
run("Measure");
}
for (k=0; k<ROICOUNT; k++){
	close(Title);
	open(path);
run("Set Measurements...", "area mean integrated stack display redirect=["+Title+"] decimal=3");
selectWindow(Title);		
Stack.setChannel(ChannelOI);
selectWindow(Title+ " Binary");	
roiManager("Select", k);
//Stack.setChannel(ChannelOI);
run("Analyze Particles...", "size="+CellSize+"-Infinity circularity=0.4-1.00 show=Overlay display summarize add");
}
	close(Title);
	open(path);
Stack.setChannel(ChannelOI);	


Threshold=150;
j=0;

//getInfo("window.contents");
NumberofValues=nResults();
print("NumberofValues: "+NumberofValues);

for (r=0; r<NumberofValues; r++){
Label=getResultLabel(r);
//Label=getResult("Label", i);

print("Label: "+Label);
Mean=getResult("Mean", r);
Area=getResult("Area", r);
print("Mean: "+Mean); 
if (Area>50000) {
	N=NumberofValues+j;
	setResult("Mean", N, Mean);
	setResult("Area", N, Area);
	setResult("Label", N, Label);
	updateResults();
	j=j+1;
}
else {
if(Mean>Threshold){
	N=NumberofValues+j;
	setResult("Mean", N, Mean);
	setResult("Area", N, Area);
	setResult("Label", N, Label);
	x=j;
	roiManager("select", x);
	MeanName=round(Mean);
	roiManager("rename", MeanName);
	updateResults();
	j=j+1;

}


else {
	x=j;
	print("ROI Index:"+x);
	roiManager("select", x);
	//LabelArray=split(Label, ":");
//	ROINAME=LabelArray[1];
	roiManager("delete");
}
}
}


updateResults();
NewNumofValues=nResults();
print("NewNumofValues: "+NewNumofValues);
for (g=NumberofValues; g<NewNumofValues; g++){
Label=getResultLabel(g);
LabelArray=split(Label, ":");
ImageTitle= LabelArray[0];
LabelNumber=LabelArray[1];
LabelNumber=split(LabelNumber,"-");
LabelNumber=LabelNumber[0];
LabelNumber=parseFloat(LabelNumber);
print("ImageTitle: "+ImageTitle);
print("LabelNumber: "+LabelNumber);
}






run("Labels...", "color=white font=8 show use draw");
roiManager("Show All with labels");
roiManager("Draw");
saveAs("results", HOME+"Dropbox (Waldman Lab)/"+Title+" Results.xls");
saveAs("Tiff", HOME+"Dropbox (Waldman Lab)/"+Title+"-Drawn ROIs.tif");
selectWindow("Results");
run("Close");
close();
close();


}
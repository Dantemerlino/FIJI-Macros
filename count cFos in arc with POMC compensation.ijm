var ExpComp=1.02;
var MinPOMC=700;

var HOME=getDirectory("home");
var CellSize=60;
var ChannelOI=4;
var Threshold=200;
var MeasuredChannel=1;
	close("ROI*");
setBatchMode(true);
dir=getDirectory("Choose your directory");
//dir=File.directory();
list=getFileList(dir);
Array.print(list);
for (s=0; s<list.length; s++){
//for (i=0; i<1; i++){	
path=dir+list[s];
open(path);
Title=getTitle();
 RO=isOpen("Results");
 if(RO==1){
selectWindow("Results");
run("Close");
}
run("Select None");
//run("Subtract Background...", "rolling=50");
Stack.setChannel(ChannelOI);
run("Despeckle", "slice");
run("Despeckle", "slice");
run("Despeckle", "slice");
run("Gaussian Blur...", "sigma=2 slice");
run("Subtract Background...", "rolling=20 stack");
run("Duplicate...", "title=["+Title+" Binary] duplicate duplicate channels="+ChannelOI);

selectWindow(Title+" Binary");
//run("Robust Automatic Threshold Selection", "noise=25 lambda=3 min=271 verbose");

run("Auto Threshold", "method=Otsu ignore_black ignore_white white");
run("Watershed");

close(Title);
open(path);
//setTool("polygon");
selectWindow(Title);

run("Set Measurements...", "area mean integrated stack display redirect=["+Title+"] decimal=3");
selectWindow(Title);		
Stack.setChannel(ChannelOI);
selectWindow(Title+ " Binary");	
run("Analyze Particles...", "size="+CellSize+"-Infinity circularity=0.4-1.00 show=Overlay display summarize add");
NumberofValues=nResults();
run("To ROI Manager");
selectWindow(Title+ " Binary");	
close();
//run("Set Measurements...", "area mean integrated stack display redirect=None decimal=3");
ROICOUNT=roiManager("count");
ROIArray = newArray(ROICOUNT);
selectWindow("Results");
run("Close");
  for (i=0; i<ROIArray.length; i++){
      ROIArray[i] = i;
      }
      for(i=0; i<ROIArray.length; i++){
      	roiManager("select", i);
      	roiManager("rename", i);
      	Stack.setDisplayMode("color");
      	Stack.setChannel(ChannelOI);
      	run("Measure");
      								  }

for(i=0; i<ROIArray.length; i++)
		{
      	CompensationChannelIntensity=getResult("Mean", i);
      	if(CompensationChannelIntensity> MinPOMC)
      			{	
			CorrectionFactor=pow(CompensationChannelIntensity, ExpComp);
			CorrectionFactor=CorrectionFactor-CompensationChannelIntensity;
			print("CorrectionFactor: "+i+": "+CorrectionFactor);
			Stack.setChannel(MeasuredChannel);
			roiManager("select", i);
			run("Subtract...", "value="+CorrectionFactor+" slice");
      			}
        }

        saveAs("Tiff", path+" compensated.tif");
close(Title+" compensated.tif");


selectWindow("Results");
run("Close");
close("ROI*");
open(path+" compensated.tif");
run("Select None");
Title=getTitle();
Stack.setDisplayMode("color");
Stack.setChannel(MeasuredChannel);
run("Duplicate...", "title=["+Title+" Binary] duplicate duplicate channels="+MeasuredChannel);
selectWindow(Title+" Binary");
run("Despeckle");
run("Unsharp Mask...", "radius=4 mask=0.90");
run("Despeckle");
run("Auto Threshold", "method=Triangle ignore_black ignore_white white");
run("Watershed");



close(Title);
open(dir+Title);
setTool("polygon");
selectWindow(Title);
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
open(dir+Title);
run("Set Measurements...", "area mean integrated stack display redirect=["+Title+"] decimal=3");
selectWindow(Title);		
Stack.setChannel(MeasuredChannel);
selectWindow(Title+ " Binary");	
roiManager("Select", k);
//Stack.setChannel(ChannelOI);
run("Analyze Particles...", "size="+CellSize+"-Infinity circularity=0.6-1.00 show=Overlay display summarize add");
}
	close(Title);
	open(path);
Stack.setChannel(MeasuredChannel);	


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
//roiManager("Draw");
saveAs("results", dir+Title+" Results.xls");
saveAs("Tiff", dir+Title+"-Drawn ROIs.tif");
selectWindow("Results");
run("Close");
close();
close();
//File.delete(path+" compensated.tif");

}
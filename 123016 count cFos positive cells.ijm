






var HOME=getDirectory("home");

var CellSize=60;
var ChannelOI=1;

setBatchMode(true);
dir=getDirectory("Choose your directory");
//dir=File.directory();
list=getFileList(dir);
for (i=0; i<list.length; i++){
path=dir+list[i];
open(path);
Title=getTitle();


run("Subtract Background...", "rolling=50");
run("Despeckle");
run("Gaussian Blur...", "sigma=2");


run("Duplicate...", "title=["+Title+" Binary] duplicate duplicate channels="+ChannelOI);

selectWindow(Title+" Binary");
//run("Robust Automatic Threshold Selection", "noise=25 lambda=3 min=271 verbose");

run("Auto Threshold", "method=Triangle white");

//run("Watershed");




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
		setMinAndMax(50, 100);
		Stack.setDisplayMode("Composite");
		Stack.setActiveChannels("0111");
	setBatchMode("exit and display");
	waitForUser("Create a region of interest around the nuclei to be measured. Then, Press OK.");
	run("To ROI Manager");

ROICOUNT=roiManager("count");
//print(ROICOUNT);

for (m=0; m<ROICOUNT; m++){
		setBatchMode(true);
	run("Set Measurements...", "area mean integrated stack display redirect=None decimal=3");
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
roiManager("Show All with labels");
//roiManager("Draw");

saveAs("Tiff", HOME+"Dropbox (Waldman Lab)/"+Title+"-Drawn ROIs.tif");
close();
close();
}

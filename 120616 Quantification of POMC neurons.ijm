

var HOME=getDirectory("home");

var CellSize=100;


dir=getDirectory("Get your directory");
list=getFileList(dir);
for (i=0; i<list.length; i++){
	setBatchMode(true);
	Title=list[i];
	path=dir+list[i];
	QuantifyPOMC(path);
	
}


function QuantifyPOMC(path) {
open(path);
Title=getTitle;
run("Set Measurements...", "area mean integrated stack limit display redirect=["+Title+"] decimal=3");
run("Duplicate...", "title=["+Title+" Binary] duplicate channels=4");
run("Subtract Background...", "rolling=50 ");
run("Despeckle");
run("Gaussian Blur...", "sigma=2");
run("Auto Threshold", "method=Otsu ignore_black white");
setOption("BlackBackground", true);
run("Watershed");
setTool("polygon");
selectWindow(Title);

	close("ROI*");
	setBatchMode("exit and display");
waitForUser("Create a region of interest around the nuclei to be measured. Then, Press OK.");
run("To ROI Manager");

ROICOUNT=roiManager("count");

for (k=0; k<ROICOUNT; k++){

	setBatchMode(true);
selectWindow(Title);	
for (m=0; m<ROICOUNT; m++){
roiManager("Select", m);
run("Measure");
}

//	close();
//	open(path);

j=k+1;
selectWindow(Title+ " Binary");	
roiManager("Select", k);

run("Set Measurements...", "area mean integrated stack limit display redirect=["+Title+"] decimal=3");
run("Analyze Particles...", "size="+CellSize+"-Infinity circularity=0.4-1.00 show=Overlay display summarize add");
}
selectWindow(Title);
roiManager("Show All with labels");
roiManager("Draw");
saveAs("Tiff", HOME+"Dropbox (Waldman Lab)/cFOS IF after fasting/POMC Quantification/"+Title+"-Drawn ROIs, region "+j+".tiff");
close();
close();
}


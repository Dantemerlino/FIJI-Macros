






var HOME=getDirectory("home");

var CellSize=60;

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


run("Duplicate...", "title=["+Title+" Binary] duplicate duplicate channels=1");

selectWindow(Title+" Binary");
run("Auto Threshold", "method=Triangle white");

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








//setTool("polygon");
selectWindow(Title);
close();
	close("ROI*");
	open(path);
	setBatchMode("exit and display");
waitForUser("Create a region of interest around the nuclei to be measured. Then, Press OK.");

//if (Overlay.size==0){
run("Add Selection...");
//}
run("To ROI Manager");
//roiManager("Update");
	setBatchMode(true);
selectWindow(Title);	
	close();
	open(path);
	TITLE=getTitle();

selectWindow(Title+ " Binary");	
roiManager("Select", 0);

run("Set Measurements...", "area mean integrated stack limit display redirect=["+TITLE+"] decimal=3");
run("Analyze Particles...", "size="+CellSize+"-Infinity circularity=0.4-1.00 show=Overlay display summarize add stack");

selectWindow(TITLE);
close();
selectWindow(Title+" Binary");
close();

open(path);
roiManager("Show All without labels");
roiManager("Draw");
saveAs("Tiff", HOME+"Dropbox (Waldman Lab)/"+Title+"-Drawn ROIs, MinCell Size- "+CellSize+".tiff");
close();
//close();
roiManager("Delete");

}



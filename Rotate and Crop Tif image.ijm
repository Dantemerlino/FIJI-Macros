

macro "Rotate and Crop image" {
dir = getDirectory("Click on the folder with your Evos images");
list=getFileList(dir);
list=Array.sort(list);
q=list.length;
for (i=0; i<q; i++){
	path=list[i];
	open(dir+path);
	Name=File.nameWithoutExtension();
	processfiles();
}



function processfiles(){
Title=getTitle();
setBatchMode("exit and display");
Dialog.create("Adjust image before creating flattened scaled image with inset?");
Dialog.addMessage("Is this image acceptable?");
Dialog.addNumber("No; the image needs to be rotated by this many degrees: ", 0);
Dialog.show();

ROTATION=Dialog.getNumber();
setBatchMode(true);

if (ROTATION!=0){
Stack.setDisplayMode("composite");	
run("Rotate... ", "angle="+ROTATION+" grid=1 interpolation=Bilinear enlarge");
setBatchMode("exit and display");
makeRectangle(402, 720, 600, 495);
waitForUser("Adjust the rectangle until it surrounds your area of interest. Then, press OK.");
setBatchMode(true);	
run("Duplicate...", "title=["+Title+"-cropped.tif] duplicate");
close(Title);
selectWindow(Title+"-cropped.tif");
rename(Title);
}
saveAs("Tif", dir+Title);
close();
}
macro "Convert 4-channel Composite stitched image to panels of monochrome images" {
dir = getDirectory("Click on the folder with your Evos images");
dir2 = getDirectory("Click on the folder with your Evos images 2");
//dir2="/Users/dantemerlino/Dropbox (Waldman Lab)/GUCY2C Brain Mapping Docs/Scaled PNG images of stitched brain sections/Monochrome montages/";
list=getFileList(dir);
L=list.length;
//L=3;
setBatchMode(true);
count = 0;
countFiles(dir);
n = 0;
processFiles(dir);

function countFiles(dir) {
list = getFileList(dir);
list=Array.sort(list);
for (i=0; i<list.length; i++) {
if (endsWith(list[i], "/"))
countFiles(""+dir+list[i]);
else
count++;
}
}

function processFiles(dir) {
list = getFileList(dir);
list=Array.sort(list);
for (i=0; i<list.length; i++) {
if (endsWith(list[i], "/"))
processFiles(""+dir+list[i]);
else {
showProgress(n++, count);
path = dir+list[i];
MAKETHEMONTAGE(path);
}
}
}
Dialog.create("Done!");
Dialog.show();


function MAKETHEMONTAGE(path){
open(path);
name=File.nameWithoutExtension();
Title=getTitle();
pathFOLDER=dir+name+" monochromes /";
File.makeDirectory(pathFOLDER);
Stack.setDisplayMode("composite");


//run("TransformJ Scale", "x-factor=.5 y-factor=.5 z-factor=1.0 interpolation=[Nearest Neighbor] preserve");
//close(Title);
Title=getTitle;
run("Duplicate...", "title=[STACK] duplicate channels=1-4");
run("Flatten");
saveAs("PNG", pathFOLDER+name+" 5"+".png");
close(name+" 4"+".png");
selectWindow(Title);
run("Split Channels");
MONO1="C1-"+Title;
MONO2="C2-"+Title;
MONO3="C3-"+Title;
MONO4="C4-"+Title;

selectWindow(MONO1);
run("RGB Color");
saveAs("PNG", pathFOLDER+name+" 2"+".png");
close(name+" 2"+".png");
selectWindow(MONO2);
run("RGB Color");
saveAs("PNG", pathFOLDER+name+" 1"+".png");
close(name+"1"+".png");
selectWindow(MONO3);
run("RGB Color");
saveAs("PNG", pathFOLDER+name+" 3"+".png");
close(name+"3"+".png");
selectWindow(MONO4);
run("RGB Color");
saveAs("PNG", pathFOLDER+name+" 4"+".png");
close(name+"4"+".png");
run("Image Sequence...", "open=["+pathFOLDER+"] sort");
	title=getTitle();
	run("Make Montage...", "columns=5 rows=1 scale=1");
	selectWindow("Montage");
	saveAs("PNG", dir2+" Monochrome Montage"+name+".png");
	close("Monochrome Montage "+name+".png");
close(title);
File.delete(pathFOLDER+name+" 1"+".png");
File.delete(pathFOLDER+name+" 2"+".png");
File.delete(pathFOLDER+name+" 3"+".png");
File.delete(pathFOLDER+name+" 4"+".png");
File.delete(pathFOLDER+name+" 5"+".png");
File.delete(pathFOLDER);

}

}

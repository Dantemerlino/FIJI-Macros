macro "Give all images in a folder the same brightness and contrast"{
Home=getDirectory("home");

colors=newArray("Magenta", "Blue", "Green", "Red", "Cyan", "Yellow");


Dialog.create("Choose brightness and contrast for folder to be processed");
		Dialog.addNumber("CY5 Minimum:", 90);
		Dialog.addNumber("CY5 Maximum:", 500);
		Dialog.addChoice("What color would you like your Cy5 Channel?", colors, colors[4]);
		Dialog.addNumber("DAPI Minimum:", 0);
		Dialog.addNumber("DAPI Maximum:", 2500);
		Dialog.addChoice("What color would you like your DAPI Channel?", colors, colors[1]);
		Dialog.addNumber("GFP Minimum:", 50);
		Dialog.addNumber("GFP Maximum:", 800);
		Dialog.addChoice("What color would you like your GFP Channel?", colors, colors[2]);
		Dialog.addNumber("TxRed Minimum:", 50);
		Dialog.addNumber("TxRed Maximum:", 150);
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
dir=getDirectory("Choose the area with the composite images");
previousFolder=File.getParent(dir);
previousFolder=previousFolder+"/";
//print(previousFolder);
list = getFileList(dir);
listB=Array.sort(list);
setBatchMode(true);
L=listB.length;
for(i=0; i<L; i++){
path=dir+listB[i];
open(path);
Title=getTitle();
fixthecolor();
run("Save");
makeScaledPNG();
//close();
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


function makeScaledPNG(){
	getDimensions(width, height, channels, slices, frames);
W=width*0.2;
H=height*0.2;
Stack.setActiveChannels("1011");
run("Flatten");
//run("Scale...", "x=.2 y=.2 z=1.0 width="+W+" height="+H+" depth=4 interpolation=Bilinear average create title=["+Title+"-Scaled]");
File.makeDirectory(previousFolder+"scaled PNG images/");
dir2=previousFolder+"scaled PNG images/";
//print("dir2: "+dir2);
saveAs("PNG", dir2+Title+"Not scaled.png");
close();
}
}
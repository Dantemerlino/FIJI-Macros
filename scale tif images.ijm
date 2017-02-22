macro "Scale images" {

dir=getDirectory("Get your images to be scaled");
list=getFileList(dir);



ScaleFactor= newArray("0.1", "0.2", "0.3", "0.4", "0.5", "0.6", "0.7", "0.8", "0.9");
YesNo=newArray("Yes","No");
Dialog.create("Options:");
		Dialog.addChoice("Choose your Scale factor:", ScaleFactor);
		Dialog.addChoice("Flatten to RGB image?:", YesNo);
		Dialog.show();
		Scale=Dialog.getChoice();
		Scale=parseFloat(Scale);
		Flatten=Dialog.getChoice();

for (i=0; i<list.length; i++){
	setBatchMode(true);
	path=dir+list[i];
	open(path);
	Title=getTitle();
	ScaleImages(path);
}

function ScaleImages(path){
getDimensions(width, height, channels, slices, frames);
w=width*Scale;
print("w: "+w);
h=height*Scale;
print("h: "+h);
run("Scale...", "x="+Scale+" y="+Scale+" z=1.0 width="+w+" height="+h+" depth="+channels+" interpolation=Bilinear average create");
close(Title);
rename(Title);
if (Flatten==YesNo[0]){
	run("Flatten");
}
NewFOLDER=dir+" Scaled images/";
File.makeDirectory(NewFOLDER);
saveAs("PNG",NewFOLDER+Title+", "+Scale+" Scaled.png");
close();
}
}



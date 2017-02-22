

macro "Make Composite and Stitch [2]" {
	n=0;
OS=getInfo("os.name");
Mac=startsWith(OS,"M");
if (Mac==1){
	USEROS="Mac";
}
else USEROS="PC";
showStatus("User operating system: "+USEROS);
	Dialog.create("How to use the macro");
	Dialog.addMessage("This macro will take images with multiple channels and make them into composites. \n It will then stitch the composite images and create a fullsize, stitched, composite image.");
	Dialog.addMessage("You will first have the option to select the folder with your images. \n Then, a new file selection will pop up. \n You will select the folder you wish to save your final stitched images");
	Dialog.addMessage("Finally, a dialog box will appear with multiple options. You will need to know the number of areas in your pictures \n Please ensure you select the correct options, as it will dictate whether or not the macro works properly");
	Dialog.addMessage("Thanks!");
	Dialog.show();
	
	//Selecting directory with Evos pictures in it
var dir = getDirectory("Click on the folder with your Evos images");
FOLDERNAME=split(dir, "/");
FOLDERNAMELENGTH=FOLDERNAME.length;
FOLDERNAMELENGTH=FOLDERNAMELENGTH-1;
SCANNAME=FOLDERNAME[FOLDERNAMELENGTH];
var saveDir = getDirectory("Select where you want your stitched composites saved");
list=getFileList(dir);

for (i=0; i<list.length; i++){
	FIRSTPATH=dir+list[i];
	print(FIRSTPATH);
	/*
	if (endsWith(FIRSTPATH, ".sti")){
	File.delete();
	}
	else 
	*/
	PNGTEST=endsWith(FIRSTPATH, ".png");
	if (PNGTEST==1){
		PNGNAMESPLIT=split(list[i], ".");
		PNGAREA=PNGNAMESPLIT[0];
		NUMOFAREAS=substring(PNGAREA,4);
				print(NUMOFAREAS);
	NUMOFAREASnum=parseFloat(NUMOFAREAS);
	print("NUMOFAREASnum "+NUMOFAREASnum);
	if(!startsWith("0", NUMOFAREAS)){
			if (NUMOFAREASnum<10) {
				NUMOFAREAS="0"+NUMOFAREAS;
			File.rename(FIRSTPATH, dir+"Area"+NUMOFAREAS+".png");
			}}}}
list=getFileList(dir);
list=Array.sort(list);
LASTFILE=list.length;
LASTFILE=LASTFILE-1;
LASTFILE=list[LASTFILE];
LASTFILE=split(LASTFILE, ".");
NUMOFAREAS=LASTFILE[0];
NUMOFAREAS=substring(NUMOFAREAS,4);
Dialog.create("Hello. You are about to create a stitched image of your folder "+SCANNAME+". Please choose your options below:");
items= newArray("yes, rotate the image right", "yes, rotate the image left", "no, don't rotate the image");
items3=newArray("Yes", "No");
Dialog.addChoice("Do you want the final image rotated?", items);
Dialog.addChoice("Do you want the background subtracted?", items3);
Dialog.addNumber("How many areas are there?", NUMOFAREAS);
Dialog.show();
	//Universal Variables
var ROTATIONQ=Dialog.getChoice();
var SubtractBackgroundQ=Dialog.getChoice();
var compType=USEROS;
var areaNumber=Dialog.getNumber();
var SKIPIT=0;

processFiles(dir);
var list=getFileList(dir);
var list=Array.sort(list);

setBatchMode(true);
countcolors1(dir);
areaFolders(dir);
getXandY(dir);
Stitch(dir);

beep();
Dialog.create("Done!");
Dialog.show();









	//This function tests if each number of file types equal one another
	//For example, an error will be thrown if the number of DAPI images does not equal the number of CY5 images, etc.
function countcolors1 (dir) {
	setBatchMode(true);
 D=0;
 R=0;
 C=0;
 G=0;

for (i=0; i<list.length; i++) {
	Dx=endsWith(list[i], "DAPI.tif");
	Rx=endsWith(list[i], "Red.tif");
	Cx=endsWith(list[i], "CY5.tif");
	Gx=endsWith(list[i], "GFP.tif");
	if (Dx==1) {
		D=D+1;
	}
	else {
	D=D+0;
	}
	if (Rx==1) {
		R=R+1;
	}
	else {
	R=R+0;
	}
	if (Cx==1) {
		C=C+1;
	}
	else {
	C=C+0;
	}
	if (Gx==1) {
		G=G+1;
	}
	else {
	G=G+0;
}
	}
	if (D!=R) {
		if (R!=0) {
			if (D!=0) {
	Dialog.create("Error!");
	Dialog.addMessage("Number of DAPI images ("+D+") does not equal number of TxRed images ("+R+")");
	Dialog.addMessage ("Note: If the number of channels is not the same for each image, you will not be able to use this macro.");
	Dialog.addMessage("Press cancel, then go back to the source folder and delete images that do not have all colors you will be using.");
	Dialog.addMessage("Thanks!");
	Dialog.addMessage("-Dante");
	Dialog.show();
			}
		}
	}
	if (D!=G) {
		if (G!=0) {
			if (D!=0) {
	Dialog.create("Error!");
	Dialog.addMessage("Number of DAPI images ("+D+") does not equal number of GFP images ("+G+")");
	Dialog.addMessage ("Note: If the number of channels is not the same for each image, you will not be able to use this macro.");
	Dialog.addMessage("Press cancel, then go back to the source folder and delete images that do not have all colors you will be using.");
	Dialog.addMessage("Thanks!");
	Dialog.addMessage("-Dante");
	Dialog.show();
			}
		}
	}
	if (D!=C) {
		if (C!=0) {
			if (D!=0) {
	Dialog.create("Error!");
	Dialog.addMessage("Number of DAPI images ("+D+") does not equal number of Cy5 images ("+C+")");
	Dialog.addMessage ("Note: If the number of channels is not the same for each image, you will not be able to use this macro.");
	Dialog.addMessage("Press cancel, then go back to the source folder and delete images that do not have all colors you will be using.");
	Dialog.addMessage("Thanks!");
	Dialog.addMessage("-Dante");
	Dialog.show();
			}
		}
	}
	if (R!=G) {
		if (R!=0) {
			if (G!=0) {
	Dialog.create("Error!");
	Dialog.addMessage("Number of TxRed images ("+R+") does not equal number of GFP images ("+G+")");
	Dialog.addMessage ("Note: If the number of channels is not the same for each image, you will not be able to use this macro.");
	Dialog.addMessage("Press cancel, then go back to the source folder and delete images that do not have all colors you will be using.");
	Dialog.addMessage("Thanks!");
	Dialog.addMessage("-Dante");
	Dialog.show();
			}
		}
	}
	if (R!=C) {
		if (R!=0) {
			if (C!=0) {
	Dialog.create("Error!");
	Dialog.addMessage("Number of TxRed images ("+R+") does not equal number of Cy5 images ("+C+")");
	Dialog.addMessage ("Note: If the number of channels is not the same for each image, you will not be able to use this macro.");
	Dialog.addMessage("Press cancel, then go back to the source folder and delete images that do not have all colors you will be using.");
	Dialog.addMessage("Thanks!");
	Dialog.addMessage("-Dante");
	Dialog.show();
			}
		}
	}
	if (G!=C) {
		if (G!=0) {
			if (C!=0) {
	Dialog.create("Error!");
	Dialog.addMessage("Number of GFP images ("+G+") does not equal number of Cy5 images ("+C+")");
	Dialog.addMessage ("Note: If the number of channels is not the same for each image, you will not be able to use this macro.");
	Dialog.addMessage("Press cancel and go back to the source folder. Delete images that do not have all colors you will be using.");
	Dialog.addMessage("Thanks!");
	Dialog.addMessage("-Dante");
	Dialog.show();
			}
		}
	}
	NofChannels=(list.length-areaNumber)/D;
	makeComposite1(dir);
	
}


	//This function takes the multiple channels and creates composites
	//It also deletes the individual channels after the composite has been made
function makeComposite1 (dir) {
	setBatchMode(true);
    //NofChannels=list.length/D;
    Colors=NofChannels;
for (i=0; i<list.length; i++) {
	if (!startsWith(list[i], "Area")){
		open(dir+ list[i]);
		GETIMAGEINFO();
		title1=getTitle();
		x=split(title1, "_");
		XLENGTH=x.length;
		if (XLENGTH==2){
			title2 =x[0]+"_";
		}
		if (XLENGTH==5){
			title2 =x[0]+"_"+x[1]+"_"+x[2]+"_"+x[3]+"_";
		}
		if (Colors>1) {
			open(dir+ list[i+1]);
			GETIMAGEINFO();
		}
		 if (Colors>2) {
			open(dir+ list[i+2]);
			GETIMAGEINFO();
		}
		 if (Colors>3) {
			open(dir+ list[i+3]);
			GETIMAGEINFO();
		}
		run("Images to Stack", "name=["+title2+"] title=["+title2+"] use");
		run("Make Composite", "display=Composite");
		

		if (SubtractBackgroundQ==items3[0]){
		//Stack.setDisplayMode("color");
		//Stack.setChannel(2);
		run("Subtract Background...", "rolling=50 stack");
		}


/*		
		Stack.setDisplayMode("color");
		Stack.setChannel(1);
		Cy5Color="Magenta";
		DAPIColor="Blue";
		GFPColor="Green";
		TxRedColor="Red";
	if (C != 0) {
		run(Cy5Color);

	if (D != 0) {
		Stack.setChannel(2);
		run(DAPIColor);
	}
	if (G != 0) {
		Stack.setChannel(3);	
		run(GFPColor);
	
	if (R != 0) {
		Stack.setChannel(4);
		run(TxRedColor);
	}
	} 
	else if (G == 0) {
 		if (R!=0) {
 			Stack.setChannel(3);
			run(TxRedColor);
		}
	}
	} 
	else if (C == 0) {
		if (D != 0) {
			run(DAPIColor);
		}
		if (G != 0) {
			Stack.setChannel(2);
			run(GFPColor);
			
		if (R != 0) {
			Stack.setChannel(3);
			run(TxRedColor);
		}} else if (G == 0) {
 		if (R!=0) {
 			Stack.setChannel(2);
			run(TxRedColor);
 		}
	}
}
Stack.setDisplayMode("Composite");
*/
saveAs("Tiff", dir+title2+"Composite.tif");
run("Close");
		DELETE=1;
		if (DELETE==1) {
		File.delete(dir+title2+"TxRed.tif");
		File.delete(dir+title2+"DAPI.tif");	
		File.delete(dir+title2+"CY5.tif");
		File.delete(dir+title2+"GFP.tif");		
		}
		i=i+Colors-1;
	}		
	else if (startsWith(list[i], "Area")){
		SECONDPATH=list[i];
		SECONDPNGNAMESPLIT=split(SECONDPATH, ".");
		SECONDPNGAREA=SECONDPNGNAMESPLIT[0];
		SECONDNUMOFAREAS=substring(SECONDPNGAREA,4);
	SECONDNUMOFAREASnum=parseFloat(SECONDNUMOFAREAS);
	if (startsWith(SECONDNUMOFAREAS, "0")){
			File.rename(dir+SECONDPATH, dir+"Area"+SECONDNUMOFAREASnum+".png");
	}
}
}
}

//This function creates a list of files within the directory, reads the file names,
//and deletes the files that do not end in "Red.tif", "DAPI.tif", "GFP.tif", or "CY5.tif"
function ColorFiles(path) {
 setBatchMode(true);
 list = getFileList(dir);
	if (!endsWith(path, "Red.tif")) {

	if (!endsWith(path, "DAPI.tif")) {

	if (!endsWith(path, "GFP.tif")) {

	if (!endsWith(path, "CY5.tif")) {
 	
	if (!endsWith(path, ".png")){
		File.delete(path);
	}
	}
	}
	}
	}
}

	//This function processes the files within the directory and sets them up to be processed by ColorFiles()
function processFiles(dir) {
setBatchMode(true);
list = getFileList(dir);
for (i=0; i<list.length; i++) {
	if (compType=="Mac"){
		if (endsWith(list[i], "/")){
			processFiles(""+dir+list[i]);
		} else {
			path = dir+list[i];
			ColorFiles(path);
		}
	} else if (compType=="PC"){
		if (endsWith(list[i], "\\")){
			processFiles(""+dir+list[i]);
		} else {
			path = dir+list[i];
			ColorFiles(path);
		}
	}
}
}


	//This function creates area folders based on the number of areas stated by the user
	//in the dialog box. This folders will be placed in the original directory (dir)
function areaFolders (dir) {
dirParent=File.getParent(dir);
if (compType=="PC"){
	previousFolder=dirParent+"\\";
} else if (compType=="Mac"){
	previousFolder=dirParent+"/";
	}
	
print(previousFolder);
list = getFileList(dir);
listB=Array.sort(list);
Array.print(list);
setBatchMode(true);
L=listB.length;
print("L: "+L);

for (w=1; w<=areaNumber; w++){
File.makeDirectory(dir+"Area"+w);
}
for (i=0; i<L; i++){
	if (!startsWith(listB[i], "Area")){
		file_name=listB[i];
		print("file_name: "+file_name);
		split_file_name=split(file_name, "_");
		Area=split_file_name[2]+"_";
	if (compType=="PC"){
		AreaFolder=split_file_name[2]+"\\";
	} else if (compType=="Mac"){
		AreaFolder=split_file_name[2]+"/";
	} 
	} else if (startsWith(listB[i], "Area")) {
		file_name=listB[i];
		print("file_name: "+file_name);
		split_file_name=split(file_name, ".");
		Area=split_file_name[0]+"_";
		if (compType=="PC"){
		AreaFolder=split_file_name[0]+"\\";
	} else if (compType=="Mac"){
		AreaFolder=split_file_name[0]+"/";
	}
	}
File.rename(dir+file_name, dir+AreaFolder+file_name);
}
//getXandY(dir);
}


	//This function calculates the x and y variables for stitching the final image
	//using the dimensions of the included .PNG file
	//It renames the .png with the x_y dimensions -> the .png will be deleted later
function getXandY(dir){
	folderList = getFileList(dir);
	dirParent = File.getParent(dir);
	dirParentList = getFileList(dirParent);
for (p=0; p<folderList.length; p++){
	imagelist = getFileList(dir+folderList[p]);
	for (j=0; j<imagelist.length; j++){
		if (startsWith(imagelist[j], "Area")){
			setBatchMode(true);
			open(dir+folderList[p]+imagelist[j]);
			title = getTitle();
			splitTitle = split(title, ".");
			getDimensions(width, height, channels, slices, frames);
			x = width/1280;
			y = height/960;
//Use rounding script to get x and y from 1280x960
//x=round(x);
//y=round(y);
			total=x*y;
			PNGratio=x/y;
			D = imagelist.length-1;
			print ("D: "+D);
//print("PNGratio = "+PNGratio);
		for (i=1; i<D; i++){
			y=D/i;
//print(i+"y = "+y);
			Inty=parseInt(y);
//print(i+"Inty = "+Inty);	
			if (Inty==y){
				ratio= i/y;
//print("x could equal "+i+" and y could equal "+y+", and ratio will equal "+ratio);
				RatioTest=PNGratio-ratio;
				RatioTest=abs(RatioTest);
//print("RatioTest: "+RatioTest);
				if (RatioTest <= 0.1){
					x=i;
					y=Inty;
					print("x = "+x);
					print("y = "+y);
					File.rename(dir+folderList[p]+imagelist[j], dir+folderList[p]+splitTitle[0]+"_"+x+"_"+y);
				}
			}
		}
		close();
		}
	}
}
}

	//This function creates the full composite stitched image. It renames the images to 
	//appease the needs of the stitching plugin then stitches the pictures based on
	//x and y coordinates previously found.
function Stitch(dir) {
var newList = getFileList(dir);

if (ROTATIONQ==items[0]){
	ROTATIONQ="Right";
} else if (ROTATIONQ==items[1]){
	ROTATIONQ="Left";
	} else if (ROTATIONQ==items[2]){
	SKIPIT=1;
		}	

//print("ROTATIONQ = "+ROTATIONQ);

for (m=0; m<newList.length; m++){
	
path1=dir+newList[m];
DIRECTORYQ=File.isDirectory(path1);

	if (DIRECTORYQ==1){
		path2=dir+newList[m];
		path3=newList[m];
		if (compType=="Mac"){
			path3=split(path3, "/");
		} else if (compType=="PC"){
			path3 =split(path3, "\\");
		}
		path4=path3[0];
		listI=getFileList(path2);
		title=path4;
		XANDY=split(title, "_");
		TITLE=XANDY[0];
		TITLE_split=split(TITLE,"/");
		TITLE=TITLE_split[0];
		Renamescannedimages3 (dir);
    	StitchImages3 (dir);
    	SaveImages3();	
	} else {
		for (m=0; m<newList.length; m++){
			image_list=getFileList(newList[m]);
			path2=dir+list[m];
			listI=image_list;
			path2=dir;
			path3=path2;
			if (compType=="Mac"){
				path4=split(path3, "/");
			} else if (compType=="PC"){
				path4=split(path3, "\\");
			}
			path3num=path4.length;
			path3num=path3num-1;
			path4=path4[path3num];
		}
//	    print("path2="+path2);
//    print("path3="+path3); 
//     print("path4="+path4);    
	//Renamescannedimages3 (dir);
    //StitchImages3 (dir);
   
	}
}	
}

	//This function renames the images in order to meet the needs of the subsequent 
	//stitching program. e.g. making the image numbers "01" instead of "1"
function Renamescannedimages3 (dir) {

listB=Array.sort(listI);
//Array.show(listB);
setBatchMode(true);
L=listB.length;

for (i=0; i<listB.length; i++){
	if (!startsWith(listB[i], "Area")){
		file_name=listB[i];
		splitfile_name=split(file_name, "_");
		Array.print(splitfile_name);
		date=splitfile_name[0]+"_";
		scanname=splitfile_name[1]+"_";
		AreaActual=splitfile_name[3];
		Area=splitfile_name[2]+"_";
		imagenumber=splitfile_name[3]+"_";
		color=splitfile_name[4];
	}
//print("date: "+date);
//print("scanname: "+scanname);
//print("imagenumber: "+imagenumber);
//print("color: "+color);
//print("AreaActual: "+AreaActual);
	j=AreaActual;
	jnum=parseFloat(j);
	if (!startsWith(j, "0")){
		if (L<100){
			if (jnum<10) {
				j="0"+j;
			}
			File.rename(path2+file_name, path2+date+scanname+Area+j+"_"+color);
		} else if (L<1000){
			if (jnum<10) {
				j="0"+j;
			}
			if (jnum<100) {
				j="0"+j;
			}
			File.rename(path2+file_name, path2+date+scanname+Area+j+"_"+color);
		}
	}
}
}

	//This function runs the Grid/Collection plugin to stitch the composite images 
	//into a full size image of the area in question
function StitchImages3 (dir) {
dirParent = File.getParent(dir);
folderList = getFileList(dirParent);
title=path4;
XANDY=split(title, "_");
TITLE=XANDY[0];
//x=XANDY[1];
//y=XANDY[2];
//print("x="+x);
//print("y="+y);

file_names=listI[0];
file_names=split(file_names, "_");
date=file_names[0]+"_";
scanname=file_names[1]+"_";
Area=file_names[2]+"_";
imagenumber=file_names[3]+"_";
color=file_names[4];
if (listI.length<10) {
	Name=date+scanname+Area+"{i}_"+color;
} else if (listI.length<100) {
	Name=date+scanname+Area+"{ii}_"+color;
} else if (listI.length<1000) {
	Name=date+scanname+Area+"{iii}_"+color;	
} else if (listI.length<10000) {
	Name=date+scanname+Area+"{iiii}_"+color;	
}
var x = 0;
var y = 0;

	Array.print (listI);
	for (j=0; j<listI.length; j++){
		if (startsWith(listI[j], "Area")){
			png_title = listI[j];
			print("png_title_x_y: "+png_title);
			split_png_title = split(png_title, "_");
			area_name = split_png_title[0];
			x = split_png_title [1];
			y = split_png_title[2];
			print("x = "+x);
			print("y = "+y);
		}
		if (startsWith(listI[j], "Area")){
			File.delete(path2+listI[j]);
		}
	}

	print("path2?: "+path2);

run("Grid/Collection stitching", "type=[Grid: row-by-row] order=[Right & Up] grid_size_x="+x+" grid_size_y="+y+" tile_overlap=10 first_file_index_i=1 directory=["+path2+"] file_names="+Name+" output_textfile_name=TileConfiguration.txt fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 compute_overlap computation_parameters=[Save computation time (but use more RAM)] image_output=[Fuse and display]");
}



function SaveImages3() {
setBatchMode(true);
selectWindow("Fused");
//rename(title+" "+color);
//selectWindow(title+" "+color);
//run("Subtract Background...", "rolling=20 sliding");
if (SKIPIT!=1){
run("Rotate 90 Degrees "+ROTATIONQ);
}
Stack.setDisplayMode("color");
Stack.setChannel(1);
run("Red");
setMinAndMax(30, 1000);
Stack.setChannel(2);
run("Blue");
setMinAndMax(0, 4096);
Stack.setChannel(3);
run("Green");
setMinAndMax(100, 2000);
Stack.setChannel(4);
run("Magenta");
setMinAndMax(0, 600);
Stack.setDisplayMode("composite");
path=TITLE+".tif";
//Dialog.create("Save your Composite Tiff scan");
//Dialog.addString("Save As:",path,80 );
//Dialog.show();
//path=Dialog.getString();
saveAs("Tiff", saveDir+SCANNAME+path);
close();
}

function GETIMAGEINFO(){
	Name=getTitle();
string=getImageInfo();
StringArray=split(string, "\n\r");
ImageDescription=StringArray[0];
ImageDescriptionArray=split(ImageDescription, " ");
/*
nit=ImageDescriptionArray.length;
for (i=0; i<nit; i++){
	print("ImageDescriptionArray "+i+":");
	print(ImageDescriptionArray[i]);

}
*/


ExposureTime=ImageDescriptionArray[27];
ExposureTime=split(ExposureTime, "=");
ExposureTime=ExposureTime[1];
ExposureTimelength=lengthOf(ExposureTime);
x=ExposureTimelength-1;
ExposureTime=substring(ExposureTime, 1,5);
//print("Exposure time (ms): "+ExposureTime);

Gain=ImageDescriptionArray[30];
Gain=split(Gain, "=");
Gain=Gain[1];
Gainlength=lengthOf(Gain);
y=Gainlength-1;
Gain=substring(Gain, 1,4);
//print("Gain: "+ Gain);


Light=ImageDescriptionArray[31];
Light=split(Light, "=");
Light=Light[1];
Lightlength=lengthOf(Light);
z=Lightlength-1;
Light=substring(Light, 1,z);
//print("Light: "+Light);

FilterCube=ImageDescriptionArray[29];
FilterCube=split(FilterCube, "=");
FilterCube=FilterCube[1];
FilterCubelength=lengthOf(FilterCube);
zi=FilterCubelength-1;
FilterCube=substring(FilterCube, 1,zi);
//print("FilterCube: "+FilterCube);
setMetadata("Info", "Title: "+Name+"  Exp: "+ExposureTime+"  Gain: "+Gain+"  Light: "+Light+"  FilterCube: "+FilterCube);
setMetadata("Label", "Exp: "+ExposureTime+"  Gain: "+Gain+"  Light: "+Light+"  FilterCube: "+FilterCube+" Title: "+Name);
}
}

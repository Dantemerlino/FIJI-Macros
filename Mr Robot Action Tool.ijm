
 

macro "Mr Robot. Action Tool - C000D00D01D02D03D04D05D06D07D08D09D0aD0bD0cD0dD0eD0fD10D1eD1fD20D22D23D24D25D26D27D28D29D2aD2bD2cD2dD2eD2fD30D32D33D34D3eD3fD40D41D43D44D46D47D48D49D4aD4bD4cD4dD4eD4fD50D51D52D54D55D57D58D59D5aD5bD5cD5dD5eD5fD60D61D62D63D65D66D68D69D6aD6bD6cD6dD6eD6fD70D71D72D73D74D76D77D79D7aD7bD7cD7dD7eD7fD80D81D82D83D85D86D88D89D8aD8bD8cD8dD8eD8fD90D91D92D94D95D97D98D99D9aD9bD9cD9dD9eD9fDa0Da1Da3Da4Da6Da7Da8Da9DaaDabDacDadDaeDafDb0Db2Db3Db4DbeDbfDc0Dc2Dc3Dc4Dc5Dc6Dc7Dc8Dc9DcaDcbDccDcdDceDcfDd0DdeDdfDe0De1De2De3De4De5De6De7De8De9DeaDebDecDedDeeDefDf0Df1Df2Df3Df4Df5Df6Df7Df8Df9DfaDfbDfcDfdDfeDffC000C100C200C300C400C500C600C700C800C900Ca00Cb00Cc00Cd00Ce00Cf00C000C010C020C030C040C050C060C070C080C090C0a0C0b0C0c0C0d0C0e0C0f0D11D12D13D14D15D16D17D18D19D1aD1bD1cD1dD21D31D35D36D37D38D39D3aD3bD3cD3dD42D45D53D56D64D67D75D78D84D87D93D96Da2Da5Db1Db5Db6Db7Db8Db9DbaDbbDbcDbdDc1Dd1Dd2Dd3Dd4Dd5Dd6Dd7Dd8Dd9DdaDdbDdcDdd"{
OS=getInfo("os.name");
Mac=startsWith(OS,"M");
if (Mac==1){
	USEROS="Mac";
}
else USEROS="PC";

var HOME=getDirectory("home");
var DNADir=HOME+"Google Drive/DNA Gel Archive/";
//print(DNADir);

var WBDir=HOME+"Google Drive/Western Blot Archive/";
//print(WBDir);
YesNo=newArray("Yes","No");
//print(HOME);
FIJILogFolder=HOME+"FIJI log/";
FIJILogExists=File.exists(FIJILogFolder);
if (FIJILogExists==0){
	File.makeDirectory(FIJILogFolder);
}

"\\Clear";
getDateandTime();
TOOLS=newArray("Dilute a solution to a certain concentration", "Dissolve a solid in a liquid to a final concentration", "dilute cells to a certain concentration", "Image and Analyze a DNA gel", "Image and analyze a western blot", "Analyze Evos images", "Analyze a cGMP ELISA"); 
Diluent=newArray("Water", "PBS", "DMSO", "Milk", "Media", "Other");
Units=newArray("pM", "nM", "uM", "mM", "M","mg/mL", "% (w/v)", "%(v/v)");
Units=newArray("pM", "nM", "uM", "mM", "M", "g/mL", "mg/mL", "ug/mL", "% (w/v)", "%(v/v)");
VolumeUnits=newArray("μL", "mL", "L");
Dialog.create("Hi! I'm your Robotic Dante.");
		Dialog.addChoice("What do you need to do?", TOOLS);
		Dialog.show();
		 SELECTION = Dialog.getChoice();

		if (SELECTION==TOOLS[0]){print("Ok, you've chosen '"+ TOOLS[0]+"'");
			Dilute();
		}

		if (SELECTION== TOOLS[1]){print("Ok, you've chosen '"+ TOOLS[1]+"'");
			Dissolve();
		}

		if (SELECTION== TOOLS[2]){print("Ok, you've chosen '"+ TOOLS[2]+"'");
			DiluteCells();
		}
		if (SELECTION== TOOLS[3]){print("Ok, you've chosen '"+ TOOLS[3]+"'");
			DNAGel();
		}

		if (SELECTION== TOOLS[4]){print("Ok, you've chosen '"+ TOOLS[4]+"'");
			WesternBlot();
		}
		if (SELECTION== TOOLS[5]){print("Ok, you've chosen '"+ TOOLS[5]+"'");
			Evos();
		}

		if (SELECTION== TOOLS[6]){print("Ok, you've chosen '"+ TOOLS[6]+"'");
			InProgress();
		}

LogEvents();





		
function Dilute(){
Dialog.create("Dilution Wizard: Remember, C1V1=C2V2");
		Dialog.addMessage("Please fill out the following:");
		Dialog.addString("Name of the solution:", " ");
		Dialog.addNumber("Starting concentration of solution:", 100, 2, 10,"");
		Dialog.setInsets(-26, 95, 0);
		Dialog.addChoice("", Units,Units[4]);
		Dialog.addChoice("What are you diluting with?", Diluent, Diluent[0]);
		Dialog.addNumber("Desired final concentration:", 1, 2, 10,"");
		Dialog.setInsets(-26, 95, 0);
		Dialog.addChoice("",Units,Units[2]);
		Dialog.addMessage("- - -");
		Dialog.addMessage("Choose 1:");
		Dialog.addCheckbox("I would like to make a solution with a final desired volume", false);
		Dialog.addNumber("How much do you need?", 100, 2, 10,"");
		Dialog.setInsets(-26, 95, 0);
		Dialog.addChoice("",VolumeUnits,VolumeUnits[1]);

		
		Dialog.addCheckbox("I would like to dilute an initial volume to a final percentage", false);
		Dialog.addNumber("Starting volume of solution:", 25, 0, 10,"");
		Dialog.setInsets(-26, 95, 0);
		Dialog.addChoice("",VolumeUnits,VolumeUnits[1]);
		
		Dialog.show();

SolutionName=Dialog.getString();
C1=Dialog.getNumber();
C1Unit=Dialog.getChoice();
DiluentChoice= Dialog.getChoice();
C2=Dialog.getNumber();
C2Unit=Dialog.getChoice();

FinalVolume=Dialog.getCheckbox();
V2=Dialog.getNumber();
V2Unit=Dialog.getChoice();
InitialVolume=Dialog.getCheckbox();
if (InitialVolume==1){
V1=Dialog.getNumber();
V1Unit=Dialog.getChoice();
}
	if (DiluentChoice==Diluent[5]){
		Dialog.create("Other:");
		Dialog.addString("Name of the diluent", "", 80);
		Dialog.show();
		DiluentChoice= Dialog.getString();
	}
		if (C1Unit==Units[5]){
		Dialog.create("Molar Mass:");
		Dialog.addMessage("If you want to convert mg/mL to molarity,");
		Dialog.addMessage("I need to know the molar mass of the compound.");
		Dialog.addMessage("For example, Linaclotide is 1527 g/mol.");
		Dialog.addNumber("molar mass of compound", 1527, 0, 20,"g/mol");
		Dialog.show();
		MolarMass= Dialog.getNumber();
		C1=C1/MolarMass;
		C1Unit=Units[4];
	}


if (InitialVolume==1){
DiluenttoAdd=V2-V1;
if (C1==0){
	C1=100;
	C2=100-C2;
SolutionName1=SolutionName;	
SolutionName=DiluentChoice;
DiluentChoice=SolutionName1;
	}
V2=V1*C1/C2;
DiluenttoAdd=V2-V1;
Dialog.create("Dilution Wizard, part 2");
Dialog.addMessage("V1=V2*C2/C1");
Dialog.addMessage(V1+"="+V2+"*"+C2+"/"+C1);
Dialog.addMessage("Volume of "+SolutionName+" to add: "+V1+" "+V1Unit);
Dialog.addMessage("Volume of "+DiluentChoice+" to add: "+DiluenttoAdd+" "+V1Unit);
Dialog.addMessage("Once you add "+V1+" "+V1Unit+" of "+SolutionName+" to "+DiluenttoAdd+" "+V1Unit+" of "+DiluentChoice+ ", you will have a "+C2+" "+ C2Unit+" solution of "+SolutionName+".");
Dialog.show();	
}

else{
		if (DiluentChoice==Diluent[5]){
		Dialog.create("Other:");
		Dialog.addString("Name of the Diluent", "", 80);
		Dialog.show();
		DiluentChoice= Dialog.getString();
	}
		if (C1Unit==Units[5]){
		Dialog.create("Molar Mass:");
		Dialog.addMessage("If you want to convert mg/mL to molarity,");
		Dialog.addMessage("I need to know the molar mass of the compound.");
		Dialog.addMessage("For example, Linaclotide is 1527 g/mol.");
		Dialog.addNumber("molar mass of compound", 1527, 0, 20,"g/mol");
		Dialog.show();
		MolarMass= Dialog.getNumber();
		C1=C1/MolarMass;
		C1Unit=Units[4];
	}


if (C1Unit==C2Unit){
V1=V2*C1/C2;
}
else {
	if (C1Unit==Units[0]){
		C1=C1/1000000000000;
	}
		if (C1Unit==Units[1]){
		C1=C1/1000000000;
	}
		if (C1Unit==Units[2]){
		C1=C1/1000000;
	}
		if (C1Unit==Units[3]){
		C1=C1/1000;
	}
	if (C2Unit==Units[0]){
		C2=C2/1000000000000;
	}
		if (C2Unit==Units[1]){
		C2=C2/1000000000;
	}
		if (C2Unit==Units[2]){
		C2=C2/1000000;
	}
		if (C2Unit==Units[3]){
		C2=C2/1000;
	}
}
V1=V2*C2/C1;
DilutionFactor=C1/C2;
//print("DilutionFactor: "+DilutionFactor);
DiluenttoAdd=V2-V1;

if(V2Unit==VolumeUnits[0]){

if(V1>1){
Dialog.create("Dilution Wizard");
Dialog.addMessage("V1=V2*C2/C1");
Dialog.addMessage(V1+"="+V2+"*"+C2+"/"+C1);
Dialog.addMessage("Volume of "+SolutionName+" to add: "+V1+" "+V2Unit);
Dialog.addMessage("Volume of "+DiluentChoice+" to add: "+DiluenttoAdd+" "+V2Unit);
Dialog.show();	
}


else {
	Dialog.create("Dilution Wizard");
	Dialog.addMessage("It looks like you need to dilute your stock solution 1:"+DilutionFactor);
Dialog.addMessage("That means you'll need to dilute your stock multiple times.");
Dialog.addMessage("But don't worry! I'll walk you through it.");
Dialog.addMessage("To begin, dilute your stock solution 1:100.");
Dialog.addMessage("In other words, add 1 μL of your stock solution to 99 μL of "+DiluentChoice);
Dialog.addCheckbox("Check this box and press OK once you've made this solution.", false);
Dialog.show();
NEXT=Dialog.getCheckbox();

if (NEXT==1){
	V1=V1*100;
	C1=C1/100;
	DiluenttoAdd=V2-V1;
		Dialog.create("Dilution Wizard, part 2");
Dialog.addMessage("Great job!");
Dialog.create("Dilution Wizard");
Dialog.addMessage("V1=V2*C2/C1");
Dialog.addMessage(V1+"="+V2+"*"+C2+"/"+C1);
Dialog.addMessage("Volume of diluted"+SolutionName+" to add: "+V1+" "+V2Unit);
Dialog.addMessage("Volume of "+DiluentChoice+" to add: "+DiluenttoAdd+" "+V2Unit);
Dialog.show();	
}
}


}
else{
DiluenttoAdd=V2-V1;
Dialog.create("Dilution Wizard, part 2");
Dialog.addMessage("V1=V2*C2/C1");
Dialog.addMessage(V1+"="+V2+"*"+C2+"/"+C1);
Dialog.addMessage("Volume of "+SolutionName+" to add: "+V1+" "+V2Unit);
Dialog.addMessage("Volume of "+DiluentChoice+" to add: "+DiluenttoAdd+" "+V2Unit);
Dialog.show();	
}


dump();
print("Volume of "+SolutionName+" to add: "+V1+" "+V2Unit);
print("Volume of "+DiluentChoice+" to add: "+DiluenttoAdd+" "+V2Unit);
}

}








///////////////////

function Dissolve(){
	Dialog.create("Dissolving Wizard: Remember, C1V1=C2V2");
		Dialog.addMessage("Please fill out the following:");
		Dialog.addString("Name of the powder you are dissolving:", " ");
		Dialog.addMessage("If you want to convert g/mL to molarity,");
		Dialog.addMessage("I need to know the molar mass of the compound.");
		Dialog.addMessage("For example, Linaclotide is 1527 g/mol.");
		Dialog.addNumber("What is the molar mass of the solution?", 1527, 2, 10,"g/mol");
//		Dialog.setInsets(-26, 95, 0);
//		Dialog.addChoice("", Units);
		Dialog.addChoice("What are you dissolving the powder in?", Diluent, Diluent[0]);
		Dialog.addNumber("Desired Final concentration:", 1, 2, 10,"");
		Dialog.setInsets(-26, 95, 0);
		Dialog.addChoice("",Units);
		Dialog.addNumber("How much volume do you need?", 100, 2, 10,"");
		Dialog.setInsets(-26, 95, 0);
		Dialog.addChoice("",VolumeUnits);
		Dialog.show();

PowderName=Dialog.getString();
MW=Dialog.getNumber();
DiluentChoice= Dialog.getChoice();
C2=Dialog.getNumber();
C2Unit=Dialog.getChoice();
V2=Dialog.getNumber();
V2Unit=Dialog.getChoice();
	if (DiluentChoice==Diluent[3]){
		Dialog.create("Other:");
		Dialog.addString("Name of the Diluent", "", 80);
		Dialog.show();
		DiluentChoice= Dialog.getString();
	}
		
	if (C2Unit==Units[0]){
		C2=C2/1000000000000;
		C2Unit=Units[4];
	}
		if (C2Unit==Units[1]){
		C2=C2/1000000000;
		C2Unit=Units[4];
	}
		if (C2Unit==Units[2]){
		C2=C2/1000000;
		C2Unit=Units[4];
	}
		if (C2Unit==Units[3]){
		C2=C2/1000;
		C2Unit=Units[4];
	}

if (V2Unit==VolumeUnits[0]){
		V2=V2/1000000;
		V2Unit=VolumeUnits[2];
	}
		if (V2Unit==VolumeUnits[1]){
		V2=V2/1000;
		V2Unit=VolumeUnits[2];
	}

molToAdd=V2*C2;
mgToAdd=molToAdd*MW*1000;


	if (C2Unit==Units[8]){
mgToAdd=1000/100*C2*V2*1000;
	}
//this will give you the number of mg to add


if (V2<0.001){
		V2=V2*1000000;
			V2Unit=VolumeUnits[0];
}
else if (V2<1){
	V2=V2*1000;
	V2Unit=VolumeUnits[1];
}

if(mgToAdd>1){
Dialog.create("Dissolving Wizard");
Dialog.addMessage("Volume of "+DiluentChoice+" to add: "+V2+" "+V2Unit);
Dialog.addMessage("mg of "+PowderName+" to add: "+mgToAdd+" mg");
Dialog.show();	
}


else {
	StockConc=2/MW;
	Dialog.create("Dissolving Wizard");
Dialog.addMessage("It looks like you'll need to make a stock solution and dilute it.");
Dialog.addMessage("But don't worry! I'll walk you through it.");
Dialog.addMessage("First, dissolve 1 mg of "+PowderName+" in 500 μL of " +DiluentChoice);
Dialog.addMessage("This solution will have a concentration of 2 mg/mL, or "+StockConc+" M.");
Dialog.addCheckbox("Check this box and press OK once you've made this solution.", false);
Dialog.show();
NEXT=Dialog.getCheckbox();
if (NEXT==1){
	V1=V2*C2/StockConc;
//	V2Unit=VolumeUnits[0];
	DiluenttoAdd=V2-V1;
	Dialog.create("Dissolving Wizard, part 2");
Dialog.addMessage("Great job!");
Dialog.addMessage("Now, add "+V1+" "+V2Unit+ " of your Stock concentration of "+PowderName+ " to "+DiluenttoAdd+ " "+V2Unit+ " of "+ DiluentChoice+".");
Dialog.show();
}
}
	Dialog.create("Dissolving Wizard, part 3");
Dialog.addMessage("Great job!");
Dialog.addMessage("Now that you have added " +mgToAdd+ " mg of "+PowderName+" to "+V2+" "+V2Unit+" of "+DiluentChoice+",");
Dialog.addMessage("You now have "+V2+" "+V2Unit+" of "+C2+" "+C2Unit+" "+PowderName+", dissolved in "+DiluentChoice+".");
Dialog.addMessage("Now go write that in your notebook!");
Dialog.show();
dump();
}






/////////////////////////////////

function DiluteCells(){
	Dialog.create("Cell Dilution Wizard: Remember, C1V1=C2V2");
		Dialog.addMessage("Please fill out the following:");
		Dialog.addString("Name of your cells:", "T cells");
		//CellType^^
		Dialog.addNumber("What is the concentration of your cell solution now?", 1000000, 0, 20,"cells/mL");
		//C1^^		
		Dialog.addNumber("How many mL of cells do you have?", 10, 0, 10,"mL");
		//V1Total^^
		Dialog.addNumber("What do you need your final cell concentration to be?", 50000, 0, 20,"cells/mL");
		//C2^^
		Dialog.addNumber("How many wells do you need to add cells to?",96,0,10,"wells");
		//NumofWells^^
		Dialog.addNumber("How many microliters do you need to add to each well?",200,0,10,"microliters");
		//VperWell^^
		Dialog.show();

CellType=Dialog.getString();
C1=Dialog.getNumber();
V1Total= Dialog.getNumber();
TotalCellNumber=C1*V1Total;
C2=Dialog.getNumber();
NUMofWells=Dialog.getNumber();
NUMofWellExcess=NUMofWells+1;
VperWell=Dialog.getNumber();
VperWell=VperWell/1000;
//turns VperWell from μL to mL


V2=VperWell*NUMofWellExcess;
V1=V2*C2/C1;
MediaToAdd=V2-V1;
V1=V1*1000;
//turns V1 from mL to μL
MaxPossibleV2=TotalCellNumber/C2;
MaxWells=MaxPossibleV2/VperWell;
MaxWells=floor(MaxWells);
MaxWellsExcess=MaxWells-1;

if (MediaToAdd<0){
	PelletResuspension=MaxPossibleV2;
	Dialog.create("Rats!");
		Dialog.addMessage("Bad News. Your cells are too dilute.");
		Dialog.addMessage("You have a total of "+TotalCellNumber+" "+CellType+" in "+V1Total+" mL." );
		Dialog.addMessage("If you spin down your cells and resuspend the cell pellet in "+PelletResuspension+" mL, you'll have enough cells for "+MaxWellsExcess+" wells at a concentration of "+C2+" cells/mL." );
}
if(MaxWellsExcess<NUMofWells){
	NotEnoughCells=newArray("decrease the number of wells", "decrease the concentration of cells per well");
	Dialog.addMessage("Oh no!");
	Dialog.addMessage("You need "+V2+ " mL of diluted cells to have enough volume for "+NUMofWells+" wells." );
	Dialog.addMessage("Unfortunately, you only have enough cells to plate "+MaxWellsExcess+" wells." );
	Dialog.addChoice("What would you like to do?", NotEnoughCells);
	Dialog.show();
	LessWellsorMoreDilute=Dialog.getChoice();
}

if (LessWellsorMoreDilute==NotEnoughCells[0]){
	Dialog.create("Decrease the number of wells");
	Dialog.addMessage("Remember, you only have enough cells for "+MaxWellsExcess+" wells if you plate cells at a concentration of "+C2+" cells per mL.");
	Dialog.addNumber("How many wells will you be adding cells to?",MaxWellsExcess,0,10,"wells");
	Dialog.show();
	NUMofWells=Dialog.getNumber();
	NUMofWellExcess=NUMofWells+1;
	V2=NUMofWellExcess*VperWell;
}
else if (LessWellsorMoreDilute==NotEnoughCells[1]){
	MaxConc=TotalCellNumber/V2;
	MaxConc=floor(MaxConc);
	Dialog.create("Decrease the concentration of cells per well");
	Dialog.addMessage("You have enough cells for "+ NUMofWells+" wells if you dilute your cells to "+MaxConc+" cells per mL");
	Dialog.addChoice("Would you like to plate "+NUMofWells+" wells at a concentration of "+MaxConc+" cells/mL?", YesNo);
	Dialog.show();
	PlanC=Dialog.getChoice();
	if (PlanC==YesNo[0]){
	C2=MaxConc;
	NUMofWellExcess=NUMofWells+1;
	V2=NUMofWellExcess*VperWell;
	V1=V2-PelletResuspension;
	
}
else if (PlanC==YesNo[1]){
	Dialog.create("Sorry!");
	Dialog.addMessage("You simply don't have enough cells! You need to decide whether you want to reduce your number of wells or decrease your cell concentration.");
	Dialog.show();
}
}

	Dialog.create("Cell Dilution Wizard Step 2");
		if (MediaToAdd<0){
				VperWell=VperWell*1000;
			Dialog.addMessage("Spin down your cells into a pellet.");
			Dialog.addMessage("Then, resuspend the pellet in "+V2+" mL of media.");
		}
		else{
		Dialog.addMessage("Add "+MediaToAdd+" mL of media to a conical tube.");
		Dialog.addMessage("Add "+V1+" microliters (NOT mL!) of cells to the media.");
		}
		Dialog.addMessage("You now have "+V2+" mL of "+CellType+" at a dilution of "+C2+" cells per mL.");
		Dialog.addMessage("Add "+VperWell+" microliters of your new cell suspension to "+NUMofWells+" wells.");
		Dialog.addMessage("Now go write that in your notebook!");
		Dialog.show();

print("You now have "+V2+" mL of "+CellType+", at " +C2+" cells/mL.");
print("Add "+VperWell+" μL of your cells to "+NUMofWells+" wells.");
dump();
}


/////////////////////////////


function DNAGel(){
	dir=getDirectory("Choose the folder with your new DNA gel images");
	list=getFileList(dir);
	for (i=0; i<list.length; i++){
path=dir+list[i];
open(path);
Title=getTitle();
cropAndScaleDNAGel();
}

function cropAndScaleDNAGel(){
Info=getMetadata("Info");
//print(Info);
InfoArray=split(Info,"\n");
//Array.print(InfoArray);
BitsPerPixel=InfoArray[0];
CCDTemp=InfoArray[12];
CaptureTimeDate=InfoArray[13];
ExposureTime=InfoArray[15];
FOV=InfoArray[17];
FilterDescription=InfoArray[19];
HorResolution=InfoArray[21];
Source=InfoArray[27];
VerResolution=InfoArray[33];


setMinAndMax(0, 200);
Dialog.create("Adjust?");
 Dialog.addMessage("Would you like to adjust this image before creating flattened scaled image?");
 //Dialog.setInsets(20, 10, 0);
Dialog.addCheckbox("The blot is upside down and needs to be flipped vertically ", false);
Dialog.addCheckbox("The blot is backwards and needs to be flipped horizontally ", false);
Dialog.addNumber("The blot needs to be rotated by ", 0,0,6,"degrees clockwise");
Dialog.show();
VFlip=Dialog.getCheckbox();
HFlip=Dialog.getCheckbox();
ROTATION=Dialog.getNumber();
setBatchMode(true);

if (ROTATION!=0){
run("Rotate... ", "angle="+ROTATION+" grid=1 interpolation=Bilinear enlarge");
}
if (VFlip==1){
run("Flip Vertically");
}

if (HFlip==1){
run("Flip Horizontally");
}
setBatchMode("exit and display");
makeRectangle(100, 100, 800, 800);
	waitForUser("Adjust the rectangle until it spans the gel. Then, press OK.");
	setBatchMode(true);	
	run("Crop");
getDimensions(width, height, channels, slices, frames);
h=height*1.4;
WordHeight=height+100;

newImage(Title+"-1", "32-bit black", width, h, 1);
selectImage(Title);
run("Select All");
run("Copy");
run("Paste");
selectImage(Title+"-1");
makeRectangle(0, 0, width, height);
run("Paste");
selectImage(Title);
close();
selectImage(Title+"-1");
run("Select None");
setMinAndMax(0, 1000);
run("Brightness/Contrast...");
setBatchMode("exit and display");
waitForUser("Adjust brightness and contrast to your liking, then press OK.");
setBatchMode(true);
FontSize=height/30;
smallFont=height/35;

setFont("Helvetica", FontSize, "bold antialiased");
setColor("white");
Overlay.drawString(CaptureTimeDate, 100, WordHeight);
Overlay.show();
FONTHEIGHT=getValue("font.height");
FONTHEIGHT=FONTHEIGHT*1.2;
WordHeight2=WordHeight+FONTHEIGHT;
Overlay.drawString("Title: "+Title, 100, WordHeight2);
Overlay.show();
WordHeight3=WordHeight2+FONTHEIGHT;
setFont("Helvetica", smallFont, "antialiased");
SourceLength=lengthOf(Source);
if (SourceLength>80){
	Source1=substring(Source, 0, 80);
	Source2=substring(Source, 81, SourceLength);
	Overlay.drawString(Source1, 100, WordHeight3);
	Overlay.show();
	WordHeight4=WordHeight3+FONTHEIGHT;
	Overlay.drawString(Source2, 100, WordHeight4);
	Overlay.show();
}
else{
Overlay.drawString(Source, 100, WordHeight3);
Overlay.show();
}
Title=getTitle();
saveAs("Tiff", DNADir+Title+" -with label.tif");
Title=getTitle();
run("Flatten");
close(Title);
saveAs("PNG", DNADir+Title+" -for presentations.png");
close();


dump();

}
}








////////////////////////////

function WesternBlot(){
	dir=getDirectory("Choose the folder with your new western blot images");
	list=getFileList(dir);
	for (i=0; i<list.length; i++){
path=dir+list[i];
open(path);
Title=getTitle();
cropAndScaleWB();
}

function cropAndScaleWB(){
Info=getMetadata("Info");
//print(Info);
InfoArray=split(Info,"\n");
//Array.print(InfoArray);
BitsPerPixel=InfoArray[0];
CCDTemp=InfoArray[12];
CaptureTimeDate=InfoArray[13];
ExposureTime=InfoArray[15];
FOV=InfoArray[17];
FilterDescription=InfoArray[19];
HorResolution=InfoArray[21];
Source=InfoArray[27];
VerResolution=InfoArray[33];


setMinAndMax(0, 200);
Dialog.create("Adjust?");
 Dialog.addMessage("Would you like to adjust this image before creating flattened scaled image?");
 //Dialog.setInsets(20, 10, 0);
Dialog.addCheckbox("The blot is upside down and needs to be flipped vertically ", false);
Dialog.addCheckbox("The blot is backwards and needs to be flipped horizontally ", false);
Dialog.addNumber("The blot needs to be rotated by ", 0,0,6,"degrees clockwise");
Dialog.show();
VFlip=Dialog.getCheckbox();
HFlip=Dialog.getCheckbox();
ROTATION=Dialog.getNumber();
setBatchMode(true);

if (ROTATION!=0){
run("Rotate... ", "angle="+ROTATION+" grid=1 interpolation=Bilinear enlarge");
}
if (VFlip==1){
run("Flip Vertically");
}

if (HFlip==1){
run("Flip Horizontally");
}
setBatchMode("exit and display");
makeRectangle(100, 100, 800, 800);
	waitForUser("Adjust the rectangle until it spans the gel. Then, press OK.");
	setBatchMode(true);	
	run("Crop");
getDimensions(width, height, channels, slices, frames);
h=height*1.4;
WordHeight=height+100;

newImage(Title+"-1", "32-bit black", width, h, 1);
selectImage(Title);
run("Select All");
run("Copy");
run("Paste");
selectImage(Title+"-1");
makeRectangle(0, 0, width, height);
run("Paste");
selectImage(Title);
close();
selectImage(Title+"-1");
run("Select None");
setMinAndMax(0, 1000);
run("Brightness/Contrast...");
setBatchMode("exit and display");
waitForUser("Adjust brightness and contrast to your liking, then press OK.");
setBatchMode(true);
FontSize=height/30;
smallFont=height/35;

setFont("Helvetica", FontSize, "bold antialiased");
setColor("white");
Overlay.drawString(CaptureTimeDate, 100, WordHeight);
Overlay.show();
FONTHEIGHT=getValue("font.height");
FONTHEIGHT=FONTHEIGHT*1.2;
WordHeight2=WordHeight+FONTHEIGHT;
Overlay.drawString("Title: "+Title, 100, WordHeight2);
Overlay.show();
WordHeight3=WordHeight2+FONTHEIGHT;
setFont("Helvetica", smallFont, "antialiased");
SourceLength=lengthOf(Source);
if (SourceLength>80){
	Source1=substring(Source, 0, 80);
	Source2=substring(Source, 81, SourceLength);
	Overlay.drawString(Source1, 100, WordHeight3);
	Overlay.show();
	WordHeight4=WordHeight3+FONTHEIGHT;
	Overlay.drawString(Source2, 100, WordHeight4);
	Overlay.show();
}
else{
Overlay.drawString(Source, 100, WordHeight3);
Overlay.show();
}
Title=getTitle();
saveAs("Tiff", WBDir+Title+" -with label.tif");
Title=getTitle();
run("Flatten");
close(Title);
saveAs("PNG", WBDir+Title+" -for presentations.png");
close();
dump();

}
}






////////////////////////////////////////////


function Evos(){
	EVOSChoices=newArray("I just want to convert my monochrome images into composite images ", "I want to make a stitched image from an EVOS Scan", "I want to go through all of my images and see if I need to rotate them", "I want to make sure that the images in my folder all have the same brightness and contrast", "I want to convert composite images into panels of colored monochrome images", "I want to make a montage of images with different dimensions", "I want to view all images in a folder in a single montage", "I want to make PNG images that are scaled and/or have an inset");
Dialog.create("How are you using the EVOS?");
Dialog.addMessage("What would you like to do?");
Dialog.addCheckbox("I just want to convert my monochrome images into composite images ", false);
Dialog.addCheckbox("I want to convert composite images into panels of colored monochrome images", false);
Dialog.addCheckbox("I want to make sure that the images in my folder all have the same brightness and contrast", false);
Dialog.addCheckbox("I want to make a montage of stitched images with different dimensions", false);
Dialog.addCheckbox("I want to go through all of my images and see if I need to rotate them", false);
Dialog.addCheckbox("I want to view all images in a folder in a single montage", false);
Dialog.addCheckbox("I want to make PNG images that are scaled and/or have an inset", false);
Dialog.addCheckbox("I want to make a stitched image from an EVOS Scan", false);
Dialog.addCheckbox("I want to quantify IF intensity of a folder of images", false);

Dialog.show();
MakeComposite=Dialog.getCheckbox();
MakeMonochromeMontage=Dialog.getCheckbox();
AdjustBandC=Dialog.getCheckbox();
AdjustMontageDimensions=Dialog.getCheckbox();
AdjustRotation=Dialog.getCheckbox();
ViewAsMontage=Dialog.getCheckbox();
ScaledPNG=Dialog.getCheckbox();
EVOSSTITCH=Dialog.getCheckbox();
QuantifyIFExpressionBox=Dialog.getCheckbox();
setBatchMode(true);


if (MakeComposite==1){
	MakeCompositeFunction();
}

if (AdjustRotation==1){
	AdjustRotationFunction();
}

if (AdjustBandC==1){
	AdjustBandCFunction();
}

if (ViewAsMontage==1){
	ViewAsMontagefunction();
}


if (MakeMonochromeMontage==1){
	MakeMonochromeMontageFunction();
}

if (EVOSSTITCH==1){
	EvosStitch();
}

if (AdjustMontageDimensions==1){
	MontageDimensionsFunction();
}


if (ScaledPNG==1){
ScaledPNGwithInsetOption();
}

if (QuantifyIFExpressionBox==1){
QuantifyIFExpression();
}

}



/////////////

function MakeCompositeFunction(){
areaNumber=0;
dir = getDirectory("Click on the folder with your Evos images");
DirParent=File.getParent(dir);
ParentArray=split(DirParent, "/");
ParentArraylength=ParentArray.length;
ParentArraylength=ParentArraylength-1;
Slidenumber=ParentArray[ParentArraylength];
list=getFileList(dir);
list=Array.sort(list);
MakeCompositeFunction2();




function MakeCompositeFunction2(){
Dialog.create("SubtractBackground?");
Dialog.addChoice("Do you want the background subtracted?", YesNo,YesNo[1]);
Dialog.addNumber("What would you like the rolling ball radius to be?", 10);
Dialog.show();




var SubtractBackgroundQ=Dialog.getChoice();

var RollingBallRadius=Dialog.getNumber();


DeleteRGBimages50 ();
countcolors50 ();
Dialog.create("Done!");
Dialog.show();
}
}



function DeleteRGBimages50 ()
		{
 list = getFileList(dir);
 for (k=0; k<list.length; k++)
 	{
 	path=dir+list[k];
 	if (!endsWith(path, ".png")) 
 		{	
	if (!endsWith(path, "Red.tif")) 
			{

	if (!endsWith(path, "DAPI.tif")) 
				{

	if (!endsWith(path, "GFP.tif")) 
					{

	if (!endsWith(path, "CY5.tif")) 
							{
	
		File.delete(path);
							}
					}
				}
			}
		}
		}
		}

function countcolors50 () {
	list=getFileList(dir);
	list=Array.sort(list);
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
	makeComposite50();
 }



function makeComposite50 () {
//NofChannels=list.length/D;
 Colors=NofChannels;
 print("Colors: "+Colors);
 //	list=getFileList(dir);
//	list=Array.sort(list);
for (j=0; j<list.length; j++) {
	if (!startsWith(list[j], "Area")){
		open(dir+ list[j]);
		title1=getTitle();
		print(title1);
		nname=File.nameWithoutExtension();
		GETIMAGEINFO1(dir);
		NewMETAINFO=getMetadata("Info");
		NewMETALABEL=getMetadata("Label");
		x=split(title1, "_");
		xlength=x.length-1;
		title2=x[0]+"_";
		for (xx=1; xx<xlength; xx++){
		title2=title2+ x[xx]+"_";
		}
		if (Colors>1) {
		open(dir+ list[j+1]);
		GETIMAGEINFO1(dir);
		}
		 if (Colors>2) {
		open(dir+ list[j+2]);
		GETIMAGEINFO1(dir);
		}
		 if (Colors>3) {
		open(dir+ list[j+3]);
		GETIMAGEINFO1(dir);
		}
		
		run("Images to Stack", "name=["+title2+"] title=["+title2+"] use");
		run("Make Composite", "display=Composite");
		setMetadata("Info", NewMETAINFO);
		setMetadata("Label", NewMETALABEL);
			if (SubtractBackgroundQ==YesNo[0]){
		run("Subtract Background...", "rolling="+RollingBallRadius+" stack");
		}
		saveAs("Tiff", dir+title2+"Composite.tif");
		run("Close");
		File.delete(dir+title2+"TxRed.tif");
		File.delete(dir+title2+"DAPI.tif");
		File.delete(dir+title2+"CY5.tif");
		File.delete(dir+title2+"GFP.tif");
		j=j+Colors-1;
}
else if (startsWith(list[j], "Area")){
		SECONDPATH=list[j];
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

function GETIMAGEINFO1(dir){
	Name=getTitle();
string=getImageInfo();
StringArray=split(string, "\r");
ImageDescription=StringArray[0];
ImageDescriptionArray=split(ImageDescription, " ");

nit=ImageDescriptionArray.length;
for (i=0; i<nit; i++){
	FindGain=indexOf(ImageDescriptionArray[i], "GainDb");
	if (FindGain!=-1){
Gain=ImageDescriptionArray[i];
//print("Gain: "+ Gain);
GainArray=split(Gain, "=");
Gain=GainArray[1];
GainLength=lengthOf(Gain);
GainLength=GainLength-1;
Gain=substring(Gain, 1,GainLength);
Gain=parseFloat(Gain);
Gain=Gain*10;
Gain=round(Gain);
Gain=Gain/10;
//print("Final Gain value: "+Gain);
	}
FindExposureTime=indexOf(ImageDescriptionArray[i], "Exposure");
if (FindExposureTime!=-1){
ExpTime=ImageDescriptionArray[i];
//print("ExpTime: "+ ExpTime);
ExpTimeArray=split(ExpTime, "=");
ExpTime=ExpTimeArray[1];
ExpTimeLength=lengthOf(ExpTime);
ExpTimeLength=ExpTimeLength-1;
ExpTime=substring(ExpTime, 1,ExpTimeLength);
ExpTime=parseFloat(ExpTime);
ExpTime=ExpTime*10;
ExpTime=round(ExpTime);
ExpTime=ExpTime/10;
//print("Final ExpTime value: "+ExpTime);
}
FindLight=indexOf(ImageDescriptionArray[i], "LightingSetting");
	if (FindLight!=-1){
Light=ImageDescriptionArray[i];
//print("Light: "+ Light);
LightArray=split(Light, "=");
Light=LightArray[1];
LightLength=lengthOf(Light);
LightLength=LightLength-1;
Light=substring(Light, 1,LightLength);
Light=parseFloat(Light);
Light=Light*10;
Light=round(Light);
Light=Light/10;
//print("Final Light value: "+Light);
}

FindChannel=indexOf(ImageDescriptionArray[i], "FilterCube");
	if (FindChannel!=-1){
Cube=ImageDescriptionArray[i];
//print("Light: "+ Light);
CubeArray=split(Cube, "=");
Cube=CubeArray[1];
CubeLength=lengthOf(Cube);
CubeLength=CubeLength-1;
Cube=substring(Cube, 1,CubeLength);
}
}
setMetadata("Info", "Title: "+Name+"  Exp:"+ExpTime+"  Gain:"+Gain+"  Light:"+Light+ " Filter Cube: "+Cube);
setMetadata("Label", nname+" E: "+ExpTime+", G:"+Gain+", L:"+Light+", "+"C: "+Cube);
}



////////

function MakeMonochromeMontageFunction(){
dir = getDirectory("Click on the folder with your Evos images");
dir2=File.getParent(dir);
setBatchMode(true);
count = 0;
countFiles10(dir);
n = 0;
processFiles10(dir);
}
function countFiles10(dir) {
list = getFileList(dir);
list=Array.sort(list);
for (i=0; i<list.length; i++) {
if (endsWith(list[i], "/"))
countFiles10(""+dir+list[i]);
else
count++;
}
}

function processFiles10(dir) {
list = getFileList(dir);
list=Array.sort(list);
for (i=0; i<list.length; i++) {
if (endsWith(list[i], "/"))
processFiles10(""+dir+list[i]);
else {
showProgress(n++, count);
path = dir+list[i];
print(path);
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
pathFOLDER=dir+name+"monochromes/";
File.makeDirectory(pathFOLDER);
Stack.setDisplayMode("composite");
getDimensions(width, height, channels, slices, frames);
NoOfChannels=channels;
NoOfChannels2=NoOfChannels+1;
Title=getTitle;
run("Duplicate...", "title=[STACK] duplicate channels=1-"+NoOfChannels);
run("Flatten");
saveAs("PNG", pathFOLDER+name+" "+NoOfChannels2+".png");
close(name+" "+NoOfChannels2+".png");
selectWindow(Title);
run("Split Channels");
MONO1=0;
MONO2=0;
MONO3=0;
MONO4=0;
if (NoOfChannels==2){
MONO1="C1-"+Title;
MONO2="C2-"+Title;
}
else if (NoOfChannels==3){
MONO1="C1-"+Title;
MONO2="C2-"+Title;
MONO3="C3-"+Title;
}
else if (NoOfChannels==4){
MONO1="C1-"+Title;
MONO2="C2-"+Title;
MONO3="C3-"+Title;
MONO3="C4-"+Title;	
}


M1=isOpen(MONO1);
M2=isOpen(MONO2);
M3=isOpen(MONO3);
M4=isOpen(MONO4);

if (M1==1){
selectWindow(MONO1);
run("RGB Color");
saveAs("PNG", pathFOLDER+name+" 1.png");
close(name+" 1.png");
}

if (M2==1){
selectWindow(MONO2);
run("RGB Color");
saveAs("PNG", pathFOLDER+name+" 2.png");
close(name+" 2.png");
}

if (M3==1){
selectWindow(MONO3);
run("RGB Color");
saveAs("PNG", pathFOLDER+name+" 3.png");
close(name+" 3.png");
}
if (M4==1){
selectWindow(MONO4);
run("RGB Color");
saveAs("PNG", pathFOLDER+name+" 4.png");
close(name+" 4.png");
}

run("Image Sequence...", "open=["+pathFOLDER+"] sort");
	title=getTitle();
	run("Make Montage...", "columns="+NoOfChannels2+" rows=1 scale=1");
	selectWindow("Montage");
	saveAs("PNG", dir+"Monochrome Montage "+name+".png");
	close("Monochrome Montage "+name+".png");
close(title);
File.delete(pathFOLDER+name+" 1.png");
File.delete(pathFOLDER+name+" 2.png");
File.delete(pathFOLDER+name+" 3.png");
File.delete(pathFOLDER+name+" 4.png");
File.delete(pathFOLDER+name+" 5.png");
File.delete(pathFOLDER);

}

/////////////////

function AdjustBandCFunction(){
	dir=getDirectory("Choose the area with the composite images");
previousFolder=File.getParent(dir);
previousFolder=previousFolder+"/";
//print(previousFolder);
list = getFileList(dir);
listB=Array.sort(list);
setBatchMode(true);
open(dir+list[0]);
getDimensions(width, height, channels, slices, frames);
close(list[0]);
colors=newArray("Magenta", "Blue", "Green", "Red", "Cyan", "Yellow");
Dialog.create("Choose brightness and contrast for folder to be processed");
		Dialog.addNumber("Channel 1 Minimum:", 200);
		Dialog.addNumber("Channel 1 Maximum:", 1500);
		Dialog.addChoice("What color would you like your Channel 1 to be?", colors, colors[0]);
		if (channels>1){
		Dialog.addNumber("Channel 2 Minimum:", 100);
		Dialog.addNumber("Channel 2 Maximum:", 2000);
		Dialog.addChoice("What color would you like your Channel 2 to be?", colors, colors[1]);
		}
		if (channels>2){		
		Dialog.addNumber("Channel 3 Minimum:", 300);
		Dialog.addNumber("Channel 3 Maximum:", 1500);
		Dialog.addChoice("What color would you like your Channel 3 to be?", colors, colors[2]);
		}
		if (channels>3){	
		Dialog.addNumber("Channel 4 Minimum:", 20);
		Dialog.addNumber("Channel 4 Maximum:", 500);
		Dialog.addChoice("What color would you like your Channel 4 to be?", colors, colors[3]);
		}
		Dialog.show();
CY5Min=Dialog.getNumber();
CY5Max=Dialog.getNumber();
CY5COLOR=Dialog.getChoice();
		if (channels>1){
DAPIMin=Dialog.getNumber();
DAPIMax=Dialog.getNumber();	
DAPICOLOR=Dialog.getChoice();
		}
			if (channels>2){
GFPMin=Dialog.getNumber();
GFPMax=Dialog.getNumber();
GFPCOLOR=Dialog.getChoice();
			}
				if (channels>3){
RedMin=Dialog.getNumber();
RedMax=Dialog.getNumber();
TXREDCOLOR=Dialog.getChoice();
				}
setBatchMode(true);
L=listB.length;
for(i=0; i<L; i++){
path=dir+listB[i];
open(path);
fixthecolor();
run("Save");
close();
}


function fixthecolor(){
Stack.setDisplayMode("color");
Stack.setChannel(1);
run(CY5COLOR);
setMinAndMax(CY5Min, CY5Max);
			if (channels>1){
Stack.setChannel(2);
run(DAPICOLOR);
setMinAndMax(DAPIMin, DAPIMax);
			}
						if (channels>2){
Stack.setChannel(3);
run(GFPCOLOR);
setMinAndMax(GFPMin, GFPMax);
						}
									if (channels>3){
Stack.setChannel(4);
run(TXREDCOLOR);
setMinAndMax(RedMin, RedMax);
									}
Stack.setDisplayMode("composite");
}
}



function MontageDimensionsFunction(){
dir = getDirectory("Click on the folder with your Evos images");
ParentTitle=split(dir, "/");
ParentTitlelength=ParentTitle.length;
ParentTitlelength=ParentTitlelength-1;
ParentFolderName=ParentTitle[ParentTitlelength];
print("ParentFolderName = "+ParentFolderName);
list=getFileList(dir);
list=Array.sort(list);
open(dir+list[0]);
BITDEPTH=bitDepth();

if (BITDEPTH==24){
	for (i=0; i<list.length; i++){
	setBatchMode(true);
	path=list[i];
	open(dir+path);
	}
run("Images to Stack", "method=[Copy (center)] name=Stack title=[] use");
run("Make Montage...");
setBatchMode("exit and display");
rename(ParentFolderName);
}

else if (BITDEPTH==16){
	for (i=0; i<list.length; i++){
	setBatchMode(true);
	path=list[i];
	open(dir+path);
Title=getTitle();
run("Set Label...", "label=["+Title+"]");
}
run("Concatenate...", "all_open title=[Stack of composites]");
run("Make Montage...");
setBatchMode("exit and display");
rename(ParentFolderName);
}

}

////////////////

function AdjustRotationFunction(){
	dir = getDirectory("Click on the folder with your Evos images");
list=getFileList(dir);
list=Array.sort(list);
q=list.length;
for (i=0; i<q; i++){
	path=list[i];
	open(dir+path);
	Name=File.nameWithoutExtension();
	processfilesR();
}


function processfilesR(){
Title=getTitle();
setBatchMode("exit and display");
Dialog.create("Adjust image?");
Dialog.addMessage("Is this image acceptable?");
Dialog.addNumber("No; the image needs to be rotated by this many degrees: ", 0);
Dialog.show();
ROTATION=Dialog.getNumber();
setBatchMode(true);

if (ROTATION!=0){
Stack.setDisplayMode("composite");	
run("Rotate... ", "angle="+ROTATION+" grid=1 interpolation=Bilinear enlarge");
setBatchMode("exit and display");
	waitForUser("Adjust the rectangle until it surrounds your area of interest. Then, press OK.");
	setBatchMode(true);	
		run("Duplicate...", "title=["+Title+"-cropped.tif] duplicate");
		close(Title);
		selectWindow(Title+"-cropped.tif");
		rename(Title);
}
saveAs("Tif", dir+path);
close();
}
}

/////////////////////

function ViewAsMontagefunction(){
dir = getDirectory("Click on the folder with your Evos images");
ParentTitle=split(dir, "/");
ParentTitlelength=ParentTitle.length;
ParentTitlelength=ParentTitlelength-1;
ParentFolderName=ParentTitle[ParentTitlelength];
print("ParentFolderName = "+ParentFolderName);

list=getFileList(dir);
list=Array.sort(list);

MakeHyperstack (dir);
Dialog.create("Done!");
Dialog.show();

function MakeHyperstack (dir)
{
	setBatchMode(true);
path=list[0];
ListLength=list.length;
run("Image Sequence...", "open=["+dir+path+"] sort");
Title=getTitle();
getDimensions(width, height, channels, slices, frames);
channels=slices/ListLength;
slices=slices/channels;

run("Stack to Hyperstack...", "order=xyczt(default) channels="+channels+" slices="+slices+" frames=1 display=Color");
//close(Title);
run("Make Montage...");
setBatchMode("exit and display");
rename(ParentFolderName);

}
}




function ScaledPNGwithInsetOption() {
Dialog.create("Do you want to scale your images?");
ScaleFactorArray=newArray("1: Don't scale", 0.1, 0.2,0.3, 0.4,0.5, 0.6,0.7, 0.8, 0.9);
YesNo=newArray("Yes","No");
Dialog.addChoice("How much would you like to scale your image?", ScaleFactorArray);
Dialog.addChoice("Would you like to make an inset?", YesNo);
Dialog.show();
ScaleFactor=Dialog.getChoice();
INSET=Dialog.getChoice();
dir = getDirectory("Click on the folder with your Evos images");
dir2 = File.getParent(dir);
dir2=dir2+"/";
list=getFileList(dir);
list=Array.sort(list);
q=list.length;
PNGImages=dir+"PNG images/";
PNGImagesQ=File.exists(PNGImages);
if (PNGImagesQ==0){
	File.makeDirectory(PNGImages);
}
for (i=0; i<q; i++){
	setBatchMode(true);
	path=list[i];
	open(dir+path);
	Title=getTitle();
	Name=File.nameWithoutExtension();
	if (INSET==YesNo[0]){
		ZoomedInset ();
	}
		ScaleAndFlatten();
			if (INSET==YesNo[0]){
		close();
		close();
	}

}
}



function ZoomedInset () {
run("Flatten");
rename(Title+" with inset zoom");
setBatchMode("exit and display");
makeRectangle(417, 793, 896, 912);
waitForUser("Adjust the rectangle until it surrounds your area of interest. Then, press OK.");
setBatchMode(true);
zoomIT();	
close(Title+" with inset zoom");
Title2=getTitle();
run("Flatten");
	
function zoomIT() {
var zoomValue=4, suf="-zoom", red=0, green=0, blue=0, surOri=12, surZoom=12,click=1;
var showDestination=1, showInitialSelection=1, FSlice=1, TSlice=1;
	if (selectionType() != 0) exit ("This tool requires a rectangular selection");
	getDimensions(width, height, channels, slices, frames);
	getSelectionBounds(x, y, widthSel, heightSel);	
	movieID = getImageID(); movieName = getTitle();
	getCurentColors (); currentSlice=getSliceNumber(); FSlice=currentSlice; //TSlice=slices;
	run("Add Selection...", "stroke=white width=12 fill=none new");
	run("Select None");
	ok=-1;  
	settings (ok,widthSel, width, heightSel, height, slices, currentSlice);
	x2=-1; y2=-1; z2=-1; flags2=-1; xzo=0; yzo=0; click=0;
	leftButton=16;
	setColor("white");
	xx = zoomValue * widthSel; yy= zoomValue * heightSel;
	Overlay.drawRect(xzo, yzo, xx, yy);
	while (click != 1) {      	
		getCursorLoc(xzo, yzo, z, flags);
		if (xzo!=x2 || yzo!=y2 || z!=z2 || flags!=flags2) {
			Overlay.removeSelection(1);
			if (flags&leftButton!=0) click = 1;
			setLineWidth(surZoom);
			Overlay.drawRect(xzo, yzo, xx, yy);
			Overlay.show;
		}
		x2=xzo; y2=yzo; z2=z; flags2=flags;
		wait(5);
	}
	sufix= ".";
	if (lastIndexOf(movieName, sufix) > 1) {
		workingmovie = substring (movieName,0,lastIndexOf(movieName, sufix));	
	} else {workingmovie= movieName;}	
	movieDir = getDirectory ("temp");
	ImaStack = movieDir+ workingmovie +"-zoom"+File.separator;
	File.makeDirectory(ImaStack);
	if (!File.exists(ImaStack)) exit("Unable to create directory, something wrong in the ImageJ folder");	
	progress=0;setPasteMode("Copy");
	for (i=1;i<=slices;i++) {
		selectImage (movieID);
		setSlice (i);
		numero=pad(i);
		newName=numero + "-"+  workingmovie;
		tempSlice="temp_zoom";
		run("Select All");
		run("Duplicate...", "title=["+newName+"]");
		tempid=getImageID();
		if (i >= FSlice && i <= TSlice) {
			makeRectangle (x, y, widthSel, heightSel);
			run("Scale...", "x="+ zoomValue +" y= "+zoomValue+"  width="+xx+" height="+yy+" interpolation=Bicubic average create title="+tempSlice+"");
			run("Select All");
			run("Copy");
			close ();
			selectImage (tempid);
			makeRectangle(xzo, yzo,  xx,  yy);
			run("Paste");run("Select None");
			setColor(red, green, blue);
			if (showDestination ==1) {setLineWidth(surZoom);drawRect(xzo, yzo,  xx,  yy);}
			if (showInitialSelection ==1) {setLineWidth(surOri);drawRect(x, y, widthSel, heightSel);}
			setLineWidth(12);
		}
		save(ImaStack+ newName+".tiff");
		close ();
		progress=i/slices;
		showProgress(progress);	
	}
	selectImage (movieID); run("Select None");
	setBatchMode("exit and display");
	run("Image Sequence...", "open=["+ImaStack+"00000.tif] use");
// from http://rsb.info.nih.gov/ij/macros/Process_Virtual_Stack.txt  Author: Wayne Rasband
function pad(n) {
      str = toString(n);
      while (lengthOf(str)<5) str = "0" + str;
      return str;
}

function getCurentColors () {
	fg = getValue("foreground.color");
	red=( fg>>16)&0xff;
	green=( fg>>8)&0xff;
	blue= fg&0xff;
}

function settings (ok, widthSel, width, heightSel, height, slices, currentSlice) {
	while (ok != 1) {
		Dialog.create("Choose Settings");
		if (ok == 0) Dialog.addMessage ("! This zoom factor is not compatible with this selection");
		Dialog.addNumber("Zoom factor:", zoomValue, 1, 3, "");
		Dialog.addCheckbox("Outline source", showInitialSelection);
		Dialog.addNumber("Line width:", surOri, 0, 1, "");
		Dialog.addCheckbox("Outline destination", showDestination);
		Dialog.addNumber("Line width:", surZoom, 0, 1, "");
		if (slices > 1) {
		    Dialog.addMessage("");
			fromSlice=1; toSlice=slices;
			Dialog.addNumber("First slice:", fromSlice, 0, 4, "");
			Dialog.addNumber("Last slice:", toSlice, 0, 4, "");
		}		
		Dialog.show();
		zoomValue = Dialog.getNumber();
		showInitialSelection = Dialog.getCheckbox();
		surOri= Dialog.getNumber();
		showDestination = Dialog.getCheckbox();
		surZoom= Dialog.getNumber();
		if (slices > 1) {
			fromSlice= Dialog.getNumber(); FSlice=parseFloat (fromSlice);
			toSlice= Dialog.getNumber(); TSlice=parseFloat (toSlice);
		}
		if (zoomValue < 1) zoomValue =1;
		if ((widthSel * zoomValue) >= width || (heightSel * zoomValue) >= height) {ok=0;} else {ok=1;};
					}
																				}
//end of zoomIT below:
}


//end of ZoomedInset below:

}



function ScaleAndFlatten(){
Title=getTitle;
height=getHeight();
width=getWidth();
if (ScaleFactor!=ScaleFactorArray[0]){
w=width*ScaleFactor;
h=height*ScaleFactor;
run("Scale...", "x="+ScaleFactor+" y="+ScaleFactor+" z=1.0 width="+w+" height="+h+" depth=1 interpolation=Bilinear average create title=["+Name+" "+ScaleFactor+" Scaled.png]");
wait(100);
close(Title);
}
rename(Title);
H2=getHeight();
W2=getWidth();
h=H2*1.2;
newImage(Title+"-1", "RGB black", W2, h, 1);
selectImage(Title);
run("Select All");
run("Copy");
run("Paste");
selectImage(Title+"-1");
makeRectangle(0, 0, W2, H2);
run("Paste");
selectImage(Title);
close();
selectImage(Title+"-1");
run("Select None");




FontSize=H2/35;
setFont("Helvetica", FontSize, "bold antialiased");
setColor("white");
WordHeight=H2+100;
Overlay.drawString(Name, 100, WordHeight);
Overlay.show();
run("Flatten");

if (ScaleFactor!=ScaleFactorArray[0]){
saveAs("PNG", PNGImages+Name+" "+ScaleFactor+" Scaled.png");
close();
}
else{
	saveAs("PNG", PNGImages+Name+" unscaled.png");
close();
}
}



}





/////////////////////////////////////////

function EvosStitch(){
	n=0;

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
//	print(FIRSTPATH);
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
//Dialog.addChoice("Do you want the background subtracted?", items3);
Dialog.addNumber("How many areas are there?", NUMOFAREAS);
Dialog.show();
	//Universal Variables
var ROTATIONQ=Dialog.getChoice();
//var SubtractBackgroundQ=Dialog.getChoice();
var compType=USEROS;
var areaNumber=Dialog.getNumber();
var SKIPIT=0;

//processFiles(dir);
for (i=0; i<list.length; i++){
if (startsWith(list[i], "Area")){
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
var list=getFileList(dir);
var list=Array.sort(list);

setBatchMode(true);


MakeCompositeFunction2();
areaFolders();
getXandY();
Stitch();

beep();
Dialog.create("Done!");
Dialog.show();
}

function areaFolders() {
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
}


	//This function calculates the x and y variables for stitching the final image
	//using the dimensions of the included .PNG file
	//It renames the .png with the x_y dimensions -> the .png will be deleted later
function getXandY(){
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
function Stitch() {
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
		Renamescannedimages3();
    	StitchImages3();
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
   
	}
}	
}

	//This function renames the images in order to meet the needs of the subsequent 
	//stitching program. e.g. making the image numbers "01" instead of "1"
function Renamescannedimages3() {

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
function StitchImages3() {
dirParent = File.getParent(dir);
folderList = getFileList(dirParent);
title=path4;
XANDY=split(title, "_");
TITLE=XANDY[0];

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

	//print("path2?: "+path2);

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

Stack.setDisplayMode("composite");
path=TITLE+".tif";
saveAs("Tiff", saveDir+SCANNAME+path);
close();
}





function QuantifyIFExpression (){
var HOME=getDirectory("home");
run("Overlay Options...", "stroke=yellow width=5 fill=none set");

Channels=newArray("1","2","3","4");
AutoT=newArray("Default", "Huang", "Intermodes", "IsoData", "Li", "MaxEntropy", "Mean", "MinError(I)", "Minimum", "Moments", "Otsu", "Percentile", "RenyiEntropy", "Shanbhag", "Triangle", "Yen");




Dialog.create("Waldman Lab IF Quantification");
Dialog.addChoice("What channel do you need to quantify?", Channels);
Dialog.addChoice("What thresholding method do you want to use?", AutoT, AutoT[9]);
	Dialog.show();
ChannelOI=Dialog.getChoice();
ThresholdMethod=Dialog.getChoice();




setBatchMode(true);
dir=getDirectory("Choose your directory");
//dir=File.directory();
list=getFileList(dir);
for (i=0; i<list.length; i++){
//for (i=0; i<1; i++){
	RO=isOpen("Results");
if(RO==1){
selectWindow("Results");
run("Close");
}
//for (i=0; i<1; i++){	
path=dir+list[i];
open(path);
Title=getTitle();
Stack.setDisplayMode("Color");
Stack.setChannel(1);
run("Blue");
Stack.setChannel(2);
run("Red");
Stack.setChannel(ChannelOI);
run("Duplicate...", "title=[Binary] duplicate channels="+ChannelOI);
close(Title);
selectWindow("Binary");
run("Auto Threshold", "method="+ThresholdMethod+" ignore_black ignore_white white");
run("Smooth");
run("Smooth");
run("Despeckle");
//setOption("BlackBackground", true);

run("Make Binary");
close("ROI*");
setTool("wand");
setBatchMode("exit and display");
waitForUser("Click on a region to outline it, then press cmd+B. Do this for all regions of interest. Then, press OK.");
setTool("rectangle");
waitForUser("Now, make a box around a region with no real staining, to establish a background reading. Again, press Cmd+B, then press OK.");
	run("To ROI Manager");
	ROICOUNT=roiManager("count");
//print(ROICOUNT);
RO=isOpen("Results");
if(RO==1){
selectWindow("Results");
run("Close");
}
close("Binary");
open(path);
for (m=0; m<ROICOUNT; m++){
		setBatchMode(true);
run("Set Measurements...", "area mean integrated stack display redirect=None decimal=3");
	roiManager("Select", m);
	Stack.setDisplayMode("color");
Stack.setChannel(ChannelOI);
run("Measure");
}
RESULTS=newArray();
for (m=0; m<ROICOUNT; m++){
Area=getResult("Area", m);
//print(Area);
IntDen=getResult("IntDen", m);
//print(IntDen);
Mean=getResult("Mean", m);
//print(Mean);
RESULTS1=newArray(m, Area, IntDen, Mean);
RESULTS=Array.concat(RESULTS,RESULTS1);
}

roiManager("Show All with labels");
Stack.setDisplayMode("Composite");
//Stack.setActiveChannels("1011");
saveAs("Tif", path);
close(Title);
//saveAs("Tiff", HOME+"Dropbox (Waldman Lab)/"+Title+"-Drawn ROIs.tif");
open(path);
run("Overlay Options...", "stroke=white width=7 fill=none apply show");
run("Labels...", "color=yellow font=72 show draw bold");
run("Flatten");
ScaledPNGwithInsetAndStats();
selectWindow("Results");
run("Close");
roiManager("deselect");
roiManager("Delete");
}


function ScaledPNGwithInsetAndStats(){
getDimensions(width, height, channels, slices, frames);
SF=width/2000;
print("SF: "+SF);
w=width/SF;
print("w: "+w);
h=height/SF;
print("h: "+h);
SFdenom=1/SF;
print("SFdenom: "+SFdenom);

run("Scale...", "x="+SFdenom+" y="+SFdenom+" z=1.0 width="+w+" height="+h+" depth=1 interpolation=Bilinear average  title=[Scaled Title]");

NewXOrigin=(width-w)/2;
print("NewXOrigin:"+NewXOrigin);
NewYOrigin=(height-h)/2;
print("NewYOrigin:"+NewYOrigin);
NewWidth=2000;
print("NewWidth:"+NewWidth);
NewHeight=NewYOrigin+h;
NewHeight=NewHeight+NewYOrigin;
print("NewHeight:"+NewHeight);
Ylocation=h*1.05;
print("Ylocation:"+Ylocation);
makeRectangle(NewXOrigin, NewYOrigin, NewWidth, NewHeight);
run("Crop");
FontSize=NewWidth/50;
smallFont=NewWidth/60;

setFont("Helvetica", FontSize, "bold antialiased");
setColor("white");
Overlay.drawString("Title: "+Title, 104, Ylocation);
Overlay.show();
FONTHEIGHT=getValue("font.height");
setFont("Helvetica", smallFont, "antialiased");
Background=RESULTS.length-1;
Array.print(RESULTS);
BackgroundMFI=RESULTS[Background];
for (o=0; o<ROICOUNT; o++){
	IntDenValue=2;
	AreaValue=1;
	MeanValue=3;
	Multiple=o*4;
	IntDenNum=IntDenValue+Multiple;
	MeanNum=MeanValue+Multiple;
	AreaNum=AreaValue+Multiple;
	ROIIntDensity=RESULTS[IntDenNum];
	ROIArea=RESULTS[AreaNum];
	BxA=ROIArea*BackgroundMFI;
	CTCF=ROIIntDensity - BxA;
	n=o+1;
	N=ROICOUNT+o;
	setResult("CTCF", N, CTCF);
Label2=getResultLabel(o);
Area2=getResult("Area", o);
Mean2=getResult("Mean", o);
IntDen2=getResult("IntDen", o);
CH2=getResult("Ch", o);
	setResult("Label", N, Label2);
	setResult("Area", N, Area2);
		setResult("Mean", N, Mean2);
			setResult("IntDen", N, IntDen2);
			setResult("Ch", N, CH2);
	updateResults();
Overlay.drawString("CTFC, Area "+n+": "+CTCF, 104, Ylocation);
Overlay.show();
}
IJ.deleteRows(0, ROICOUNT);
saveAs("results", dir+Title+", IF Quantification Results.xls");
run("Flatten");
//dir2=HOME+"Dropbox (Waldman Lab)/";
saveAs("PNG", dir+Title+", GUCY2C quantification image with Stats.png");
close();
close();

}
}




//////////////////////////////////////////////////////////////

function LogEvents(){
     MonthNames = newArray("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
     DayNames = newArray("Sun", "Mon","Tue","Wed","Thu","Fri","Sat");
     getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
     TimeString ="Date: "+DayNames[dayOfWeek]+" ";
     TimeString2=DayNames[dayOfWeek]+" ";
     if (dayOfMonth<10) {TimeString = TimeString+"0";}
          if (dayOfMonth<10) {TimeString2 = TimeString2+"0";}
     TimeString = TimeString+dayOfMonth+"-"+MonthNames[month]+"-"+year+"\nTime: ";
     TimeString2=TimeString2+dayOfMonth+"-"+MonthNames[month]+"-"+year;
     if (hour<10) {TimeString = TimeString+"0";}
      if (hour<10) {TimeString2 = TimeString2+"0";}
     TimeString = TimeString+hour+":";
     TimeString2=TimeString2+hour+":";
     if (minute<10) {TimeString = TimeString+"0";}
          if (minute<10) {TimeString2 = TimeString2+"0";}
     TimeString = TimeString+minute+":";
         TimeString2=TimeString2+hour+":";
     if (second<10) {TimeString = TimeString+"0";}
          if (second<10) {TimeString2 = TimeString2+"0";}
     TimeString = TimeString+second;
     TimeString2 = TimeString2+second;
selectWindow("Log");
save(FIJILogFolder+TimeString2+".txt");
}

function getDateandTime (){

     MonthNames = newArray("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
     DayNames = newArray("Sun", "Mon","Tue","Wed","Thu","Fri","Sat");
     getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
     TimeString ="Date: "+DayNames[dayOfWeek]+" ";
     TimeString2=DayNames[dayOfWeek]+" ";
     if (dayOfMonth<10) {TimeString = TimeString+"0";}
          if (dayOfMonth<10) {TimeString2 = TimeString2+"0";}
     TimeString = TimeString+dayOfMonth+"-"+MonthNames[month]+"-"+year+"\nTime: ";
     TimeString2=TimeString2+dayOfMonth+"-"+MonthNames[month]+"-"+year;
     if (hour<10) {TimeString = TimeString+"0";}
      if (hour<10) {TimeString2 = TimeString2+"0";}
     TimeString = TimeString+hour+"-";
     TimeString2=TimeString2+hour+"-";
     if (minute<10) {TimeString = TimeString+"0";}
          if (minute<10) {TimeString2 = TimeString2+"0";}
     TimeString = TimeString+minute+"-";
         TimeString2=TimeString2+hour+"-";
     if (second<10) {TimeString = TimeString+"0";}
          if (second<10) {TimeString2 = TimeString2+"0";}
     TimeString = TimeString+second;
     TimeString2 = TimeString2+second;

}





/////////////////////////////////////


function InProgress(){
Dialog.create("So Sorry!!");
	Dialog.addMessage("I'm sorry, this part of Mr. Robot is currently being repaired.");
	Dialog.addMessage("Please press cancel and tell Dante to hurry up and finish it!");
	Dialog.addMessage("-Dante");
	Dialog.show();
			}










}


	








//////////////////////////////////////////////



////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////








//////////////////////////////////////////////



////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////











//////////////////////////////////////////////



////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////







//////////////////////////////////////////////



////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////



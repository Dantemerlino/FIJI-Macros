




compensation();


function compensation (){
	setBatchMode(true);
RO=isOpen("Results");
channels=newArray("1","2","3","4");
Dialog.create("Choose your compensation conditions");
Dialog.addChoice("What channel will you be measuring?", channels, channels[0]);
Dialog.addChoice("What channel would like to subtract out?", channels, channels[3]);
		Dialog.show();
MeasuredChannel=Dialog.getChoice();
MeasuredChannel=parseInt(MeasuredChannel);
CompensatedChannel=Dialog.getChoice();
CompensatedChannel=parseInt(CompensatedChannel);
	if(RO==1){
selectWindow("Results");
run("Close");
}

Title=getTitle();
run("Set Measurements...", "mean stack display redirect=None decimal=0");

close("ROI*");



	run("To ROI Manager");
ROICOUNT=roiManager("count");
ROIArray = newArray(ROICOUNT);
  for (i=0; i<ROIArray.length; i++){
      ROIArray[i] = i;
      }
      for(i=0; i<ROIArray.length; i++){
      	roiManager("select", i);
      	roiManager("rename", i);
      								  }
//Array.print(ROIArray);
//for(i=1; i<5; i++){
//Stack.setChannel(i);
roiManager("select", ROIArray);
//roiManager("multi-measure append");
roiManager("multi-measure one");

      for(i=0; i<ROIArray.length; i++){
      	MeasuredChannelROW=MeasuredChannel-1;
      	CompensatedChannelROW=CompensatedChannel-1;
MeasuredChannelIntensity=getResult("Mean("+i+")", MeasuredChannelROW);
CompensatedChannelIntensity=getResult("Mean("+i+")", CompensatedChannelROW);
if(CompensatedChannelIntensity>700){
CorrectionFactor=pow(CompensatedChannelIntensity, 1.02);
CorrectionFactor=CorrectionFactor-CompensatedChannelIntensity;
Stack.setChannel(MeasuredChannel);
roiManager("select", i);
run("Subtract...", "value="+CorrectionFactor+" slice");
									}
else {
CorrectionFactor = 0;
	 }
CorrectedMean=MeasuredChannelIntensity-CorrectionFactor;
//print("MeasuredChannelIntensity: "+MeasuredChannelIntensity);
//print("CompensatedChannelIntensity: "+CompensatedChannelIntensity);
//print("CorrectionFactor: "+CorrectionFactor);
//print("CorrectedMean: "+CorrectedMean);
setResult("CorrectedMean", nResults, CorrectedMean);
//print("CorrectedMean: "+CorrectedMean); 	
      									}
updateResults();
}

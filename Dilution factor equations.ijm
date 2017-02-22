function DilutionFactors() {

End=sqrt(DilutionFactor);

		Factors=newArray(1,DilutionFactor);
		for (i=2; i<End; i++)
			{
				y=DilutionFactor/i;
				Inty=parseInt(y);
				if (Inty==y)
				{
					NewFactors=newArray(i,y);
					Factors=Array.concat(Factors,NewFactors);
				}
			}
			Factors=Array.sort(Factors);


ArrayLength=Factors.length;
ArrayLength=ArrayLength-1;
HalfLength=ArrayLength/2;
	a = newArray();
for (j=1; j<ArrayLength; j++){

DilutionFactor1= Factors[j];
DilutionFactor1=toString(DilutionFactor1);
k=j+1;
//DilutionFactor2=Factors[ArrayLength-k];
//DilutionFactor2=toString(DilutionFactor2);
NewDilutions= "Dilute your stock solution 1:"+DilutionFactor1;
	 a = Array.concat(a, NewDilutions);
//print("NewDilutions: "+NewDilutions);
}
Array.print(a);


	Dialog.create("Dilution Wizard");
	Dialog.addMessage("It looks like you need to dilute your stock solution 1:"+DilutionFactor);
Dialog.addMessage("That means you'll need to dilute your stock multiple times.");
Dialog.addMessage("But don't worry! I'll walk you through it.");
Dialog.addChoice("To begin, choose how you will dilute your stock solution: ", a);
Dialog.show();
	}
	D1=Dialog.getChoice();
	



/*
Dialog.create("Dilution Wizard");
Dialog.addMessage(V1+"="+V2+"*"+C2+"/"+C1);
Dialog.addMessage("Volume of "+SolutionName+" to add: "+V1+" "+V2Unit);
Dialog.addMessage("Volume of "+DiluentChoice+" to add: "+DiluenttoAdd+" "+V2Unit);
Dialog.show();	




/**
* Name: festival
* Based on the internal empty template. 
* Author: vasigarans and aykhazanchi
* Tags: 
*/


model festival

/* Insert your model definition here */

global {
	
	int noguests<-3;
	int notaverns<-2;
	
	init {
		create infocentre;
		create tavern with:(location:point (15,15));
		create tavern with:(location:point (60,60));
		create pub with:(location:point (90,90));
		create pub with:(location:point (30,30));
		create foodstall with:(location:point (75,75));	
		create foodstall with:(location:point (95,95));		
		create guests number:noguests
		{
		 isthirsty<-rnd(100);
		 ishungry<-rnd(100);
		 pointl<-nil;
		 foodbrain<-nil;
		 pubbrain<-nil;
		 tavernbrain<-nil;
		 atinfocentre<-false;
		}
		
		loop counter from:1 to:noguests{
			guests myagent<-guests[counter-1];
			myagent <- myagent.setName(counter);
		}
		
		}
	
	}
	
	


species guests skills: [moving]{
	
	int isthirsty;
	int ishungry;
	int r;
	list<int> foodbrain;
	list<int> pubbrain;
	list<int> tavernbrain;
	
	bool atinfocentre;
	point pointl;
	string guestName<-'undefined';
	point target<-{15,15};
	
	action setName(int num){
		guestName<-'person '+num;
	}
	
	aspect base{
	rgb agentcolor<- rgb('purple');
	
	if(isthirsty<=0 and ishungry<=0 ){
		agentcolor<-rgb('black');
		
	}
	else if(ishungry<=0 ){
		agentcolor<-rgb('blue');
	}
	
	else if(isthirsty<=0 ){
		agentcolor<-rgb('yellow');
	}
	
	
	draw circle(1) color: agentcolor;
	}
	
	
	
	
	reflex enjoyTheFestival when:(isthirsty!=0 and ishungry!=0)
	{

		do wander;
		isthirsty<-isthirsty-1;
		ishungry<-ishungry-1;
		if (isthirsty<=0 and ishungry<=0) {
			write guestName+ ' Im thirsty and hungry';
		} else if (isthirsty<=0) {
			write guestName+ ' Im thirsty';
		} else if (ishungry<=0) {
			write guestName+ ' Im hungry';
		}
	}
	
	reflex ifThirstyOrIfHungry when:((isthirsty<=0 or ishungry<=0) and atinfocentre=false) {
		
		do goto target:{50,50};

		if (location={50,50}){
			write guestName + 'i have reached the info centre';
			atinfocentre<-true;
			
		}	
		}
		
		
	reflex ifatinfocentretrue when: (atinfocentre=true and pointl=nil){
		r<-rnd(0,1);
		if(isthirsty<=0 and ishungry<=0){
			write guestName+ ' : im hungry and is thirsty';
			ask infocentre{
				myself.pointl<-tavern[myself.r].location;
			}
			write "Found a new tavern, going there now";
		}
		
		else if (isthirsty<=0){
			write guestName+ ' : im thirsty';
			ask infocentre{
				myself.pointl<-pub[myself.r].location;
			}
			write "Found a new pub, going there now";
		}
		
		else if (ishungry<=0){
			write guestName+ ' : im hungry';
			ask infocentre{
				myself.pointl<-foodstall[myself.r].location;
			}
			write "Found a new foodstall, going there now";
		}
	}
	
	reflex gototarget when: (pointl!=nil){
		do goto target:pointl;
		
		if(location=tavern[0].location or location=tavern[1].location){
			write guestName + ': I have reached tavern and drank and eaten. Time to party!';
			ask tavern{
				myself.ishungry<-100;
				myself.isthirsty<-100;
				myself.pointl<-nil;
				myself.atinfocentre<-false;
			}
		}
		
		if(location=foodstall[0].location or location=foodstall[1].location){
			write guestName + ': I have reached foodstall and eaten. Time to party!';
			ask foodstall{
				myself.ishungry<-100;
				myself.pointl<-nil;
				myself.atinfocentre<-false;
			}
		}
		if(location=pub[0].location or location=pub[1].location){
			write guestName + ': I have reached the pub and drank. Time to party!';
			ask pub{
				myself.isthirsty<-100;
				myself.pointl<-nil;
				myself.atinfocentre<-false;
			}
		}
		
	}
		
	
}
	




species infocentre{
	
	aspect base{
		draw square(10) at: {50,50} color: #orange;
	}
	
}


species tavern{
	
	aspect base{
		draw rectangle(7,4) at: location color: #yellow;
	}
}

species pub{
	
	aspect base{
		draw rectangle(5,3) at: location color: #pink;
	}
}

species foodstall{
	
	aspect base{
		draw rectangle(5,3) at: location color: #skyblue;
	}
}


experiment exp type: gui {

	
	// Define parameters here if necessary
	// parameter "My parameter" category: "My parameters" var: one_global_attribute;
	
	// Define attributes, actions, a init section and behaviors if necessary
	// init { }
	
	
output {
		display mydisplay{
			species guests aspect:base;
			species infocentre aspect:base;
			species tavern aspect:base;
			species pub aspect:base;
			species foodstall aspect:base;
		}
}
}

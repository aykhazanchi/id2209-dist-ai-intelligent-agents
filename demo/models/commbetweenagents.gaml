/**
* Name: commbetweenagents
* Based on the internal empty template. 
* Author: vasigarans
* Tags: 
*/


model commbetweenagents

/* Insert your model definition here */
global{
	int nopeople<-10;
	int nostore<-5;
	int distancethreshold<-10;
	
	init{
		create person number:nopeople;
		create store number:nostore;
		
		
		loop counter from:1 to:nopeople{
			person myagent<-person[counter-1];
			myagent <- myagent.setName(counter);
		}
		
		loop counter from:1 to:nostore{
			store myagent<-store[counter-1];
			myagent <- myagent.setName(counter);
		}
	}
}

species person skills: [moving]{
	
	bool ishungry<-false update:flip(0.5);
	bool isthirsty<-false update:flip(0.5);
	string personName<-'undefined';
	
	action setName(int num){
		personName <- 'person'+num;
	}
	
	aspect base{
		rgb agentcolor<- rgb('green');
		
		if(ishungry and isthirsty){
			agentcolor<-rgb('red');
		}
		
		else if(isthirsty){
			agentcolor<-rgb('orange');
		}
		
		else if(ishungry){
			agentcolor<-rgb('purple');
		}
		draw circle(1) color: agentcolor;
	}
	
		reflex move{
		do wander;
	}
	
	reflex reportApproachingtoStore when: !empty(store at_distance distancethreshold){
		ask store at_distance distancethreshold{
			write myself.personName +' is neaar '+ self.storename;
		}
	}
	
	
	
}


species store{
	
	bool hasfood <- flip(0.5);
	bool hasdrink <- flip(0.5);
	string storename <-'undefined';
	
	action setName(int num){
		storename <-'store'+num;
	}
	
	aspect base{
		rgb agentcolor <- rgb('black');
	
	if (hasfood and hasdrink){
		agentcolor <- rgb('darkgreen');
		
	}
	else if (hasfood){
		agentcolor <-rgb('skyblue');
	}
	
	else if(hasdrink){
		agentcolor <- rgb('lightskyblue');
	}
	
	draw square(2) color:agentcolor;
		
	}
	
	
	
}




experiment exp type: gui {

	
	// Define parameters here if necessary
	// parameter "My parameter" category: "My parameters" var: one_global_attribute;
	
	// Define attributes, actions, a init section and behaviors if necessary
	// init { }
	
	
	output {
		display mydisplay{
			species person aspect:base;
			species store aspect:base;
		}
	// Define inspectors, browsers and displays here
	
	// inspect one_or_several_agents;
	//
	// display "My display" { 
	//		species one_species;
	//		species another_species;
	// 		grid a_grid;
	// 		...
	// }

	}
}

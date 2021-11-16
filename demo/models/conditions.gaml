/**
* Name: conditions
* Based on the internal empty template. 
* Author: vasigarans
* Tags: 
*/


model conditions

/* Insert your model definition here */
//conditions like if else
global{
	int i<-3 max:6 update:i+1;
	int s<-1 update:s+1;
	bool flipb<-true update:flip(0.5);
reflex writedebug{
	write i;
	write s;
	write flipb;
}
	

reflex conditiondebug{
	
	if(mod(s,10)=0 and flipb){
		write "the number is divisible by 10 and the bool is true "+s;
	}
	else if(mod(s,10)=0){
		write"s is just divisible by 10"+s ;
	}
	else if(flipb){
		write "the bool is true";
	}
	else{
		write "niether divisble by 10 nor bool is true";
	}
}	
	
	
	
	
}


experiment myexp type: gui {

	
	// Define parameters here if necessary
	// parameter "My parameter" category: "My parameters" var: one_global_attribute;
	
	// Define attributes, actions, a init section and behaviors if necessary
	// init { }
	
	
	output {
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
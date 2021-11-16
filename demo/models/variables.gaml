/**
* Name: variables
* Based on the internal empty template. 
* Author: vasigarans
* Tags: 
*/


model variables

/* Insert your model definition here */

global{
	int i<- 3;
	float f<-5.5;
	string s<-'test';
	bool b<-true;
	
	reflex writedebug{
		write i;
		write f;
		write s;
		write b;
	}
}



experiment myexperiment type: gui {

	
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
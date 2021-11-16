/**
* Name: species
* Based on the internal empty template. 
* Author: vasigarans
* Tags: 
*/


model species1

/* Insert your model definition here */

global{
	int s<-0 update:s+1;
	
	reflex writeDebug{
		write 'global species s value'+s;
	}
	
	init{
		create NewAgent;
	}
	
	
}

species NewAgent{
	int s<-0 update:s+1;
	
	reflex writeDebug{
		write 'new agent s value '+s;
	}


}



experiment exp type: gui {

	
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
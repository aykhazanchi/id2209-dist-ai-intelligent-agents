/**
* Name: facet
* Based on the internal empty template. 
* Author: vasigarans
* Tags: 
*/


model facet

/* Insert your model definition here */
//key value pairs declare variables using facet like update facet
global{
	int i<-3 max:6 update:i+1;
	int s<-1 update:s+1;
	bool flipb<-true update:flip(0.5);

reflex writedebug{
	write i;
	write s;
	write flipb;
}

}






experiment myesperiment type: gui {

	
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
/**
* Name: loops
* Based on the internal empty template. 
* Author: vasigarans
* Tags: 
*/


model loops

/* Insert your model definition here */


global{
	
	int s<-5;
	
reflex times{
	loop times:s{
		write'times loop';
	}
	
}

reflex while{
	loop while:s>0{
		write'while';
		s<-s-1;
	}
}

reflex fromto{
	loop counter from: 1 to:s{
		write 'from to counter loop'+counter;
	}
}

reflex fromtostep{
	loop counter from: 1 to: s step: 2{
		write 'from to iwth step counter '+counter;
	}
}
reflex iterateoverloop{
	loop item over:[10,20,30]{
		write 'iterate over item '+item;
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
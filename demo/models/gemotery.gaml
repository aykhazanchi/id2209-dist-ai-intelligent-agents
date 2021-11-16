/**
* Name: gemotery
* Based on the internal empty template. 
* Author: vasigarans
* Tags: 
*/


model gemotery

/* Insert your model definition here */



experiment name type: gui {

	
	// Define parameters here if necessary
	// parameter "My parameter" category: "My parameters" var: one_global_attribute;
	
	// Define attributes, actions, a init section and behaviors if necessary
	// init { }
	
	
	output {
		display mydisplay{
			graphics 'layer1' position:{25,25} size:{20,10}{
				draw shape color: #gold;
			}
			
			graphics 'layer2'{
				draw square(20) at: {15,15} color: #orange;
			}
			
			graphics 'layer3' transparency:0.5{
				draw square(20) at: {55,45} color: #yellow;
			}
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
/**
* Name: actionandbehaviour
* Based on the internal empty template. 
* Author: vasigarans
* Tags: 
*/


model actionandbehaviour

/* Insert your model definition here */
global{
	int nopeople<-10;
	int nostore<-5;
	
	init{
		create person number:nopeople;
		create store number:nostore;
	}
}

species person{
	
	bool ishungry<-false update:flip(0.5);
	bool isthirsty<-false update:flip(0.5);
	
	
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
	
	reflex callactions{
		do dosomethingwithoutreturn(rnd(1,nopeople));
		int result<-dosomethingwithreturn(rnd(1,nopeople));
		write 'action2 finsh result:'+result;
		
		
	}
	
	action dosomethingwithoutreturn(int dummy){
		write "person action 1-dummy input is "+dummy;
	}
	
	int dosomethingwithreturn(int dummy){
		write 'person action 2 dummy input is'+dummy;
		return dummy;
	}
}


species store{
	
	bool hasfood <- flip(0.5);
	bool hasdrink <- flip(0.5);
	
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

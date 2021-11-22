/**
* Name: auction
* Based on the internal empty template. 
* Author: vasigarans
* Tags: 
*/


model auction

/* Insert your model definition here */

global{
	int noparticipants<-3;
	int noinitiator<-1;
	init{
	create Initiator with:(location:point(15,15));
	create Participant[] number: 3;
	}
	}
	


species Initiator skills: [fipa]{
	
	reflex send_request when :(time=1){
		Participant p <- Participant at 0 ;
//		list p_all <- list(Participant);
		write 'starting auction';
		int price<-20;
		do start_conversation (to::list(Participant),protocol::'fipa-request',performative::'request',contents::[price]);
		
	}
	
	reflex read_agree_message when: !(empty(agrees)){
		loop a over:agrees{
			write 'agree message: '+ string(a.contents);
		}
	}
	
	aspect base{
		draw square(7)  color: #orange;
	}
}

species Participant skills:[fipa]{
	aspect base{draw circle(1) color: #green;
	}
	reflex reply_messages when:(!empty(requests)){
		message requestFromInitiator<-(requests at 0);
		int auctionPrice;
		loop i over: requestFromInitiator.contents {
			auctionPrice <- (i as int);
		}
		write 'price is--- ' + auctionPrice;
		
		if(auctionPrice <= 20) {
			do agree with: (message: requestFromInitiator,contents: ['i will buy']);	
		}
		else {
			write "price is too high";
		}
		
	}


}



experiment name type: gui {

	
	// Define parameters here if necessary
	// parameter "My parameter" category: "My parameters" var: one_global_attribute;
	
	// Define attributes, actions, a init section and behaviors if necessary
	// init { }
	
	
	output {
		display mydisplay{
			species Initiator aspect:base;
			species Participant aspect:base;
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
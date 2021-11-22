/**
* Name: auction
* Based on the internal empty template. 
* Author: vasigarans and aykhazanchi
* Tags: 
*/


model auction

/* Insert your model definition here */

global{
	int numParticipants <- 3;
	int numInitiator <- 1;
	bool bidResults <- [];
	
	init{
		
		/********** Initiator code **********/
		create Initiator number: numInitiator with:(location:point(15,15));
		
		// Set random start price for auction
		Initiator[0].price <- rnd(0, 100);
		
		// Set minPrice to 20% of price
		Initiator[0].minPrice <- ((0.2*Initiator[0].price) as int);
		
		/********** Participant code **********/
		create Participants[] number: numParticipants;
		int i<-0;
		loop participant over: Participants {
			// Set participant name
			participant.name <- 'Participant ' + i;
			
			// Set maxPrice randomly for each participant at init
			participant.maxPrice <- rnd(0, 100);
			
			// Increase counter for next participant
			i<-i+1;			
		}
	}
}
	


species Initiator skills: [fipa]{
	
	int price;
	int minPrice;
	bool resultFromParticipant;
	
	reflex send_request when :(time=1){
		
		write 'price ---> ' + price;
		write 'minPrice ---> ' + minPrice;
		
		write 'starting auction';
		
		// Check price is above or equal to minPrice, start auction
		if (price >= minPrice) {
			do start_conversation (to::list(Participants),protocol::'fipa-request',performative::'request',contents::[price]);
		}
	}
	
	
	reflex read_agree_message when: (!(empty(agrees))) {
		loop a over:agrees {
			
			// Get result of bid out of contents
			loop r over: a.contents {
				resultFromParticipant <- (r as bool);
			}
			if (resultFromParticipant) {
				// Bid successful
				write 'Merch sold!: '+ string(a.contents) + ' bool value: ' + resultFromParticipant;	
			}
			else {
				// Bid out of range for participant
				write 'Bid failed for: '+ string(a.contents) + ' bool value: ' + resultFromParticipant;
			}
		}
	}
	
	reflex read_failure_message when: (!(empty(failures))) {
		loop f over:failures {
			write 'Failed: ' + string(f.contents);
		}
	}

 /*
	reflex read_message when: (!(empty(agrees)) or !(empty(failures))) {
		
		if (empty(agrees) and !empty(failures)) {
			// All have failed
			loop f over:failures {
				write 'Failed: ' + string(f.contents);
			}
			// Reduce price by 1, send auction again
			price <- price - 1;
			do start_conversation (to::list(Participants),protocol::'fipa-request',performative::'request',contents::[price]);
		}
		else if ((!empty(agrees)) and empty(failures)) {
			// All have agreed to bid
		 	loop a over:agrees {
				write 'Merch sold!: '+ string(a.contents);
			}
		}
		else if ((!empty(agrees)) and (!empty(failures))) {
			// Some have failed, some have agreed
			loop a over:agrees {
				write 'Merch sold!: '+ string(a.contents);
			}
			loop f over:failures {
				write 'Failed: ' + string(f.contents);
			}
		}
	}
  */
	aspect base{
		draw square(7)  color: #orange;
	}
}

species Participants skills:[fipa]{
	
	string name;
	int maxPrice;
	bool result;
	
	aspect base {
		draw circle(1) color: #green;
	}
		
	reflex reply_messages when:(!empty(requests)){
		message requestFromInitiator<-(requests at 0);
		int auctionPrice;
		write 'maxPrice for ' + name + ' set to --- ' + maxPrice;
		
		// Pull out price from contents list. Only works this way for some reason.
		loop i over: requestFromInitiator.contents {
			auctionPrice <- (i as int);
		}
		
		write 'Auction price currently at --- ' + auctionPrice;
		
		
		if(auctionPrice <= maxPrice) {
			result <- true;
			do agree with: (message: requestFromInitiator,contents: [name + ' will buy at ' + auctionPrice, result]);	
		}
		else {			
			result <- false;
			do agree with: (message: requestFromInitiator,contents: ['' + auctionPrice + ' is too high for ' + name, result]);	
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
			species Participants aspect:base;
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
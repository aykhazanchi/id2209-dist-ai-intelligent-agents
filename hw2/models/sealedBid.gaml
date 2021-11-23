/**
* Name: sealedBid
* Based on the internal empty template. 
* Author: vasigarans and aykhazanchi
* Tags: 
*/


model sealedBid

/* Insert your model definition here */

global{
	int numParticipants <- 10;
	int numAuctioneer <- 1;
	list<int> bids <- list_with(numParticipants, -1);
	
	init{
		
		/********** Initiator code **********/
		create Auctioneer number: numAuctioneer with:(location:point(15,15));
		
		/********** Participant code **********/
		create Participants[] number: numParticipants;
		int i<-0;
		loop participant over: Participants {
			// Set participant name
			participant.name <- 'Participant ' + i;
			
			// Set participant index
			participant.index <- i;

			// Increase counter for next participant
			i<-i+1;			
		}
	}
}

species Auctioneer skills: [fipa]{
	
	int max;
	int bidIndex <- -1;
	
	reflex send_request {
		
		write '';
		write '';
		write '';
		write 'New auction starting from send_request reflex';
		write 'Please submit your bids';
		write ' -------------------------------------------- ';
		do start_conversation (to::list(Participants),protocol::'fipa-contract-net',performative::'cfp',contents::['Auction has started, please send your bids...']);
	}
	
	
	reflex read_proposal_message when: (!(empty(proposes))) {
			
		loop a over:proposes {
			loop bid over: bids {
				if (bid > max) {
					max <- bid;
				}
			}
		}
		
		// Get index of max value which is also winning bid
		bidIndex <- bids index_of max;
	}

	// declare winner only when bidIndex value has been changed from default of -1
	reflex declare_winner when: (bidIndex != -1){
		
		write 'winning bid is ' + max;
		write 'winner is Participant ' + bidIndex;
	}
	
	aspect base{
		draw square(7)  color: #orange;
	}
}

species Participants skills:[fipa]{
	
	string name;
	// Set bid randomly for each participant
	int bid <- rnd(0, 100);
	int index;
			
	aspect base {
		draw circle(1) color: #green;
	}
		
	reflex reply_messages when:(!empty(cfps)){
		message proposalFromInitiator<-(cfps at 0);

		// Add participant bid to list at position [participant index]
		bids[index] <- bid;

		write 'Submitted bid for ' + name + ' set to --- ' + bid;
		write ' -------------------------------------------- ';	
		do propose with: (message: proposalFromInitiator,contents: [bids]);	
	}		
}



experiment name type: gui {

	
	// Define parameters here if necessary
	// parameter "My parameter" category: "My parameters" var: one_global_attribute;
	
	// Define attributes, actions, a init section and behaviors if necessary
	// init { }
	
	
	output {
		display mydisplay{
			species Auctioneer aspect:base;
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
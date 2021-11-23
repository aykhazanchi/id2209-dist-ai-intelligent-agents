/**
* Name: dutch
* Based on the internal empty template. 
* Author: vasigarans and aykhazanchi
* Tags: 
*/

//// TODO: Add inform (that auction is starting), participants respond with "ok"

model dutch

/* Insert your model definition here */

global{
	int numParticipants <- 3;
	int numAuctioneer <- 1;
	list<bool> bidResults <- list_with(numParticipants, false);
	bool run_auction <- true;
	
	init{
		
		/********** Initiator code **********/
		create Auctioneer number: numAuctioneer with:(location:point(15,15));
		
		// Set random start price for auction
		Auctioneer[0].price <- rnd(0, 300);
		
		// Set minPrice to 20% of price
		Auctioneer[0].minPrice <- ((0.2*(Auctioneer[0].price as int)) as int);
		
		/********** Participant code **********/
		create Participants[] number: numParticipants;
		int i<-0;
		loop participant over: Participants {
			// Set participant name
			participant.name <- 'Participant ' + i;
			
			// Set participant index
			participant.index <- i;
			
			// Set maxPrice randomly for each participant at init
			participant.maxPrice <- rnd(0, 100);
			
			// Increase counter for next participant
			i<-i+1;			
		}
	}
}
	


species Auctioneer skills: [fipa]{
	
	int price;
	int minPrice;
	bool increase_price <- false;
	bool reduce_price <- false;
	bool resultFromParticipant;
	
	reflex send_request when :(run_auction = true){
		
		write '';
		write '';
		write '';
		write 'value of proposals from any previous bid --- ' + bidResults;
		
		if (reduce_price = true) {
			price <- price - 5;
			reduce_price <- false;
		}
		else if (increase_price = true) {
			price <- price + 7;
			increase_price <- false;
		}

		write 'price set at ---> ' + price;
		write 'minPrice set at ---> ' + minPrice;
				
		// Check price is above or equal to minPrice, start auction
		if (price >= minPrice) {
			write 'New Dutch auction starting from send_request reflex';
			write ' -------------------------------------------- ';
			run_auction <- false;
			do start_conversation (to::list(Participants),protocol::'fipa-contract-net',performative::'cfp',contents::[price]);
		} 
		else if (price < minPrice) {
			write 'Minimum selling price has been reached without any successful bids. Auction has ended, unfortunately.';
		}
	}
	
	
	reflex read_proposal_message when: (!(empty(proposes))) {
			
		loop a over:proposes {
			int totalTrues <- 0;
			
			if(bidResults contains true) {
				loop bid_result over: bidResults {
					if (bid_result) {
						totalTrues <- totalTrues + 1;
					}
				}
			}
			if (totalTrues = 1) {
				// Get which index is true, that is also index of Participant
				int index <- bidResults index_of true;
				write 'Participant ' + index + ' is winner! with bid of ' + price;
				run_auction <- false;
				totalTrues<-nil;
			}
			else if (totalTrues < 1) {
				reduce_price <- true;
				run_auction <- true;
			}
			else if (totalTrues > 1) {
				increase_price <- true;
				run_auction <- true;
			}
		}
	}

	aspect base{
		draw square(7)  color: #orange;
	}
}

species Participants skills:[fipa]{
	
	string name;
	int maxPrice;
	bool result;
	int index;
	
	aspect base {
		draw circle(1) color: #green;
	}
		
	reflex reply_messages when:(!empty(cfps)){
		message proposalFromInitiator<-(cfps at 0);
		int auctionPrice;

		write 'maxPrice for ' + name + ' set to --- ' + maxPrice;
		
		// Pull out price from contents list. Only works this way for some reason.
		loop i over: proposalFromInitiator.contents {
			auctionPrice <- (i as int);
		}
		
		write 'Auction price currently at --- ' + auctionPrice;
		write ' -------------------------------------------- ';
		
		if(auctionPrice <= maxPrice) {
			result <- true;
			bidResults[index] <- true;
			do propose with: (message: proposalFromInitiator,contents: [result]);	
		}
		else if (auctionPrice > maxPrice) {			
			result <- false;
			bidResults[index] <- false;
			do propose with: (message: proposalFromInitiator,contents: [result]);	
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
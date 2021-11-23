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
	list<bool> bidResults <- list_with(numParticipants, false);
	bool run_auction <- true;
	
	init{
		
		/********** Initiator code **********/
		create Initiator number: numInitiator with:(location:point(15,15));
		
		// Set random start price for auction
		Initiator[0].price <- rnd(0, 100);
		
		// Set minPrice to 20% of price
		Initiator[0].minPrice <- ((0.2*(Initiator[0].price as int)) as int);
				
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
	


species Initiator skills: [fipa]{
	
	int price;
	int minPrice;
	bool increase_price <- false;
	bool reduce_price <- false;
	bool resultFromParticipant;
	
	reflex send_request when :(run_auction = true){
		
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
		
		write 'starting auction';
		
		// Check price is above or equal to minPrice, start auction
		if (price >= minPrice) {
			write 'auction starting from send_request reflex';
			run_auction <- false;
			do start_conversation (to::list(Participants),protocol::'fipa-contract-net',performative::'cfp',contents::[price]);
		}
	}
	
	
	reflex read_proposal_message when: (!(empty(proposes))) {
		
		loop a over:proposes {
			int totalTrues <- 0;
			loop r over: a.contents {
				resultFromParticipant <- (r as bool);
				if (resultFromParticipant) {
					totalTrues <- totalTrues + 1;
				}
			}
			if (totalTrues = 1) {
				write 'winner is there';
				run_auction <- false;
			}
			else if (totalTrues < 1) {
				reduce_price <- true;
				run_auction <- true;
			}
			else if (totalTrues > 1) {
				increase_price <- true;
				run_auction <- true;
			}
			/*
			if(bidResults contains true) {
				//int totalTrues <- 0;
				loop bidResult over: bidResults {
					if (bidResult) {
						totalTrues <- totalTrues + 1;
					}
				}
				if (totalTrues > 1) {
					// Means more than one participant agreed to buy
					// increase price, start auction again
					price <- price + 7;
					write 'auction starting from read_proposal_message totalTrues>1 reflex';
					run_auction <- true;
					
					// do start_conversation (to::list(Participants),protocol::'fipa-contract-net',performative::'cfp',contents::[price]);
				}
				else {
					// Here totalTrues = 1, identify winner based on location of true
					int winner <- bidResults index_of true;
					write 'Winner of auction with selling price of ' + price + ' is ' + Participants[winner].name;		
				}
			}
			else {
				// Means no one agreed to buy
				// reduce price, start auction again
				loop r over: a.contents {
					resultFromParticipant <- (r as bool);
				}
				if (!resultFromParticipant) {
					write 'Bid failed for: '+ string(a.contents) + ' bool value: ' + resultFromParticipant;
					price <- price - 5;
					if (price >= minPrice) {
						write 'auction starting from read_proposal_message totalTrues=0 reflex';
						run_auction <- true;
						// do start_conversation (to::list(Participants),protocol::'fipa-contract-net',performative::'cfp',contents::[price]); 
					}			
				}
				else if (price < minPrice) {
					write 'Minimum selling threshold reached, auction over without a sale...';
				}
			}
			*/
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
			do propose with: (message: proposalFromInitiator,contents: [name + ' will buy at ' + auctionPrice, result]);	
		}
		else if (auctionPrice > maxPrice) {			
			result <- false;
			bidResults[index] <- false;
			do propose with: (message: proposalFromInitiator,contents: ['' + auctionPrice + ' is too high for ' + name, result]);	
		}
		write 'value of bidResults --- ' + bidResults;
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
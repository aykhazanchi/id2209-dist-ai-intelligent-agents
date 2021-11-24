/**
* Name: genre
* Based on the internal empty template. 
* Author: vasigarans and aykhazanchi
* Tags: 
*/

//// TODO: Add inform (that auction is starting), participants respond with "ok"

model genre

/* Insert your model definition here */

global{
	int numParticipants <- 3;
	list<bool> bidResults <- list_with(numParticipants, false);
	bool run_auction <- true;
	
	init{
		
		/********** Initiator code **********/
		int u<-0;
		list<point> p<-[{15,15},{10,10}];
		
		create Auctioneer  with:(location:point(15,15)){
			genre<-'clothes';
			price <- rnd(0, 300);
			minPrice <- ((0.2*(Auctioneer[0].price as int)) as int);
		}	
		create Auctioneer  with:(location:point(30,30)){
			genre<-'CD';
			price <- rnd(0, 300);
			minPrice <- ((0.2*(Auctioneer[0].price as int)) as int);
		}
		create Auctioneer  with:(location:point(40,40)){
			genre<-'painting';
			price <- rnd(0, 300);
			minPrice <- ((0.2*(Auctioneer[0].price as int)) as int);
		}
		create Auctioneer  with:(location:point(55,55)){
			genre<-'sculpture';
			price <- rnd(0, 300);
			minPrice <- ((0.2*(Auctioneer[0].price as int)) as int);
		}

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
			
			// Randomly select genre from list
			list<string> genre <- ['clothes', 'CD', 'painting', 'sculpture'];
			
			// Find random genre from list above
			int pickIndex <- rnd(0, length(genre)-1);	// should be value of
			 
			// Set genre randomly for each participant at init
			participant.pGenre <- genre[pickIndex];
			
			// Increase counter for next participant
			i<-i+1;			
		}
	}
}
	


species Auctioneer skills: [fipa]{
	
	string genre;
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
			write 'New ' + genre + ' auction starting from ' + name;
			write ' -------------------------------------------- ';
			run_auction <- false;
			do start_conversation (to::list(Participants),protocol::'fipa-contract-net',performative::'cfp',contents::[price, genre]);
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
	
	string pGenre;
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
		string auctionGenre;
		
		write 'maxPrice for ' + name + ' set to --- ' + maxPrice;
		
		// hack to make it a sort of 'for' loop
		int counter <- 0;
		
		// Pull out price from contents list. Only works this way for some reason.
		loop i over: container(proposalFromInitiator.contents) {
			if (counter = 0) {
				auctionPrice <- (i as int);	
			}
			counter <- counter + 1;
		}

		// Pull out genre from contents list. Only works this way for some reason.
		loop i over: container(proposalFromInitiator.contents) {
			auctionGenre <- (i as string);
		}
		
		write 'Auction price currently at --- ' + auctionPrice;
		write 'Auction genre currently at --- ' + auctionGenre;
		write 'My genre of interest is currently --- ' + pGenre;
		
		if (pGenre = auctionGenre) {
			write 'I am interested in the ' + auctionGenre + ' auction with ' + agent(proposalFromInitiator.sender);
			write 'Sending my bid...';
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
		else {
			write "My interests don't match. Not joining the auction.";
		}		
		write ' -------------------------------------------- ';
		write '';
		
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
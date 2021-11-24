/**
* Name: multiple
* Based on the internal empty template. 
* Author: vasigarans and aykhazanchi
* Tags: 
*/


model multiple

/* Insert your model definition here */

global{
	int numParticipants <- 10;
	list<int> bidClothes <- list_with(numParticipants, 0);
	list<int> bidCD <- list_with(numParticipants, 0);
	list<int> bidPainting <- list_with(numParticipants, 0);
	list<int> bidSculpture <- list_with(numParticipants, 0);
	
	init{
		
		/********** Initiator code **********/
		create Auctioneer  with:(location:point(15,15)){
			genre<-'clothes';
		}	
		create Auctioneer  with:(location:point(30,30)){
			genre<-'CD';
		}
		create Auctioneer  with:(location:point(40,40)){
			genre<-'painting';
		}
		create Auctioneer  with:(location:point(55,55)){
			genre<-'sculpture';
		}


		/********** Participant code **********/
		create Participants number: numParticipants;
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
	string genre;
	
	reflex send_request {
		
		write '';
		write '';
		write '';
		write 'New auction starting for ' + genre + ' by ' + name;
		write 'Please submit your bids';
		write ' -------------------------------------------- ';
		do start_conversation (to::list(Participants),protocol::'fipa-contract-net',performative::'cfp',contents::[genre]);
	}
	
	reflex read_proposal_message when: (!(empty(proposes))) {
			
		loop a over:proposes {
			if (genre = 'clothes') {
				loop bid over: bidClothes {
					if (bid > max) {
						max <- bid;
					}
				}
				// Get index of max value which is also winning bid
				bidIndex <- bidClothes index_of max;
			}
			else if (genre = 'CD') {
				loop bid over: bidCD {
					if (bid > max) {
						max <- bid;
					}
				}
				// Get index of max value which is also winning bid
				bidIndex <- bidCD index_of max;
			}
			else if (genre = 'painting') {
				loop bid over: bidPainting {
					if (bid > max) {
						max <- bid;
					}
				}
				// Get index of max value which is also winning bid
				bidIndex <- bidPainting index_of max;
			}
			else if (genre = 'sculpture') {
				loop bid over: bidSculpture {
					if (bid > max) {
						max <- bid;
					}
				}
				// Get index of max value which is also winning bid
				bidIndex <- bidSculpture index_of max;
			}
		}
	}
	
	// declare winner only when bidIndex value has been changed from default of -1
	reflex declare_winner when: (bidIndex != -1){
		write 'winning bid for auction ' + genre + ' by ' + name + ' is ' + max + ' and winner is Participant ' + bidIndex;
		bidIndex <- -1;
	}
	
	aspect base{
		draw square(7)  color: #orange;
	}
}

species Participants skills:[fipa]{
	
	string name;
	string auctionGenre;
	// Set bid randomly for each participant
	int bid <- rnd(0, 100);
	int index;
		
	// Randomly select genre from list
	list<string> genres <- ['clothes', 'CD', 'painting', 'sculpture'];
	
	// Find random genre from list above
	int pickIndex <- rnd(0, length(genres)-1);	// should be value of
	
	// Set genre randomly for each participant at init
	string pGenre <- genres[pickIndex];
		
	aspect base {
		draw circle(1) color: #green;
	}
		
	reflex reply_messages when:(!empty(cfps)){
		message proposalFromInitiator<-(cfps at 0);
		
		// Pull out genre from contents list. Only works this way for some reason.
		loop i over: container(proposalFromInitiator.contents) {
			auctionGenre <- (i as string);
		}
		
		// only bid if the genre is of interest to you
		if (pGenre = auctionGenre) {
			if (pGenre = 'clothes') {
				bidClothes[index] <- bid;
				write '' + name + ' submitted bid for ' + pGenre + ' auction set to --- ' + bid;
				do propose with: (message: proposalFromInitiator,contents: [bidClothes]);	
			} 
			else if (pGenre = 'CD') {
				bidCD[index] <- bid;
				write '' + name + ' submitted bid for ' + pGenre + ' auction set to --- ' + bid;
				do propose with: (message: proposalFromInitiator,contents: [bidCD]);
				
			}
			else if (pGenre = 'painting') {
				bidPainting[index] <- bid;
				write '' + name + ' submitted bid for ' + pGenre + ' auction set to --- ' + bid;
				do propose with: (message: proposalFromInitiator,contents: [bidPainting]);	
			}
			else if (pGenre = 'sculpture') {
				bidSculpture[index] <- bid;
				write '' + name + ' submitted bid for ' + pGenre + ' auction set to --- ' + bid;
				do propose with: (message: proposalFromInitiator,contents: [bidSculpture]);	

			}
		}
		else {
			
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
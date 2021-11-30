/**
* Name: StageUtility
* Based on the internal empty template. 
* Author: aykhazanchi and vasigarans
* Tags: 
*/


model StageUtility

/* Insert your model definition here */

global {

	geometry shape <- square(50);
	int numGuests <- 20;
	int numStages <- 4 ;
	int concertRuntime <- 700;
	int concertDelay <- 200;
	
	init{
		create Stage with:(location:point(50,50));
		create Stage with:(location:point(0,50));
		create Stage with:(location:point(50,0));
		create Stage with:(location:point(0,0));

		// Initialize guests
		create Guests[] number: numGuests;
		
		// Create preferences for guests that do not change
		loop guest over: Guests {
			guest.lightshow <- rnd(0,1.0);
			guest.speakers <- rnd(0,1.0);
			guest.band <- rnd(0,1.0);
			guest.size <- rnd(0,1.0);
			guest.smoke <- rnd(0,1.0);
		}
		
	}		
}

species Stage skills: [fipa]{
	
	float lightshow;
	float speakers;
	float band;
	float size;
	float smoke;
	bool restartConcert <- true;
	rgb agentColor <- #black;
	
	action init {
		// Create preferences for stage that change at each concert start
		lightshow <- rnd(0, 1.0);
		speakers <- rnd(0, 1.0);
		band <- rnd(0, 1.0);
		size <- rnd(0, 1.0);
		smoke <- rnd(0, 1.0);
	}	
	
	reflex start_concert when: (restartConcert or concertRuntime <=0) {
		
		do init;
		
		restartConcert <- false;
		
		// Send out stage attributes to all guests
		write 'Concert starting at ' + name + ' with attributes - ';
		write '--------------------------------------------------------';
		do start_conversation (to::list(Guests),protocol::'fipa-contract-net',performative::'request',contents::[lightshow, speakers, band, size, smoke]);	
	}
	
	reflex run_concert when: (concertRuntime > 0) {
		concertRuntime <- concertRuntime - 1;
	}
	
	reflex restart_concert when: (!restartConcert and concertDelay <= 0) {
		restartConcert <- true;
		concertRuntime <- 700;
		concertDelay <- 200;
	}
	
	reflex concert_delay when: (!restartConcert and concertRuntime <= 0) {
		concertDelay <- concertDelay - 1;
	}
	
	aspect base {
		if (name = 'Stage0') {
			agentColor <- #red;
		}
		else if (name = 'Stage1') {
			agentColor <- #navy;
		}
		else if (name = 'Stage2') {
			agentColor <- #purple;
		}
		else if (name = 'Stage3') {
			agentColor <- #green;
		}
		
		draw square(5) at: location color: agentColor;
	}
	
}

species Guests skills: [fipa, moving]{
	
	float lightshow;
	float speakers;
	float band;
	float size;
	float smoke;

	float stgLightshow;
	float stgSpeakers;
	float stgBand;
	float stgSize;
	float stgSmoke;

	float myUtility;
	Stage stage;
	bool attendingConcert <- false;
	
	rgb agentColor <- #black;
	
	reflex find_stage when:(!empty(requests)) {
		message requestFromInitiator<-(requests at 0);
		
		write 'request from ' + Stage(requestFromInitiator.sender).name;
			
		// Pull out price from contents list. Only works this way for some reason.
		int i<-0;
		loop val over: container(requestFromInitiator.contents) {
			if (i = 0) {
				stgLightshow <- (val as float);
			} 
			else if (i = 1) {
				stgSpeakers <- (val as float);
			}
			else if (i = 2) {
				stgBand <- (val as float);
			}
			else if (i = 3) {
				stgSize <- (val as float);
			}
			else if (i = 4) {
				stgSmoke <- (val as float);
			}
			i <- i + 1;
		}
		
		float utility <- ((lightshow * stgLightshow) + (speakers * stgSpeakers) + (band * stgBand) + (size * stgSize) + (smoke * stgSmoke));
		
		if (myUtility < utility) {
			myUtility <- utility;
			stage <- Stage(requestFromInitiator.sender);
		}
	}
		
	reflex attend_concert {
		if (concertRuntime > 0) {
			if (stage != nil) {
				attendingConcert <- true;
				agentColor <- stage.agentColor;
				color <- agentColor;
				do goto target:stage.location speed: 2.0;	
			}	
		}
		else {
			attendingConcert <- false;
		}
	}
		
	// Whenever not attending concert, just wander around
	reflex wander when:(!attendingConcert) {
		do goto target:{25,25};	
		do wander speed: 2.0;	
	}
	
	aspect base {
		
		draw circle(1) at: location color: agentColor;
	}
}

experiment name type: gui {

	
	// Define parameters here if necessary
	// parameter "My parameter" category: "My parameters" var: one_global_attribute;
	
	// Define attributes, actions, a init section and behaviors if necessary
	// init { }
	
	
	output {
		display map type: opengl {
			species Stage aspect:base;
			species Guests aspect:base;
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
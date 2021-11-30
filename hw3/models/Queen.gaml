/**
* Name: Queen
* Based on the internal empty template. 
* Author: vasigarans and aykhazanchi
* Tags: 
*/


model Queen

/* Insert your model definition here */

global {
	int Nsize<-4;
	bool addQ<-true;
	int cur_index<-0;
	int i<-100;
	list<int>rowlist;
	list<int>collist;
	list<queen> queenlist;
	list<point> var;
	//list<point> mem<-nil;
	bool start_convo<-false;
	init{
		
	int counter<-0;
	//int temp_x;
	//int temp_y;
	int nil_x_index<-0;
	int nil_y_index<-rnd(0,Nsize-1);
	
	
	loop counter from:0 to:Nsize-1{
		if(Nsize=4)
		{
		nil_y_index<-1;
		}
		
		create queen {
			x_index<-nil_x_index;
	 		y_index<-nil_y_index;
	 		predecessor<-counter-1;
	 		successor<-counter+1;
	 		index<-counter;
	 		pos<-false;
	 		suc<-false;
	 		mem<-nil;
	 		talktosuc<-false;
	 		}
	 		
			
		}
		add nil_x_index to: rowlist;
	add nil_y_index to: collist;
	
	//add nil_x_index::nil_y_index to: var;
	add {nil_x_index,nil_y_index} to:var;
		
		write('index 0'+ 'at '+{nil_x_index,nil_y_index});
		add {nil_x_index,nil_y_index} to:queen[0].mem;
	
		}
		}
		

			
	






species queen skills: [fipa]{
	int x_index;
	int y_index;
	int predecessor;
	int successor;
	int index;
	bool pos;
	list<point> mem;
	bool suc;
	bool talktosuc;
	bool talktopre;
	
	
	
	
	init{
		add self to: queenlist;
		/*index<-int(queenlist[length(queenlist) -1]);
		
		if(index=0){
			predecessor<-nil;
			successor<-index+1;
		}
		else{
		predecessor<-index-1;
		successor<-index+1;
		
		}
		*/
		
		
		if(length(queenlist) = Nsize ){
			queen[0].talktosuc<-true;
			queen[0].predecessor<-0;
			
			
			
			
			}
		}
		
	reflex firstInfo when: talktosuc=true{
		//write  'kil'+ index;
		//start_convo<-false;
		//write(index);
		if(index=cur_index)
		{

			do start_conversation with:(to: list(queenlist[successor]), protocol: 'no-protocol', performative: 'inform', contents: ['tosuccessor']);
			talktosuc<-false;
		}
		
	}
	/*reflex addQueen{
		write(i);
		if(i<90){
			
			queen[1].x_index<-rnd(0,Nsize-1);
			queen[1].y_index<-rnd(0,Nsize-1);
			write(x_index,y_index);
			
		}
		i<-i-1;
		
	}*/
	
	reflex queenlisten when: (!empty(informs))
	{
		
		//write 'here';
		message msg <- informs[0];
        
        if(msg.contents=['tosuccessor'])
        {
        write 'received message from my predecessor to find a position  '+ agent(msg.sender).name + '  '+ msg.contents+ ' ';
        pos<-true;
        write('row list'+rowlist);
     		write('col list'+collist);
     		write('var '+var);
        
        }
         if(msg.contents=['topredecessor'])
        {
        	queenlist[index].x_index<-queenlist[predecessor].x_index;
        	queenlist[index].y_index<-queenlist[predecessor].y_index;
        	write 'i shall move '+index +' '+{x_index,y_index};
        	
        	suc<-true;
        }
        
        
        
        }
        
        
     reflex predecessormovement when: suc{
     	int temp_x;
     	int temp_y;
     	
     	int prev_x<-x_index;
     	int prev_y<-y_index;
     	write('1 '+index);
     	write('row list'+rowlist);
     		write('col list'+collist);
     		write('var '+var);
     	   write('pred val '+queenlist[predecessor].x_index)+ ' '+queenlist[predecessor].y_index ;
     	queenlist[index].x_index<-queenlist[predecessor].x_index;
        	queenlist[index].y_index<-queenlist[predecessor].y_index;
        	
     			remove rowlist[index] from: rowlist;
     		remove collist[index] from: collist;
     		remove var[index] from:var;
     		
     		write('row list'+rowlist);
     		write('col list'+collist);
     		write('var '+var);
     	
     	int row;
     	row<-index;
     	
     	
     			
     	if(index!=0)
     	{		
     			
     	loop col from:0 to: Nsize-1
     		{
     		if!(collist contains col) 
     			{
     				//write({row,col}={x_index,y_index});
     				//write({row,col});
     				write'memory '+mem;
     				if( !(mem contains{row,col})   and upperleftdiagonalcheck(row,col) and upperrightdiagonalcheck(row,col) and lowerrightdiagonalcheck(row,col) and lowerleftdiagonalcheck(row,col)){
     				temp_y<-col;
     				temp_x<-row;
     				suc<-false;
     				write('found '+{row,col}+ (mem contains{row,col})  );
     				cur_index<-index;
     				add {row,col} to:mem;
     				
     				break;
     					
     				}
     				
     				
     					
     					
     					
     				}
     				if(suc=false)
     				{
     					break;
     				}
     			}
     			
     			}
     			
     			if(index=0)
     	{
     		temp_x<-0;
     		temp_y<-queenlist[index].y_index+1;
     		suc<-false;
     		write('found made'+{temp_x,temp_y});
     	}
     			
     			
     			
     	
     	write('2');
     	
     	if(suc=false)
     	{
     	//write(var);
     	
     	//write(var);
     	//add {temp_x,temp_y} to:var;
     	queen[index].x_index<-temp_x;
     	queen[index].y_index<-temp_y;
     	add temp_x to: rowlist;
     	add temp_y to: collist;
     	add {temp_x,temp_y} to:var;
     	add {temp_x,temp_y} to:mem;
     	write(successor);
     	
     	do start_conversation with:(to: list(queenlist[successor]), protocol: 'no-protocol', performative: 'inform', contents: ['tosuccessor']);
     	}
     	
     	if(suc=true)
     			{
     				suc<-false;
     				write('no place found asking my predecessor to move'+ index);
     				do start_conversation with:(to: list(queenlist[predecessor]), protocol: 'no-protocol', performative: 'inform', contents: ['topredecessor']);
     				mem<-nil;
     			}
     	
     	
     	
     }   
        
     reflex findaposition when: pos{
     	
     	//write(var);
     	
     	
     	write('got here');
     	int temp_x;
     	int temp_y;
     	int row;
     	row<-index;
     			
     			
     			
     	loop col from:0 to: Nsize-1
     		{
     		if!(collist contains col)
     			{
     				//write({row,col});
     				if(upperleftdiagonalcheck(row,col) and upperrightdiagonalcheck(row,col) and lowerrightdiagonalcheck(row,col) and lowerleftdiagonalcheck(row,col)){
     				temp_y<-col;
     				temp_x<-row;
     				pos<-false;
     				
     				
     				break;
     					
     				}
     				
     				
     					
     					
     					
     				}
     			}
     			
     			
     			
     			
     			if(pos=false)
     	{
     	
     	add {temp_x,temp_y} to:var;
     	add {temp_x,temp_y} to:mem;
     	queen[index].x_index<-temp_x;
     	queen[index].y_index<-temp_y;
     	add temp_x to: rowlist;
     	add temp_y to: collist;
     	write('index '+ index+ 'at '+{x_index,y_index});
     	write('memory of index '+index+' '+mem);
     	if!(cur_index=Nsize-2)
     	{
     	cur_index<-cur_index+1;
     	talktosuc<-true;
     	
     	}
     	
     	}
     			
     			if(pos=true)
     			{
     				write('no place found asking my predecessor to move' +index);
     				pos<-false;
     				do start_conversation with:(to: list(queenlist[predecessor]), protocol: 'no-protocol', performative: 'inform', contents: ['topredecessor']);
     				mem<-nil;
     				
     			}
     	//write('here'+index);
     	
     	
     	
     	
     	
     	
     }
     
     
     bool upperleftdiagonalcheck(int row,int col){
     	bool rf<-true;
     	loop while: (col<Nsize and col>=0 and row>=0 and row<Nsize)
     	{
     		if(var contains {row,col})
     		{
     			rf<-false;
     			break;
     		}
     		
     		row<-row-1;
     		col<-col-1;
     	}
     
     
     
     return rf;	
     } 
     
     bool upperrightdiagonalcheck(int row,int col){
     	bool rf<-true;
     	loop while: (col<Nsize and col>=0 and row>=0 and row<Nsize)
     	{
     		if(var contains {row,col})
     		{
     			rf<-false;
     			break;
     		}
     		
     		row<-row-1;
     		col<-col+1;
     	}
     
     
     
     return rf;	
     } 
     
     bool lowerrightdiagonalcheck(int row,int col){
     	bool rf<-true;
     	loop while: (col<Nsize and col>=0 and row>=0 and row<Nsize)
     	{
     		if(var contains {row,col})
     		{
     			rf<-false;
     			break;
     		}
     		
     		row<-row+1;
     		col<-col+1;
     	}
     	
     	return rf;	
     	}
     	
     bool lowerleftdiagonalcheck(int row,int col){
     	bool rf<-true;
     	loop while: (col<Nsize and col>=0 and row>=0 and row<Nsize)
     	{
     		if(var contains {row,col})
     		{
     			rf<-false;
     			break;
     		}
     		
     		row<-row+1;
     		col<-col-1;
     	}
     
     
     
     return rf;	
     } 
     
		
		
		
	
	aspect base{
		//write(x_index);
	 	//write(y_index);
	 	
		draw circle(0.3*100/Nsize) color: 'black' at: MyGrid[x_index,y_index];
		//image_file paofc <- image_file('https://upload.wikimedia.org/wikipedia/en/5/5f/Original_Doge_meme.jpg');
		//draw paofc size: 9 at: MyGrid[x_index,y_index];
		}
		
		
		}
		
		
		//draw circle(0.3*100/Nsize) color: 'black' at: MyGrid[x_index,y_index];


grid MyGrid width: Nsize height: Nsize{
	bool occupied<-false;
	aspect base{
		rgb agentColor<-nil;
		if (grid_x mod 2=0){
			if(grid_y mod 2 =0){
				//agentColor<-rgb(0,122,61);
				agentColor<-rgb('black');
			}
			else{
				agentColor<-rgb('white');
			}
		}
		else
		{
			if(grid_y mod 2 =1){
				//agentColor<-rgb(0,122,61);
				agentColor<-rgb('black');
			} else{
				agentColor<-rgb('white');
			}
		}
		draw square(100/Nsize) color: agentColor;
	}
}



experiment name type: gui {

	
	// Define parameters here if necessary
	// parameter "My parameter" category: "My parameters" var: one_global_attribute;
	
	// Define attributes, actions, a init section and behaviors if necessary
	// init { }
	
	
	output {
		display MyDisplay type: opengl{
			species MyGrid aspect: base;
			species queen aspect:base;
			
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
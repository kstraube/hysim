#include <iostream>
#include <queue>
#include <string> 
#include <stdint.h>
#include "CacheTag.h"
#include "EventQueue.h"

using namespace std; 

EventQueue::EventQueue(){
	mem_delay=0;
	instr_delay=0;
	new_stall_cycles=0;
	msg=new SMessage;
}

void EventQueue::produce(SMessage *msg){ 
	event.push(msg);

}

uint32_t EventQueue::consume(){
	mem_delay=0;
	if(event.front()->opcode_m.find("ld")!= string::npos){
		event.front()->DCache_m->readLine(msg->address_m);
		mem_delay = 1;
	}
	else if(event.front()->opcode_m.find("st")!= string::npos){
		event.front()->DCache_m->writeLine(msg->address_m);
		mem_delay = 1;
	}
	else if(event.front()->opcode_m.find("swap")!= string::npos){
		event.front()->DCache_m->readLine(msg->address_m);
		event.front()->DCache_m->writeLine(msg->address_m);
		mem_delay = 2;
	}
	
	event.front()->ICache_m->readLine(msg->address_m);
	instr_delay = 1;
	event.pop();

	return max(instr_delay,mem_delay);
	
}


int EventQueue::preprocessing(SMessage *msg){ 

	dflag=msg->DCache_m->checkHit(msg->opcode_m, msg->address_m);
	iflag=msg->ICache_m->checkHit(msg->opcode_m, msg->address_m);
	if (dflag==iflag) runflag=1;
	else runflag=0;
	return runflag;
}



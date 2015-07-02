#include <iostream>
#include <queue>
#include <string> 
#include <stdint.h>
#include "CacheTag.h"

using namespace std; 
typedef struct MESSAGE{
	uint32_t tid;
	CCacheTag* ICache_m;
	CCacheTag* DCache_m;
    string opcode_m;
	uint32_t address_m;
} SMessage;


class EventQueue{
public:
	std::queue <SMessage *> event;
protected:
	uint32_t mem_delay;
	uint32_t instr_delay;
	uint32_t new_stall_cycles;
	int runflag;
	int dflag;
	int iflag;
	SMessage *msg;

public:
	EventQueue();
	~EventQueue(){
		delete [] msg;
	};

	void produce(SMessage *msg); 
	uint32_t consume();  
	int preprocessing(SMessage *msg);
};



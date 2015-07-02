/*#include "CacheTag.h"

CCacheTag::CCacheTag(uint32_t linesize, uint32_t ways, uint32_t sets){
    uint32_t SetBits = 0;
    uint32_t TagIndex = 0;
    
    while(sets > (1<<SetBits)){
        SetBits++;
    }
    DSetMask = 0;
    for(uint32_t Index = 0; Index < SetBits; Index++){
        DSetMask |= 1<<Index;
    }
    
    DSetShift = 0;
    while(linesize > (1<<DSetShift)){
        DSetShift++;
    }
    
    DAddressMask = 0;
    for(uint32_t Index = 0; Index < DSetShift; Index++){
        DAddressMask |= 1<<Index;
    }
    DAddressMask = ~DAddressMask;
    
    DLineSize = linesize;
        
    DNextLevel = NULL;
    
    DAllocation = new SCacheLineTag[ways * sets];
    
    DTags.resize(sets);
    for(uint32_t SetIndex = 0; SetIndex < sets; SetIndex++){
        DTags[SetIndex] = &DAllocation[TagIndex];
        for(uint32_t WayIndex = 0; WayIndex < ways; WayIndex++){
            if(WayIndex + 1 == ways){
                DAllocation[TagIndex].DNext = NULL;
            }
            else{
                DAllocation[TagIndex].DNext = &DAllocation[TagIndex+1];
            }
            DAllocation[TagIndex].DValid = false;
            TagIndex++;
        }
    }

    DMissDelay = 2;
}

uint32_t CCacheTag::Access(uint32_t address){
    uint32_t SetIndex = (address>>DSetShift) & DSetMask;
    uint32_t CompareAddress = address & DAddressMask;
    uint32_t NextLevelDelay = 0;
    SCacheLineTag *Current = DTags[SetIndex];
    SCacheLineTag *Previous = NULL;    
    SCacheLineTag *Last = NULL;    

    while(Current){
        if(Current->DValid && (Current->DAddress == CompareAddress)){
            // Move to front
            if(NULL == Previous){
                return 0;
            }
            Previous->DNext = Current->DNext;
            Current->DNext = DTags[SetIndex];
            DTags[SetIndex] = Current;
            return 0;
        }
        Last = Previous;
        Previous = Current;
        Current = Current->DNext;
    }
    if(NULL != DNextLevel){
        NextLevelDelay = DNextLevel->Access(address);
    }
    Previous->DValid = true;
    Previous->DAddress = CompareAddress;
    if(NULL != Last){
        Last->DNext = NULL;
        Previous->DNext = DTags[SetIndex];
        DTags[SetIndex] = Previous;
    }
    
    return DMissDelay + NextLevelDelay;
}*/


#include "CacheTag.h"
#include <iostream>


CCacheTag::CCacheTag(uint32_t cpuid, uint32_t linesize, uint32_t ways, uint32_t sets, std::vector<CCacheTag * > * all_Caches){   
    uint32_t SetBits = 0;
    uint32_t TagIndex = 0;
    
    while(sets > (1<<SetBits)){  
        SetBits++; 
    }
    DSetMask = 0;
    for(uint32_t Index = 0; Index < SetBits; Index++){
        DSetMask |= 1<<Index; 
    }
    
    DSetShift = 0;
    while(linesize > (1<<DSetShift)){ 
        DSetShift++;   
    }
    
    DAddressMask = 0;
    for(uint32_t Index = 0; Index < DSetShift; Index++){
        DAddressMask |= 1<<Index;   
    }
    DAddressMask = ~DAddressMask; 
    
    DLineSize = linesize;
	DCPUId=cpuid;
    allCaches = all_Caches;    
    DNextLevel = NULL;
    
    DAllocation = new SCacheLineTag[ways * sets];  
    
    DTags.resize(sets);   
    for(uint32_t SetIndex = 0; SetIndex < sets; SetIndex++){  
        DTags[SetIndex] = &DAllocation[TagIndex];  
        for(uint32_t WayIndex = 0; WayIndex < ways; WayIndex++){   
            if(WayIndex + 1 == ways){
                DAllocation[TagIndex].DNext = NULL;  
            }
            else{
                DAllocation[TagIndex].DNext = &DAllocation[TagIndex+1];  
            }
            DAllocation[TagIndex].DValid = false; 
			DAllocation[TagIndex].DState = MSI_INVALID;
            TagIndex++; 
        }
    }
	
    DMissDelay = 2; 
}


CCacheTag::CCacheTag(uint32_t linesize, uint32_t ways, uint32_t sets){  //L2
    uint32_t SetBits = 0;
    uint32_t TagIndex = 0;
    
    while(sets > (1<<SetBits)){ 
        SetBits++;  
    }
    DSetMask = 0;
    for(uint32_t Index = 0; Index < SetBits; Index++){
        DSetMask |= 1<<Index; 
    }
    
    DSetShift = 0;
    while(linesize > (1<<DSetShift)){   
        DSetShift++;   
    }
    
    DAddressMask = 0;
    for(uint32_t Index = 0; Index < DSetShift; Index++){
        DAddressMask |= 1<<Index;   
    }
    DAddressMask = ~DAddressMask; 
    
    DLineSize = linesize;   
    DNextLevel = NULL;
    
    DAllocation = new SCacheLineTag[ways * sets];  
    
    DTags.resize(sets);  
    for(uint32_t SetIndex = 0; SetIndex < sets; SetIndex++){  
        DTags[SetIndex] = &DAllocation[TagIndex];  
        for(uint32_t WayIndex = 0; WayIndex < ways; WayIndex++){   
            if(WayIndex + 1 == ways){
                DAllocation[TagIndex].DNext = NULL;  
            }
            else{
                DAllocation[TagIndex].DNext = &DAllocation[TagIndex+1]; 
            }
            DAllocation[TagIndex].DValid = false; 
			DAllocation[TagIndex].DState = MSI_INVALID;
            TagIndex++;  
        }
    }
	
    DMissDelay = 2;  
}





void CCacheTag::invalidLine(uint32_t address){   
    uint32_t SetIndex = (address>>DSetShift) & DSetMask;  
    uint32_t CompareAddress = address & DAddressMask;  
    SCacheLineTag *Current = DTags[SetIndex];  

    while(Current){
        if(Current->DValid && (Current->DAddress == CompareAddress)){  
			Current->DState = MSI_INVALID;  
			return;
        }
        Current = Current->DNext; 
    }
	return;
}

void CCacheTag::shareLine(uint32_t address){    
    uint32_t SetIndex = (address>>DSetShift) & DSetMask;    
    uint32_t CompareAddress = address & DAddressMask;  
    SCacheLineTag *Current = DTags[SetIndex]; 

    while(Current){
		if(Current->DValid && (Current->DAddress == CompareAddress)){  	
			if(Current->DState == MSI_MODIFIED){
				
				Current->DState = MSI_SHARED;	
			}  
			Current->DState = MSI_SHARED; 
			return;
        }
        Current = Current->DNext; 
    }
	return;
}

uint32_t CCacheTag::Access(uint32_t address){     
    uint32_t SetIndex = (address>>DSetShift) & DSetMask;   
    uint32_t CompareAddress = address & DAddressMask; 
    uint32_t NextLevelDelay = 0;
    SCacheLineTag *Current = DTags[SetIndex];  
    SCacheLineTag *Previous = NULL;    
    SCacheLineTag *Last = NULL;    

    while(Current){
        if(Current->DValid && (Current->DAddress == CompareAddress)){  
            // Move to front
            if(NULL == Previous){ 
                return 0;
            }
	
            Previous->DNext = Current->DNext;
            Current->DNext = DTags[SetIndex];
            DTags[SetIndex] = Current;
            return 0;  
        }
		
        Last = Previous; 
        Previous = Current;
        Current = Current->DNext; 
		

    }
    if(NULL != DNextLevel){  
        NextLevelDelay = DNextLevel->Access(address);
    }
    Previous->DValid = true;  
    Previous->DAddress = CompareAddress;
    if(NULL != Last){
        Last->DNext = NULL;
        Previous->DNext = DTags[SetIndex];
        DTags[SetIndex] = Previous; 
    }

    return DMissDelay + NextLevelDelay;  
}


uint32_t CCacheTag::writeLine(uint32_t address){ 
    uint32_t SetIndex = (address>>DSetShift) & DSetMask; 
    uint32_t CompareAddress = address & DAddressMask; 
    uint32_t NextLevelDelay = 0;
	uint32_t SnoopDelay = 0;
    SCacheLineTag *Current = DTags[SetIndex]; 
    SCacheLineTag *Previous = NULL;    
    SCacheLineTag *Last = NULL;    
	std::vector<CCacheTag * >::iterator cacheIter;
    std::vector<CCacheTag * >::iterator lastCacheIter;


	while(Current){
        if(Current->DValid && (Current->DAddress == CompareAddress)){   
			if(Current->DState != MSI_MODIFIED){
				for(cacheIter = this->getCacheVector()->begin(), 
					lastCacheIter = this->getCacheVector()->end(); 
					cacheIter != lastCacheIter; 
					cacheIter++){
						CCacheTag *otherCache = (CCacheTag*)*cacheIter; 
						if(otherCache->getCPUId() == this->getCPUId()){
							continue;
						}
						otherCache->invalidLine(address);
						SnoopDelay+=1;
				}	
				Current->DState = MSI_MODIFIED;
			}
			
            if(NULL == Previous){
                return SnoopDelay;
            }
            Previous->DNext = Current->DNext;
            Current->DNext = DTags[SetIndex];
            DTags[SetIndex] = Current;   
            return SnoopDelay;
        }
		Last = Previous; 
        Previous = Current;
        Current = Current->DNext;
    }
	

	if(NULL != DNextLevel){ 
        NextLevelDelay = DNextLevel->Access(address);
    }

    
	Previous->DValid = true; 
	Previous->DState = MSI_MODIFIED;
	for(cacheIter = this->getCacheVector()->begin(), 
		lastCacheIter = this->getCacheVector()->end(); 
		cacheIter != lastCacheIter; 
		cacheIter++){
			CCacheTag *otherCache = (CCacheTag*)*cacheIter; 
			if(otherCache->getCPUId() == this->getCPUId()){
				continue;
			}
			
			otherCache->invalidLine(address);
			SnoopDelay+=1; 
	}
    
	Previous->DAddress = CompareAddress;
    if(NULL != Last){
        Last->DNext = NULL;
        Previous->DNext = DTags[SetIndex];
        DTags[SetIndex] = Previous;  
    }

    return DMissDelay + NextLevelDelay + SnoopDelay; 
}


uint32_t CCacheTag::readLine(uint32_t address){     
    uint32_t SetIndex = (address>>DSetShift) & DSetMask; 
    uint32_t CompareAddress = address & DAddressMask;
    uint32_t NextLevelDelay = 0;
    SCacheLineTag *Current = DTags[SetIndex]; 
    SCacheLineTag *Previous = NULL;    
    SCacheLineTag *Last = NULL;    
	std::vector<CCacheTag * >::iterator cacheIter;
    std::vector<CCacheTag * >::iterator lastCacheIter;

    while(Current){
        if(Current->DValid && (Current->DAddress == CompareAddress)){
			if(Current->DState == MSI_INVALID){
				for(cacheIter = this->getCacheVector()->begin(), 
					lastCacheIter = this->getCacheVector()->end(); 
					cacheIter != lastCacheIter; 
					cacheIter++){
						CCacheTag *otherCache = (CCacheTag*)*cacheIter; 
						if(otherCache->getCPUId() == this->getCPUId()){
							continue;
						}
						otherCache->shareLine(address);
				}
				Current->DState = MSI_SHARED;
			}
            
            if(NULL == Previous){ 
                return 1;
            }
            Previous->DNext = Current->DNext;
            Current->DNext = DTags[SetIndex];
            DTags[SetIndex] = Current;   
            return 1;  
        }

        Last = Previous;  
        Previous = Current;
        Current = Current->DNext; 
    }
	
	
    if(NULL != DNextLevel){ 
        NextLevelDelay = DNextLevel->Access(address);
    }
	

    Previous->DValid = true;  
	Previous->DState = MSI_SHARED;
	for(cacheIter = this->getCacheVector()->begin(), 
		lastCacheIter = this->getCacheVector()->end(); 
		cacheIter != lastCacheIter; 
		cacheIter++){
			CCacheTag *otherCache = (CCacheTag*)*cacheIter; 
			if(otherCache->getCPUId() == this->getCPUId()){
				continue;
			}
			otherCache->shareLine(address);
	}
    
    Previous->DAddress = CompareAddress;
    if(NULL != Last){
        Last->DNext = NULL;
        Previous->DNext = DTags[SetIndex];
        DTags[SetIndex] = Previous; 
    }

    return 0; 
}

uint32_t CCacheTag::checkHit(std::string opcode, uint32_t address){
    uint32_t SetIndex = (address>>DSetShift) & DSetMask;  
    uint32_t CompareAddress = address & DAddressMask; 
    uint32_t NextLevelDelay = 0;
    SCacheLineTag *Current = DTags[SetIndex]; 
    SCacheLineTag *Previous = NULL;    
    SCacheLineTag *Last = NULL;    

	while(Current){
        if(Current->DValid && (Current->DAddress == CompareAddress)){
			if((opcode.find("ld") && (Current->DState == MSI_MODIFIED || Current->DState == MSI_SHARED)) || (opcode.find("st")  && Current->DState == MSI_MODIFIED )||(opcode.find("swap")  && Current->DState==MSI_MODIFIED )){
				if(NULL == Previous){ 
					return 1;  //runflag=1
				}
				Previous->DNext = Current->DNext;
				Current->DNext = DTags[SetIndex];
				DTags[SetIndex] = Current;   
				return 1; 
			}
		}
        Last = Previous; 
        Previous = Current;
        Current = Current->DNext; 
    }
	return 0;
}


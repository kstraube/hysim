/*#ifndef CACHETAG_H
#define CACHETAG_H

#include <stdint.h>
#include <cstddef>
#include <vector>

typedef struct CACHE_LINE_TAG{
    uint32_t DAddress;
    bool DValid;
    struct CACHE_LINE_TAG *DNext;
} SCacheLineTag;

class CCacheTag{
    protected:
        CCacheTag *DNextLevel;
        SCacheLineTag *DAllocation;
        std::vector<SCacheLineTag *> DTags;
        uint32_t DLineSize;
        uint32_t DAddressMask;
        uint32_t DMissDelay;
        uint32_t DSetShift;
        uint32_t DSetMask;
        
    public:
        CCacheTag(uint32_t linesize, uint32_t ways, uint32_t sets);
        ~CCacheTag(){
            delete [] DAllocation;
        };
        
        uint32_t LineSize() const{
            return DLineSize;
        };
        
        uint32_t MissDelay() const{
            return DMissDelay;
        };
        uint32_t MissDelay(uint32_t delay){
            return DMissDelay = delay;
        };
        
        void SetNextLevel(CCacheTag &nextlevel){
            DNextLevel = &nextlevel;
        };
        
        uint32_t Access(uint32_t address);
        
};

#endif
*/


#ifndef CACHETAG_H
#define CACHETAG_H

#include <string>
#include <stdint.h>
#include <cstddef>
#include <vector>



enum MSIState_t {
  MSI_MODIFIED          = 0x00000001,
  MSI_SHARED            = 0x00000100,
  MSI_INVALID           = 0x00001000
};

typedef struct CACHE_LINE_TAG{
    uint32_t DAddress;
	uint32_t DState;
    bool DValid;
    struct CACHE_LINE_TAG *DNext;
} SCacheLineTag;



class CCacheTag{
    protected:
        CCacheTag *DNextLevel;
        SCacheLineTag *DAllocation;
        std::vector<SCacheLineTag *> DTags;
        uint32_t DLineSize;   //line=block
        uint32_t DAddressMask;
        uint32_t DMissDelay;
        uint32_t DSetShift;
        uint32_t DSetMask;
        uint32_t DCPUId;

    public:
        CCacheTag(uint32_t cpuid, uint32_t linesize, uint32_t ways, uint32_t sets, std::vector<CCacheTag * > * all_Caches ); 
		CCacheTag(uint32_t linesize, uint32_t ways, uint32_t sets);
        ~CCacheTag(){
            delete [] DAllocation;
        };
        
		uint32_t getCPUId() const{
            return DCPUId;
        };

        uint32_t LineSize() const{
            return DLineSize;
        };
        
        uint32_t MissDelay() const{   
            return DMissDelay;
        };

		uint32_t MissDelay(uint32_t delay){   
            return DMissDelay = delay;
        };

        void SetNextLevel(CCacheTag &nextlevel){   
            DNextLevel = &nextlevel;
        };

        uint32_t Access(uint32_t address);
        uint32_t writeLine(uint32_t address);
	uint32_t readLine(uint32_t address);
	uint32_t checkHit(std::string opcode, uint32_t address);
	void invalidLine(uint32_t address);
	void shareLine(uint32_t address);
	//void createNewCache(unsigned int CPUid, uint32_t linesize, uint32_t ways, uint32_t sets);
		
	std::vector<CCacheTag * > *allCaches;
	std::vector<CCacheTag * > *getCacheVector(){
		return allCaches;
	};

};




#endif

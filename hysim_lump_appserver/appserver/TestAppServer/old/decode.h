#ifndef DECODE_H
#define DECODE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <memory.h>
#include <stdint.h>


char* decodeInstruction(char* cpuInstruction, uint32_t regPC);
char* getIntegerRegisterName(uint32_t registerIdentifier);
char* getFloatingRegisterName(uint32_t registerIdentifier);
char* getCoProcessorRegisterName(uint32_t registerIdentifier);
char* getAddress(uint32_t rs1, uint32_t rs2, uint32_t i, uint32_t simm13, int registerTypeIdentifier);
char* getReg_Or_Imm(uint32_t rs2, uint32_t i, uint32_t simm13, int registerTypeIdentifier);

#endif

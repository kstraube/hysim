#ifndef DECODE_H
#define DECODE_H

#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <memory.h>
#include <stdint.h>
#include <sstream>


std::string decodeInstruction(const char* cpuInstruction, uint32_t regPC);
std::string getIntegerRegisterName(uint32_t registerIdentifier);
std::string getFloatingRegisterName(uint32_t registerIdentifier);
std::string getCoProcessorRegisterName(uint32_t registerIdentifier);
std::string getAddress(uint32_t rs1, uint32_t rs2, uint32_t i, uint32_t simm13, int registerTypeIdentifier);
std::string getReg_Or_Imm(uint32_t rs2, uint32_t i, uint32_t simm13, int registerTypeIdentifier);

#endif

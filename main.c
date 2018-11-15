/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* 
 * File:   main.cpp
 * Author: vk496
 *
 * Created on 7 de noviembre de 2018, 15:49
 */

#include <stdio.h>
#include <stdlib.h>

#include "cmdhfmfhard.h"


int hextobin(const char *hexstring, uint8_t *val) {
    const char *pos = hexstring;

     /* WARNING: no sanitization or error-checking whatsoever */
    for (size_t count = 0; count < 6; count++) {
        sscanf(pos, "%2hhx", &val[count]);
        pos += 2;
    }

    return 0;
}

int main(void) {

    printf("Hello, world!\n");
    uint8_t blockNo = strtoul("0", NULL, 10) & 0xff;
    uint8_t keyType = 0; //A=0 or B=1
    const char hexstring[] = "001122334455";
    uint8_t key[6] = {0, 0, 0, 0, 0, 0};
    uint8_t trgBlockNo = strtoul("60", NULL, 10) & 0xff;
    uint8_t trgKeyType = 0; //A=0 or B=1
    uint8_t *trgkey = NULL;
    bool nonce_file_read = true; // use pre-acquired data from file nonces.bin
    bool nonce_file_write = false; //?
    bool slow = false; //not the case
    int tests = 0; //?
        
    hextobin(hexstring, key);

    mfnestedhard(blockNo, keyType, key, trgBlockNo, trgKeyType, trgkey, nonce_file_read, nonce_file_write, slow, tests);

    printf("test\n");

    return 0;
}


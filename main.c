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

int main(int argc, const char * argv[]) {

    printf("Hello, world!\n");
    if(argc < 6){
        printf("%s <known key> <for block> <A|B> <target block> <A|B>\n", argv[0]);
        return 1;
    }
    
    uint8_t blockNo = atoi(argv[2]);
    uint8_t keyType = 0; //A=0 or B=1
    if(argv[3][0] == 'b' || argv[3][0] == 'B'){
       keyType = 1;
    }
    uint8_t key[6] = {0};
    uint8_t trgBlockNo = atoi(argv[4]);
    uint8_t trgKeyType = 0; //A=0 or B=1
    if(argv[5][0] == 'b' || argv[5][0] == 'B'){
       trgKeyType = 1;
    }
    uint8_t *trgkey = NULL;
    bool nonce_file_read = false; // use pre-acquired data from file nonces.bin
    bool nonce_file_write = false; //?
    bool slow = false; //not the case
    int tests = 0; //?
        
    hextobin(argv[1], key);
    
    mfnestedhard(blockNo, keyType, key, trgBlockNo, trgKeyType, trgkey, nonce_file_read, nonce_file_write, slow, tests);

    printf("test\n");

    return 0;
}


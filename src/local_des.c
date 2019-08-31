#include <R.h>
#include <stdio.h>
#include <stdlib.h>

#include "des.h"

void decrypt(char **inFile, char **outFile) {

    const char idatKey[8] = { 127, 10, 73, -115, -47, -40, 25, -85 };
    char sessionKey[8];
    int fSize, len, i;
    char *data;

    FILE *f = fopen(inFile[0], "rb");
    if(f) {

        /* find the total length of the file */
        fseek (f , 0 , SEEK_END);
        fSize = (int) ftell (f);
        rewind (f);

        /* skip the first 9 bytes, these are the header
        contains the string "IDAT", a version number and
                the number of bytes in the next key */
        fseek(f, 9, SEEK_SET);
        /* read the key for this file */
        if(fread(sessionKey, 8, 1, f) != 1) {
            error("Error reading session key\n");
        }

        /* find the length of the data, minus the header */
        len = fSize - 17;

        /* allocate memory and read data */
        data = (char *)calloc(len, sizeof(char));
        memset(data, 0, len);
        if(fread(data, len, 1, f) != 1) {
            error("Error reading IDAT data\n");
        }

        fclose(f);

        /* open file to write XML to */
        FILE *f2 = fopen(outFile[0], "w");
        if(f2) {
            /* decrypt the file specific key and replace it */
            gl_des_ctx context1;
            gl_des_setkey(&context1, idatKey);
            gl_des_ecb_decrypt(&context1, sessionKey, sessionKey);

            /* use the file key to decrypt the remaining data */
            gl_des_ctx context2;
            gl_des_setkey(&context2, sessionKey);
            for(i = 0; i < len; i += 8) {
                gl_des_ecb_decrypt(&context2, (data + i), (data + i));           
            }
            /* print the decoded information to file */
            for(i = 4; i < len; i++)
                fprintf(f2, "%c", data[i]);
            fprintf(f2, "\n");    
    
            fclose(f2);
        }
        else {
            error("Problem opening output file\n");
        }
    }
    else {
        error("Problem opening input file\n");
    }  
}

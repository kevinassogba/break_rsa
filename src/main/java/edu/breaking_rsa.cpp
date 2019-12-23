
#include <iostream>
#include <math.h>
#include <stdlib.h>
#include <cstdio>
#include <ctime>
using namespace std;


unsigned long long int encrypt( unsigned long long int message, unsigned long long int modulus)
{
    unsigned long long int ciphertext = message % modulus;

    for(int index = 0; index < 2; index++) {
        ciphertext = (ciphertext * message) % modulus;
    }

    return ciphertext;
}

int main(int argc, char* argv[])
{
    // read command line arguments
    unsigned long long int ciphertext = atoi(argv[1]); // value of c
    unsigned long long int modulus = atoi(argv[2]); // value of n
    bool found = false;

    // start time
    clock_t start, end;
    start = clock();

    for(unsigned long long int curr = 0; curr < modulus; curr++)
    {
        unsigned long long int result = encrypt(curr, modulus);

        if( result == ciphertext )
        {
            found = true;
            printf("%lld^3 = %lld (mod %lld)\n", curr, ciphertext, modulus);
        }
    }

    if(!found)
    {
        printf("No cube roots of %lld (mod %lld)\n", ciphertext, modulus);
    }

    // End timer
    end = clock();
    double time_taken = double(end - start) / double(CLOCKS_PER_SEC);
    cout << "Breaking RSA CPU computation time : " << fixed
         << time_taken;
    cout << " seconds\n" << endl;
    return 0;
}

# Breaking RSA

## Description
This project consists in GPU programming using CUDA. The task aims at breaking 
RSA encryption key following the cube mod approach. For more about 
the theoretical foundation of that method, please consult [this gitlab page.](https://gitlab.com/SpiRITlab/parallelcomputing/tree/master/breaking_rsa)

This repository contains a sequential program and a cuda version of the code.

## Performance
During tests on my local machine and on RIT's kraken.cs.rit.edu machine,
the performance of the cuda algorithm is enhance as the search range increases.
This also shows that the sequential code is more appropriate for small size decryption,
while the cuda code is appropriate for larger / more complex tasks.

**Please refer to section *instructions* below to understand better
the difference between the time taken by the sequential program and the cuda
programs.**

## Instructions

### Syntax
On kraken.cs.rit.edu, the performance obtained are as below. 
Note that the among parameters, *c* refers to the **ciphertext** and *n* to the **modulus**.

1. Run the MakeFile:
    `make`

2. Sequential version:
    `./bin/breaking_rsa <<value of c>> <<value of n>>`

3. GPU version:
    `./bin/breaking_rsa_GPU <<value of c>> <<value of n>>`

### Outputs

The results are:

    ./bin/breaking_rsa 46054145 124822069
    
        142857^3 = 46054145 (mod 124822069)
        27549958^3 = 46054145 (mod 124822069)
        97129254^3 = 46054145 (mod 124822069)
        Breaking RSA CPU computation time : 4.417013 seconds
    
    
    ./bin/breaking_rsa_GPU 46054145 124822069
    
        There are 3 possible messages which encryption give 46054145
        142857^3 = 46054145 (mod 124822069)
        27549958^3 = 46054145 (mod 124822069)
        97129254^3 = 46054145 (mod 124822069)
        Breaking RSA GPU version 1 computation time : 1.893311 seconds

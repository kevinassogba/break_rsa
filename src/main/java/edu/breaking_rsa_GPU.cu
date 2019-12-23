
#include <iostream>
#include <math.h>
#include <stdlib.h>
#include <iomanip>
#include <sstream>
#include <sys/time.h>

using namespace std;

__managed__ int possible_msg;

__global__
void evaluate( unsigned long long int ciphertext,
            unsigned long long int modulus, unsigned long long int* solution )
{
    // index = block index * number of threads per block + thread index
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    // stride  = number threads per block * number of block per grid
    int stride = blockDim.x * gridDim.x;

    // vector<unsigned long long int> ker_res = {0};

    for(unsigned long long int curr = index; curr < modulus; curr += stride)
    {
        // compute cube mode to encrypt the current value of modulus
        unsigned long long int result = curr % modulus;

        for(int index = 0; index < 2; index++) {
            result = (result * curr) % modulus;
        }

        // add the result to the device vector,
        // and add a count of 1 to the number of solution available
        if( result == ciphertext )
        {
            atomicAdd(&possible_msg, 1);
            solution[curr] = 1; // if correct index, mark that index
        }
    }
}

void print_result(unsigned long long int* host_result,
        unsigned long long int ciphertext, unsigned long long int modulus)
{
    // iterate over the vector on the host to print the marked indices
    for(unsigned long long int index = 0; index < modulus; index++)
    {
        if( host_result[index] == 1 )
        {
            printf("%lld^3 = %lld (mod %lld)\n", index, ciphertext, modulus);
        }
    }
}

int main(int argc, char* argv[])
{
    // read from command line
    unsigned long long int ciphertext = atoi(argv[1]); // value of c
    unsigned long long int modulus = atoi(argv[2]); // value of n

    // initialize parameters
    clock_t start, end;

    //start timing
    start = clock();

    size_t size = modulus * sizeof(unsigned long long int);

    // Allocate input vectors h_A in host memory
    unsigned long long int* host_vec = (unsigned long long int*)malloc(size);

    // Allocate vectors in device memory
    unsigned long long int* dev_vec;
    cudaMalloc(&dev_vec, size);

    // Copy vectors from host memory to device memory
    cudaMemcpy(dev_vec, host_vec, size, cudaMemcpyHostToDevice);

    // initialize the count of possible values
    possible_msg = 0;

    // Run kernel on the GPU
    int blockSize = 256;
    int numBlocks = (modulus + blockSize - 1) / blockSize;
    evaluate<<<numBlocks, blockSize>>>(ciphertext, modulus, dev_vec);

    // Wait for GPU to finish before accessing on host
    cudaDeviceSynchronize();


    if(possible_msg == 0) {

        printf("No cube roots of %lld (mod %lld)\n", ciphertext, modulus);

    } else {

        // Copy result from device memory to host memory
        cudaMemcpy(host_vec, dev_vec, size, cudaMemcpyDeviceToHost);

        // print results
        printf("There are %d possible messages which encryption give %lld\n",
                                                        possible_msg, ciphertext);
        print_result(host_vec, ciphertext, modulus);
    }

    // get stop time
    end = clock();
    double time_taken = double(end - start) / double(CLOCKS_PER_SEC);
    cout << "Breaking RSA GPU version 1 computation time : " << fixed
         << time_taken;
    cout << " seconds\n" << endl;

    // Free memory
    cudaFree(dev_vec);
    delete host_vec;
    return 0;
}

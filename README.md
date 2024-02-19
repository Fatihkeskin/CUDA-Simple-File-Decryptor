# Simple File Decryptor

This code is a simple file decryptor. The program reads a file named encodedfile.txt and decrypts the encrypted message inside it. The encrypted message is stored in a comma-separated format. 
Firstly, the file is read serially, and the encrypted message is identified. Then, this encrypted message is decrypted and written to a file named decoded.txt.

There's also a parallel version of the code. The parallel version is implemented using the CUDA library to take advantage of GPU parallelism for faster processing. 
However, the parallel section of the code is currently commented out (CudaReadFile function and related CUDA directive commands). Enabling this section would allow the decryption process to be performed in parallel on the GPU.

## Usage

1. Open the project in a C CUDA development environment.
2. First, place the encrypted file named `encodedfile.txt` in the root directory of the project.
3. Compile and run the program.

## Parallel Version

The parallel version of the decryption algorithm utilizes CUDA to take advantage of GPU parallelism for faster processing.

## Notes

- Make sure you have the CUDA toolkit installed and configured properly to compile and run the parallel version.
- The decrypted message will be written to a file named `decoded.txt` in the project directory.


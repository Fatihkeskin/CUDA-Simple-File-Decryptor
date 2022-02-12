#include <stdio.h>
#include <stdlib.h>
#include "device_launch_parameters.h"
#include <cuda.h>
#include <cuda_runtime.h>


//////////////////////////////////////////////////////////////////
//This Part is the parallel version of simple file decryptor
//////////////////////////////////////////////////////////////////
__global__ void CudaReadFile(char *a , int size){

	int pid = blockIdx.x*blockDim.x + threadIdx.x;
	if (pid < size)
		printf("%c", a[pid]);
	return;

}


///////////////////////////////////////////////////////////////////////////////////////////
//This Part(Half of the Main Function) is the serial version of simple file decryptor
///////////////////////////////////////////////////////////////////////////////////////////
int main(int argc, char *argv[])
{

	//Determining the variables which are used
	FILE *file;
	char *special_message;
	char *buffer;
	int fileLen;
	int messageLen;
	


	//Opening the file
	file = fopen("encodedfile.txt", "rb");
	if (!file)
	{
		fprintf(stderr, "Unable to open file %s", "encodedfile.txt");
		return;
	}



	//Calc file length
	fseek(file, 0, SEEK_END);
	fileLen = ftell(file);
	fseek(file, 0, SEEK_SET);



	//Allocation
	messageLen = fileLen * 4;
	buffer = (char*)malloc(fileLen + 1);
	special_message = (char *)malloc(messageLen + 1);
	if (!buffer)
	{
		fprintf(stderr, "Memory error!");
		fclose(file);
		return;
	}


	//Read file contents into buffer
	fread(buffer, fileLen, 1, file);
	fclose(file);



	//Finding the message content
	char special_char = ',';
	int a;
	int special_counter = 0;
	for (a = 0; a < fileLen; a++){
		if (buffer[a] == special_char)
		{
			special_message[special_counter] = buffer[a + 1];
			special_counter++;
		}
	}



	//Writing the Special Message
	FILE *output_pointer = fopen("decoded.txt", "w");
	if (output_pointer == NULL)
	{
		printf("Error opening file!\n");
		exit(1);
	}

	int r;
	for (r = 0; r < special_counter; r++)
	{
		fprintf(output_pointer, "%c", special_message[r]);
	}

	
	////////////////////////////////////////////////////////////////////////////////// Parallel directives
	char *gpuBuffer;
	char *gpuSpecialMessageBuffer;

	cudaMalloc(&gpuBuffer, fileLen+1);
	cudaMalloc(&gpuSpecialMessageBuffer, messageLen+1);

	cudaMemcpy(gpuBuffer, buffer, fileLen*sizeof(char), cudaMemcpyHostToDevice);
	cudaMemcpy(gpuSpecialMessageBuffer, special_message, fileLen*sizeof(char), cudaMemcpyHostToDevice);

	//CudaReadFile << <60, 256 >> >(gpuBuffer, fileLen);

	//cudaMemcpy(gpuBuffer, gpuSpecialMessageBuffer, fileLen*sizeof(char), cudaMemcpyDeviceToHost);
	//cudaDeviceSynchronize();
	free(buffer);
	free(special_message);

	cudaFree(gpuBuffer);
	cudaFree(gpuSpecialMessageBuffer);

	return 0;

}//End of main

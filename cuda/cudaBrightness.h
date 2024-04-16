

#ifndef __CUDA_BRIGHTNESS_H__
#define __CUDA_BRIGHTNESS_H__


#include "cudaUtility.h"

#include "imageFormat.h"

cudaError_t cudaBrightness(uint8_t* input,  size_t inputWidth,  size_t inputHeight,int width, int height, int channels, float brightness_factor);

cudaError_t cudaBrightness( float* input,  size_t inputWidth,  size_t inputHeight,int width, int height, int channels, float brightness_factor);

// cudaError_t cudaBrightness( float4* input, int width, int height, int channels, float brightness_factor);

// cudaError_t cudaBrightness( float3* input, int width, int height, int channels, float brightness_factor);


// cudaError_t cudaBrightness( uchar4* input, int width, int height, int channels, float brightness_factor);

// cudaError_t cudaBrightness( uchar3* input, int width, int height, int channels, float brightness_factor);

cudaError_t cudaBrightness( void* input,  size_t inputWidth,  size_t inputHeight,int width, int height, int channels, float brightness_factor,
				    imageFormat format);


#endif
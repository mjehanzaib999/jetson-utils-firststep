#include "cudaBrightness.h"

template<typename T>
__global__ void increaseBrightness(T* image, int width, int height, int channels, float brightness_factor) {
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;
    
    if (x < width && y < height) {
        int index = (y * width + x) * channels;

        // Add brightness to each pixel component (R, G, B)
        for (int c = 0; c < channels; ++c) {
            int newValue = image[index + c] * brightness_factor;
            // Ensure the pixel value stays qwithin the range [0, 255]
            image[index + c] = min(max(newValue, 0), 255);
        }
    }
}


// launchResize
template<typename T>
static cudaError_t launchBrightness( T* input, size_t input_Width, size_t input_Height, int width, int height, int channels, float brightness_factor)
{
	if( !input )
		return cudaErrorInvalidDevicePointer;

	if( input_Width == 0 || input_Height == 0 )
		return cudaErrorInvalidValue;

    // Calculate grid and block sizes
    const dim3 blockDim(8, 8);
    dim3 gridDim(iDivUp(input_Width,blockDim.x), iDivUp(input_Height,blockDim.y));

    // Launch the kernel
    increaseBrightness<T><<<gridDim, blockDim>>>(input, width, height, channels, brightness_factor);


	return CUDA(cudaGetLastError());
}

// cudaResize (uint8 grayscale)
cudaError_t cudaBrightness( uint8_t* input, size_t input_Width, size_t input_Height, int width, int height, int channels, float brightness_factor)
{
	return launchBrightness<uint8_t>(input, input_Width, input_Height, width, height, channels, brightness_factor);
}

// // cudaResize (uchar3 grayscale)
// cudaError_t cudaBrightness( uchar3* input, int width, int height, int channels, float brightness_factor)
// {
// 	return launchBrightness<uchar3>(input, width, height, channels, brightness_factor);
// }

// // cudaResize (uchar3 grayscale)
// cudaError_t cudaBrightness( uchar4* input, int width, int height, int channels, float brightness_factor)
// {
// 	return launchBrightness<uchar4>(input, width, height, channels, brightness_factor);
// }

// // cudaResize (uchar3 grayscale)
// cudaError_t cudaBrightness( float3* input, int width, int height, int channels, float brightness_factor)
// {
// 	return launchBrightness<float3>(input, width, height, channels, brightness_factor);
// }

// // cudaResize (uchar3 grayscale)
// cudaError_t cudaBrightness( float4* input, int width, int height, int channels, float brightness_factor)
// {
// 	return launchBrightness<float4>(input, width, height, channels, brightness_factor);
// }


// cudaResize (float grayscale)
cudaError_t cudaBrightness( float* input, size_t input_Width, size_t input_Height, int width, int height, int channels, float brightness_factor)
{
	return launchBrightness<float>(input, width,input_Width, input_Height,  height, channels, brightness_factor);
}

//-----------------------------------------------------------------------------------
cudaError_t cudaBrightness( void* input, size_t input_Width, size_t input_Height, int width, int height, int channels, float brightness_factor,
				    imageFormat format)
{
	if( format == IMAGE_RGB8 || format == IMAGE_BGR8 )
        return cudaBrightness((uint8_t*)input, input_Width, input_Height, width, height, channels, brightness_factor);
		//return cudaBrightness((uchar3*)input, width, height, channels, brightness_factor);
	// else if( format == IMAGE_RGBA8 || format == IMAGE_BGRA8 )
	// 	return cudaBrightness((uchar4*)input, width, height, channels, brightness_factor);
	else if( format == IMAGE_RGB32F || format == IMAGE_BGR32F )
		return cudaBrightness((float*)input,input_Width, input_Height,  width, height, channels, brightness_factor);
	else if( format == IMAGE_RGBA32F || format == IMAGE_BGRA32F )
		return cudaBrightness((float*)input,input_Width, input_Height,  width, height, channels, brightness_factor);
	else if( format == IMAGE_GRAY8 )
		return cudaBrightness((uint8_t*)input,input_Width, input_Height,  width, height, channels, brightness_factor);
	else if( format == IMAGE_GRAY32F )
		return cudaBrightness((float*)input, input_Width, input_Height, width, height, channels, brightness_factor);

	LogError(LOG_CUDA "cudaBrightness() -- invalid image format '%s'\n", imageFormatToStr(format));
	LogError(LOG_CUDA "                supported formats are:\n");
	LogError(LOG_CUDA "                    * gray8\n");
	LogError(LOG_CUDA "                    * gray32f\n");
	LogError(LOG_CUDA "                    * rgb8, bgr8\n");
	LogError(LOG_CUDA "                    * rgba8, bgra8\n");
	LogError(LOG_CUDA "                    * rgb32f, bgr32f\n");
	LogError(LOG_CUDA "                    * rgba32f, bgra32f\n");

	return cudaErrorInvalidValue;
}
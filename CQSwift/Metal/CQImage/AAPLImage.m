/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implementation of a very simple container for image data
*/

#import "AAPLImage.h"
#include <simd/simd.h>
@implementation AAPLImage

-(nullable instancetype) initWithTGAFileAtLocation:(nonnull NSURL *)tgaLocation
{
    self = [super init];
    if(self)
    {
        NSString * fileExtension = tgaLocation.pathExtension;
        
        if(!([fileExtension caseInsensitiveCompare:@"TGA"] == NSOrderedSame))
        {
            NSLog(@"This image loader only loads TGA files");
            return nil;
        }
        
        // The structure describes the layout of a TGA header containing image metadata.
        typedef struct __attribute__ ((packed)) TGAHeader
        {
            // The size of the ID info following the header.
            // 1字节无符号整型(uint32_t 占4字节)。表示图像信息字段长度，取值范围0-255。
            // 为0时表示没有图像信息字段
            uint8_t  IDSize;
            
            // Determines whether this is a paletted image.
            // 1字节无符号整型。
            // 颜色表类型：0表示没有颜色表，1表示有颜色表。
            // TGA格式是无颜色表的
            uint8_t  colorMapType;
            
            // The type of image: 0=none, 1=indexed, 2=rgb, 3=grey, +8=rle packed.
            // 1字节无符号整型。
            // 图像类型码。2:非压缩RGB格式
            uint8_t  imageType;
            
            // The offset to the color map in the palette.
            // 颜色表首址，2字节无符号整型。
            int16_t  colorMapStart;
            
            // The mumber of colors in the palette.
            // 颜色表长度，颜色表表项的数量
            int16_t  colorMapLength;
            
            // The number of bits per palette entry.
            // 每个表项占用的位数，典型值有15、16、24或32位
            uint8_t  colorMapBpp;
            
            // The x Origin pixel of lower left corner if this file is a tile from a larger image.
            // 图像x位置的起始位置。图像左下角的水平坐标。
            uint16_t xOrigin;
            // The y Origin pixel of lower left corner if this file is a tile from a larger image
            // 图像y位置的起始位置。图像左下角的垂直坐标。
            uint16_t yOrigin;
            // The width in pixels.
            // 图像宽度
            uint16_t width;
            // The height in pixels.
            // 图像高度
            uint16_t height;
            // The bits per pixel. 8,16,24,32.
            // 每像素的占用几位。8,16,24,32.
            uint8_t  bitsPerPixel;
            
            // 图像描述符：
            /* 例：0000 0000
             0-3位：规定每个像素属性位的数量
                        TGA 16: 该值为0或1
                        TGA 24: 该值为0
                        TGA 32: 该值为8
             4-5位：表示像素数据从文件发送到屏幕的顺序，位4表示从左到右，位5表示从上到下，如下所示：
                                             Bit 5   Bit 4
             从下到上，从左到右   0      0
             从下到上，从右到左   0      1
             从上到下，从左到右   1      0
             从上到下，从右到左   1      1
             */
            union {
                struct
                {
                    uint8_t bitsPerAlpha : 4;
                    uint8_t rightOrigin  : 1;
                    uint8_t topOrigin    : 1;
                    uint8_t reserved     : 2;
                };
                uint8_t descriptor;
            };
        } TGAHeader;
        
        NSError * error;
        
        // Copy the entire file to this fileData variable.
        NSData *fileData = [[NSData alloc] initWithContentsOfURL:tgaLocation
                                                         options:0x0
                                                           error:&error];
        
        if (!fileData)
        {
            NSLog(@"Could not open TGA File:%@", error.localizedDescription);
            return nil;
        }
        
        TGAHeader *tgaInfo = (TGAHeader *) fileData.bytes;
        //imageType：2表示非压缩RGB格式（只支持非压缩RGB格式）
        if(tgaInfo->imageType != 2)
        {
            NSLog(@"This image loader only supports non-compressed BGR(A) TGA files");
            return nil;
        }
        
        // TGA 格式没有颜色表，colorMapType正常应该为0
        if(tgaInfo->colorMapType)
        {
            NSLog(@"This image loader doesn't support TGA files with a colormap");
            return nil;
        }
        
        // 此图像加载器不支持具有非零原点的TGA文件
        if(tgaInfo->xOrigin || tgaInfo->yOrigin)
        {
            NSLog(@"This image loader doesn't support TGA files with a non-zero origin");
            return nil;
        }
        
        NSUInteger srcBytesPerPixel;
        if(tgaInfo->bitsPerPixel == 32) // 每像素32位
        {
            srcBytesPerPixel = 4; // 4字节
            
            if(tgaInfo->bitsPerAlpha != 8)
            {
                NSLog(@"This image loader only supports 32-bit TGA files with 8 bits of alpha");
                return nil;
            }
            
        }
        else if(tgaInfo->bitsPerPixel == 24) // 每像素24位
        {
            srcBytesPerPixel = 3; //3字节
            
            if(tgaInfo->bitsPerAlpha != 0)
            {
                NSLog(@"This image loader only supports 24-bit TGA files with no alpha");
                return nil;
            }
        }
        else
        {
            NSLog(@"This image loader only supports 24-bit and 32-bit TGA files");
            return nil;
        }
        
        _width = tgaInfo->width;
        _height = tgaInfo->height;
        
        // The image data is stored as 32-bits-per-pixel BGRA data.
        NSUInteger dataSize = _width * _height * 4;

        // Metal won't understand an image with 24-bit BGR format so the pixels
        // are converted to a 32-bit BGRA format that Metal does understand
        // (MTLPixelFormatBGRA8Unorm).
        // 把 24-bit BGR 转为 32-bit BGRA格式

        NSMutableData *mutableData = [[NSMutableData alloc] initWithLength:dataSize];

        // The TGA specification says the image data starts immediately after the header and
        // ID, so the code calculates a pointer to that location.
        // Initialize a source pointer with the source image data that's in BGR
        // form.
        // TGA规范表示图像数据在标题(header)和ID之后立即开始，
        // 因此代码计算指向该位置的指针。
        // 使用BGR形式的源图像数据初始化源指针。
      
        uint8_t *srcImageData = ((uint8_t*)fileData.bytes +
                                 sizeof(TGAHeader) +
                                 tgaInfo->IDSize);

        // Initialize a destination pointer to which you'll store the converted BGRA
        // image data.
        uint8_t *dstImageData = mutableData.mutableBytes;

        // Process every row of the image.
        // 处理每一行
        for(NSUInteger y = 0; y < _height; y++)
        {
            // If bit 5 of the descriptor isn't set, flip vertically
            // to transform the data to Metal's top-left texture origin.
            // 转换为Metal的左上角为纹理原点。
            
            // 第5位表示y的方向
            // 0:表示y方向上的原点在最下面 （需要转换）
            // 1:表示y方向上的原点在最上面 （不需要转换）
            NSUInteger srcRow = (tgaInfo->topOrigin) ? y : _height - 1 - y;

            // Process every column of the current row.
            // 处理当前行的每一列
            for(NSUInteger x = 0; x < _width; x++)
            {
                // If bit 4 of the descriptor is set, flip horizontally
                // to transform the data to Metal's top-left texture origin.
                // 转换为Metal的左上角为纹理原点。
                
                // 第4位表示x的方向
                // 0:表示x方向上的原点在最左面 （不需要转换）
                // 1:表示x方向上的原点在最右面 （需要转换）
                NSUInteger srcColumn = (tgaInfo->rightOrigin) ? _width - 1 - x : x;

                // Calculate the index for the first byte of the pixel you're
                // converting in both the source and destination images.
                // 计算源图像和目标图像中要转换的像素的第一个字节的索引。
                NSUInteger srcPixelIndex = srcBytesPerPixel * (srcRow * _width + srcColumn);
                // 目标图像固定每像素为4个字节，所以写死4
                NSUInteger dstPixelIndex = 4 * (y * _width + x);

                // Copy BGR channels from the source to the destination.
                // 将BGR通道从源复制到目标。
                // Set the alpha channel of the destination pixel to 255.
                // 将目标像素的alpha通道设置为255。
                dstImageData[dstPixelIndex + 0] = srcImageData[srcPixelIndex + 0];
                dstImageData[dstPixelIndex + 1] = srcImageData[srcPixelIndex + 1];
                dstImageData[dstPixelIndex + 2] = srcImageData[srcPixelIndex + 2];

                if(tgaInfo->bitsPerPixel == 32)
                {
                    dstImageData[dstPixelIndex + 3] =  srcImageData[srcPixelIndex + 3];
                }
                else
                {
                    dstImageData[dstPixelIndex + 3] = 255;
                }
            }
        }
        _data = mutableData;
    }
    
    return self;
}

@end

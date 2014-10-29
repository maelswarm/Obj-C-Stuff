- (void)asciiEFT {
    
    [self.spinningGear startAnimating];
    
    dispatch_queue_t myNewQ = dispatch_queue_create("my Queue", NULL);
    
    dispatch_async(myNewQ, ^{
        
        asciiType = self.slider1.value;
        asciiSize = self.slider2.value;
        
        [[self.parS mutableString]setString:@""];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textImage.text = @"";
        });
        
        float fontSize = 0.0f;
        
        NSLog(@"%f, %f", self.origim.size.width, self.origim.size.height);
        
        CGImageRef sourceImage = self.origim.CGImage;
        CFDataRef theData;
        theData = CGDataProviderCopyData(CGImageGetDataProvider(sourceImage));
        
        UInt8 *pixelData = (UInt8 *) CFDataGetBytePtr(theData);
        
        long dataLength = CFDataGetLength(theData);
        NSLog(@"%li", dataLength);
        
        int newHeight = (int) 50.0 * floor(((700*(self.origim.size.height/self.origim.size.width))/50.0)+0.5);
        NSLog(@"New Height: %i", newHeight);
        NSLog(@"Image Width: %f Image Height: %f", self.origim.size.width, self.origim.size.height);
        // create context, keeping original image properties
        CGColorSpaceRef colorspace = CGImageGetColorSpace(sourceImage);
        NSLog(@"Colorspace: %@", CGImageGetColorSpace(sourceImage));
        CGContextRef context = CGBitmapContextCreate(NULL, 700, newHeight,
                                                     CGImageGetBitsPerComponent(sourceImage),
                                                     2800,
                                                     colorspace,
                                                     kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
        
        CGContextDrawImage(context, CGRectMake(0, 0, 700, newHeight), sourceImage);
        NSLog(@"Context: %@", context);
        CGColorSpaceRelease(colorspace);
        
        if (asciiSize < 0.5f) {
            self.style.maximumLineHeight = 4.15286f;
            characterAmount = 10.0f;
            fontSize = 6.9f;
        }
        if (asciiSize > .5f) {
            self.style.maximumLineHeight = 5.8f;
            characterAmount = 14.0f;
            fontSize = 9.5f;
        }
        
        if (asciiType < 0.5f) {
            [self setDefaultStrings];
        }
        
        if (asciiType > .5f) {
            [self setPixelStrings];
        }
        
        // extract resulting image from context
        
        sourceImage = CGBitmapContextCreateImage(context);
        
        UIImage *tempImage = [UIImage imageWithCGImage:sourceImage];
        NSLog(@"Image Width: %f Image Height: %f", tempImage.size.width, tempImage.size.height);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.theimage.image = tempImage;
        });
        
        CGContextRelease(context);
        CFRelease(theData);
        
        NSLog(@"%f,%f", tempImage.size.width, tempImage.size.height);
        
        
        sourceImage = tempImage.CGImage;
        theData = CGDataProviderCopyData(CGImageGetDataProvider(sourceImage));
        
        pixelData = (UInt8 *) CFDataGetBytePtr(theData);
        
        dataLength = CFDataGetLength(theData);
        NSLog(@"%li", dataLength);
        //    NSLog(@"%f", self.imageView.image.size.width*4*self.imageView.image.size.height);
        
        int red = 0;
        int green = 1;
        int blue = 2;
        
        float mainVar = 4*4.0f;
        int u = 0;
        
        for (int h = 0; h < (tempImage.size.height/characterAmount); h++) {
            
            for (int w = 0; w < tempImage.size.width/characterAmount; w++) {
                float total = 0;
                
                for (int hf = 0; hf < 4; hf++) {
                    
                    for (int wf = 0; wf < 4; wf++) {
                        
                        int temp = (tempImage.size.width*h*characterAmount*4)+(w*characterAmount*4)+(tempImage.size.width*hf*4)+(wf*4);
                        
                        if (temp > dataLength) {
                            NSLog(@"break");
                            break;
                        }
                        
                        total += ((pixelData[temp + red]/255.0f) + (pixelData[temp + blue]/255.0f) + (pixelData[temp + green]/255.0f));
                    }
                }
                @autoreleasepool {
                    
                    if (total > mainVar*2.8f) {
                        [self.parS appendAttributedString:self.strTemp1];
                    }
                    
                    else if (total > mainVar*2.7f) {
                        [self.parS appendAttributedString:self.strTemp2];
                    }
                    
                    else if (total > mainVar*2.6f) {
                        [self.parS appendAttributedString:self.strTemp3];
                    }
                    
                    else if (total > mainVar*2.65f) {
                        [self.parS appendAttributedString:self.strTemp4];
                    }
                    
                    else if (total > mainVar*2.5f) {
                        [self.parS appendAttributedString:self.strTemp5];
                    }
                    
                    else if (total > mainVar*2.35f) {
                        [self.parS appendAttributedString:self.strTemp6];
                    }
                    else if (total > mainVar*2.15f) {
                        [self.parS appendAttributedString:self.strTemp7];
                    }
                    
                    else if (total > mainVar*2.0f) {
                        [self.parS appendAttributedString:self.strTemp8];
                    }
                    
                    else if (total > mainVar*1.8f) {
                        [self.parS appendAttributedString:self.strTemp9];
                    }
                    
                    else if (total > mainVar*1.6f) {
                        [self.parS appendAttributedString:self.strTemp10];
                    }
                    
                    else if (total > mainVar*1.4f) {
                        [self.parS appendAttributedString:self.strTemp11];
                    }
                    
                    else if (total > mainVar*1.0f) {
                        [self.parS appendAttributedString:self.strTemp12];
                    }
                    
                    else if (total > mainVar*.6f) {
                        [self.parS appendAttributedString:self.strTemp13];
                    }
                    
                    else if (total > mainVar*.4f) {
                        [self.parS appendAttributedString:self.strTemp14];
                    }
                    
                    else if (total >= 0) {
                        [self.parS appendAttributedString:self.strTemp15];
                    }
//                    u++;
//                    NSLog(@"%i", u);
                }
                total = 0;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.textImage.attributedText = self.parS;
            self.textImage.font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:fontSize];
            
            NSLog(@"%f", self.textImage.frame.size.height);
            NSLog(@"%f", tempImage.size.height);
            
            CGRect frame = self.textImage.frame;
            frame.size.height = self.textImage.frame.size.width*(tempImage.size.height/tempImage.size.width);
            self.textImage.frame = frame;
            
            NSLog(@"%f", self.textImage.frame.size.height);
            
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.textImage.viewForBaselineLayout.bounds.size.width - 4, self.textImage.viewForBaselineLayout.bounds.size.height), NO, 2.0f);
            [self.textImage.viewForBaselineLayout.layer renderInContext:UIGraphicsGetCurrentContext()];
            self.theimage.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            CGImageRelease(sourceImage);
            [self.spinningGear stopAnimating];
            
        });
    });
}

- (void)setPixelStrings {
    
    self.strTemp15 = nil;
    self.strTemp15 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x2261]];
    [self.strTemp15 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.25f alpha:1.0f] range:NSMakeRange(0, self.strTemp15.length)];
    [self.strTemp15 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp15.length)];
    
    self.strTemp14 = nil;
    self.strTemp14 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x2261]];
    [self.strTemp14 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.3f alpha:1.0f] range:NSMakeRange(0, self.strTemp14.length)];
    [self.strTemp14 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp14.length)];
    
    self.strTemp13 = nil;
    self.strTemp13 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x2261]];
    [self.strTemp13 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.32f alpha:1.0f] range:NSMakeRange(0, self.strTemp13.length)];
    [self.strTemp13 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp13.length)];
    
    self.strTemp12 = nil;
    self.strTemp12 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x2591]];
    [self.strTemp12 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.36f alpha:1.0f] range:NSMakeRange(0, self.strTemp12.length)];
    [self.strTemp12 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp12.length)];
    
    self.strTemp11 = nil;
    self.strTemp11 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x2591]];
    [self.strTemp11 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.4f alpha:1.0f] range:NSMakeRange(0, self.strTemp11.length)];
    [self.strTemp11 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp11.length)];
    
    self.strTemp10 = nil;
    self.strTemp10 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x2591]];
    [self.strTemp10 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.44f alpha:1.0f] range:NSMakeRange(0, self.strTemp10.length)];
    [self.strTemp10 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp10.length)];
    
    self.strTemp9 = nil;
    self.strTemp9 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x2591]];
    [self.strTemp9 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.48f alpha:1.0f] range:NSMakeRange(0, self.strTemp9.length)];
    [self.strTemp9 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp9.length)];
    
    self.strTemp8 = nil;
    self.strTemp8 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x2591]];
    [self.strTemp8 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.52f alpha:1.0f] range:NSMakeRange(0, self.strTemp8.length)];
    [self.strTemp8 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp8.length)];
    
    self.strTemp7 = nil;
    self.strTemp7 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x2592]];
    [self.strTemp7 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.56f alpha:1.0f] range:NSMakeRange(0, self.strTemp7.length)];
    [self.strTemp7 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp7.length)];
    
    self.strTemp6 = nil;
    self.strTemp6 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x2592]];
    [self.strTemp6 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.6f alpha:1.0f] range:NSMakeRange(0, self.strTemp6.length)];
    [self.strTemp6 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp6.length)];
    
    self.strTemp5 = nil;
    self.strTemp5 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x2593]];
    [self.strTemp5 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.66f alpha:1.0f] range:NSMakeRange(0, self.strTemp5.length)];
    [self.strTemp5 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp5.length)];
    
    self.strTemp4 = nil;
    self.strTemp4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x2593]];
    [self.strTemp4 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.72f alpha:1.0f] range:NSMakeRange(0, self.strTemp4.length)];
    [self.strTemp4 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp4.length)];
    
    self.strTemp3 = nil;
    self.strTemp3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x2593]];
    [self.strTemp3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.8f alpha:1.0f] range:NSMakeRange(0, self.strTemp3.length)];
    [self.strTemp3 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp3.length)];
    
    self.strTemp2 = nil;
    self.strTemp2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x2588]];
    [self.strTemp2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.85f alpha:1.0f] range:NSMakeRange(0, self.strTemp2.length)];
    [self.strTemp2 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp2.length)];
    
    self.strTemp1 = nil;
    self.strTemp1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x2588]];
    [self.strTemp1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:1.0f alpha:1.0f] range:NSMakeRange(0, self.strTemp1.length)];
    [self.strTemp1 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp1.length)];
    
}

- (void) setDefaultStrings {
    
    self.strTemp15 = nil;
    self.strTemp15 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x002E]];
    [self.strTemp15 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.25f alpha:1.0f] range:NSMakeRange(0, self.strTemp15.length)];
    [self.strTemp15 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp15.length)];
    
    self.strTemp14 = nil;
    self.strTemp14 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x003A]];
    [self.strTemp14 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.3f alpha:1.0f] range:NSMakeRange(0, self.strTemp14.length)];
    [self.strTemp14 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp14.length)];
    
    self.strTemp13 = nil;
    self.strTemp13 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x0069]];
    [self.strTemp13 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.32f alpha:1.0f] range:NSMakeRange(0, self.strTemp13.length)];
    [self.strTemp13 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp13.length)];
    
    self.strTemp12 = nil;
    self.strTemp12 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x006E]];
    [self.strTemp12 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.36f alpha:1.0f] range:NSMakeRange(0, self.strTemp12.length)];
    [self.strTemp12 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp12.length)];
    
    self.strTemp11 = nil;
    self.strTemp11 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x0073]];
    [self.strTemp11 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.4f alpha:1.0f] range:NSMakeRange(0, self.strTemp11.length)];
    [self.strTemp11 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp11.length)];
    
    self.strTemp10 = nil;
    self.strTemp10 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x00E6]];
    [self.strTemp10 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.44f alpha:1.0f] range:NSMakeRange(0, self.strTemp10.length)];
    [self.strTemp10 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp10.length)];
    
    self.strTemp9 = nil;
    self.strTemp9 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x0068]];
    [self.strTemp9 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.48f alpha:1.0f] range:NSMakeRange(0, self.strTemp9.length)];
    [self.strTemp9 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp9.length)];
    
    self.strTemp8 = nil;
    self.strTemp8 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x006D]];
    [self.strTemp8 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.52f alpha:1.0f] range:NSMakeRange(0, self.strTemp8.length)];
    [self.strTemp8 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp8.length)];
    
    self.strTemp7 = nil;
    self.strTemp7 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x0070]];
    [self.strTemp7 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.56f alpha:1.0f] range:NSMakeRange(0, self.strTemp7.length)];
    [self.strTemp7 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp7.length)];
    
    self.strTemp6 = nil;
    self.strTemp6 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x0062]];
    [self.strTemp6 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.6f alpha:1.0f] range:NSMakeRange(0, self.strTemp6.length)];
    [self.strTemp6 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp6.length)];
    
    self.strTemp5 = nil;
    self.strTemp5 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x0176]];
    [self.strTemp5 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.66f alpha:1.0f] range:NSMakeRange(0, self.strTemp5.length)];
    [self.strTemp5 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp5.length)];
    
    self.strTemp4 = nil;
    self.strTemp4 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x0051]];
    [self.strTemp4 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.72f alpha:1.0f] range:NSMakeRange(0, self.strTemp4.length)];
    [self.strTemp4 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp4.length)];
    
    self.strTemp3 = nil;
    self.strTemp3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x00AE]];
    [self.strTemp3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.8f alpha:1.0f] range:NSMakeRange(0, self.strTemp3.length)];
    [self.strTemp3 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp3.length)];
    
    self.strTemp2 = nil;
    self.strTemp2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x00A9]];
    [self.strTemp2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.85f alpha:1.0f] range:NSMakeRange(0, self.strTemp2.length)];
    [self.strTemp2 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp2.length)];
    
    self.strTemp1 = nil;
    self.strTemp1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%C", (unichar)0x0040]];
    [self.strTemp1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:1.0f alpha:1.0f] range:NSMakeRange(0, self.strTemp1.length)];
    [self.strTemp1 addAttribute:NSParagraphStyleAttributeName value:self.style range:NSMakeRange(0, self.strTemp1.length)];
    
}

- (void)spinWheelAnimate {
    [self.spinningGear startAnimating];
    
}

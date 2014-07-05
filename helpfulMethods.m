- (void)loadImageFromIndex:(int)index withAssetLibrary:(ALAssetsLibrary*)library {
    
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        // Within the group enumeration block, filter to enumerate your photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        //if index exceeds bounds, kill the method
        if (index < 0 || index > [group numberOfAssets]-1) {
            return;
        }
        
        // Chooses the photo at the index
        [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:index] options:0 usingBlock:^(ALAsset *alAsset, NSUInteger inde, BOOL *innerStop) {
            // The end of the enumeration is signaled by asset == nil.
            
            if (alAsset) {
                ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                UIImage *tempImage = [UIImage imageWithCGImage:[representation fullScreenImage]];
                image1 = tempImage;
                
                // Either this...
                    self.imageView.image = image1;
                //Or see below //@@@//
         
            }
        }];
    }
     
    failureBlock: ^(NSError *error) {
        NSLog(@"None");
    }];
}

// Either this...
    [self loadImageFromIndex:num withAssetLibrary:lib];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView.image = image1;
    });
//Or see above //@@@//



- (BOOL)isThis:(float)this islessThan:(float)upLim andGreaterThan:(float)lowLim {
    if (this < upLim && this > lowLim) {
        return YES;
    }
    else {
        return NO;
    }
}

- (float)factorialOf:(float)input {
    float val = input;
    if (val == 0) {
        return 1;
    }
    
    while (input-1 > 0) {
        val *=(input-=1);
    }
    return val;
}

- (int)permNoRepNValue:(int)n rValue:(int)r {
    int value = [self factorialOf:n]/[self factorialOf:(n-r)];

    return value
}

- (bool)isPrime:(int)n {
    if (((n/2)+(n/2) == n) || ((n/3)+(n/3) == n)){
        return false;
    }
    
    return true;
}

- (long)fibonAtN:(int)n {
    long a = 1;
    long b = 2;
    for (int i = 0; i < n+1; i++) {
        if (i+1 == n) {
        return b;
        }
        long temp = b;
        b += a;
        a = temp;
    }
}



- (void)revDivNumGen {
    NSMutableArray *arr = [NSMutableArray new];
    long long num = 108;
    long long origNum = num;
    
    for (int i = 1; i < 200; i++) {
        
        long long cc = 0;
        
        if ((i%2) == 0) {
            num = llabs(num);
            while (num>0)
            {
                cc = cc * 10 + (num%10);
                num = num / 10;
            }
            origNum +=cc;
        }
        else {
            num = llabs(num);
            while (num>0)
            {
                cc = cc * 10 + (num%10);
                num = num / 10;
            }
            origNum -=cc;
        }
        num = origNum;
        [arr addObject:[NSNumber numberWithLongLong:llabs(num)]];
    }
    NSLog(@"%@", arr);
}

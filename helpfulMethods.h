- (BOOL)this:(float)this islessthan:(float)lowLim andGreaterThan:(float)uplim {
    if (this < uplim && this > lowLim) {
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

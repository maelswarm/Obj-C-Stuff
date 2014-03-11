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
    while (input-1 > 0) {
        val *=(input-=1);
    }
    return val;
}

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

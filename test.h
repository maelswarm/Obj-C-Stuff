- (BOOL)this:(float)this islessthan:(float)lowLim andGreaterThan:(float)uplim {
    if (this < uplim && this > lowLim) {
        return YES;
    }
    else {
        return NO;
    }
}

#import <UIKit/UIKit.h>

@interface MTMaterialLayer : CALayer
@property (nonatomic, copy, readwrite) NSString *recipeName;
@property (atomic, assign, readonly) CGRect visibleRect;
@end

@interface CALayer ()
@property (atomic, assign, readwrite) id unsafeUnretainedDelegate;
@end

CGFloat calculatedRadius(CGRect visibleRect, CGFloat radius) {
    CGFloat width = visibleRect.size.width;
    CGFloat height = visibleRect.size.height;

    if (CGSizeEqualToSize(visibleRect.size, [UIScreen mainScreen].bounds.size) || width <= 60 || height <= 60) {
        return radius;
    }

    if (width > 100 || height > 100) {
        return radius;
    }

    if (fabs(width - height) < 1.0) {
        return floor(MIN(width, height) / 2.0);
    }

    return 25;
}

%hook MTMaterialLayer
- (CGFloat)cornerRadius {
    CGFloat radius = %orig;

    if ([self.recipeName isEqualToString:@"modulesSheer"]) {
        radius = calculatedRadius(self.visibleRect, radius);
    }

    return radius;
}
%end

%hook CALayer
- (CGFloat)cornerRadius {
    CGFloat radius = %orig;

    if ([self.superlayer.unsafeUnretainedDelegate isKindOfClass:NSClassFromString(@"CCUIButtonModuleView")]) {
        radius = calculatedRadius(self.visibleRect, radius);
    }

    return radius;
}
%end

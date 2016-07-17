//
//  ToolbarBackground.m
//  SteadyHoldem1_21
//
//  Created by Mitchell Hooper on 12/21/13.
//  Copyright (c) 2013 Mitchell Hooper. All rights reserved.
//

#import "ToolbarBackground.h"

@implementation ToolbarBackground

-(id) initWithFrame: (CGRect) frame
{
    self = [super initWithFrame: frame];
    
    if (self)
    {
        // Initialization code
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(UIImage*) generateToolbarBackgroundImage
{
    
    // ----------- Define the gradient ----------------------
    CGGradientRef gradient;
    CGColorSpaceRef colorSpace;
    size_t numberOfLocations = 4;
    
    CGFloat locations[4] = {0.0, 0.5, 0.98 ,1.0};
    
    CGFloat components[16] =
    {
        /*
        (84.0f/255.0f), (127.0f/255.0f), (45.0f/255.0f), 1.0,
        (130.0f/255.0f), (203.0f/255.0f), (96.0f/255.0f), 1.0,
        (84.0f/255.0f), (127.0f/255.0f), (45.0f/255.0f), 1.0,
        (255.0f/255.0f), (255.0f/255.0f), (255.0f/255.0f), 0.90  //  white bottom border
        */
        
        (130.0f/255.0f), (203.0f/255.0f), (96.0f/255.0f), 1.0,
        (84.0f/255.0f), (127.0f/255.0f), (45.0f/255.0f), 1.0,
        (130.0f/255.0f), (203.0f/255.0f), (96.0f/255.0f), 1.0,
        (255.0f/255.0f), (255.0f/255.0f), (255.0f/255.0f), 0.90  //  white bottom border
    };
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    gradient = CGGradientCreateWithColorComponents (colorSpace, components,
                                                    locations, numberOfLocations);
    
    
    // Define Gradient Positions ---------------
    
    // We want these exactly at the center of the view
    CGPoint startPoint, endPoint;
    
    // Start point
    startPoint.x = (self.frame.size.width) / 2;
    startPoint.y = 0.0;
    
    // End point
    endPoint.x = (self.frame.size.width) / 2;
    endPoint.y = self.frame.size.height;
    
    // Generate the Image -----------------------
    // Begin an image context
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 0.0);
    CGContextRef imageContext = UIGraphicsGetCurrentContext();
    
    //Use CG to draw the radial gradient into the image context
    //CGContextDrawRadialGradient(imageContext, gradient, startPoint, 0.0, endPoint, self.frame.size.width/s2, 0);
    
    CGContextDrawLinearGradient(imageContext, gradient, startPoint, endPoint, 0);
    
    // Get the image from the context
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    
    return result;
}

@end

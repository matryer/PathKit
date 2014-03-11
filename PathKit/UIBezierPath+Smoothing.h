//
//  UIBezierPath+Smoothing.h
//  PathKit
//
//  from http://www.informit.com/articles/article.aspx?p=1998968&seqNum=9
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (Smoothing)

- (UIBezierPath *) smoothedPath:(int)granularity;

@end

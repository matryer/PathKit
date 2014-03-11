PathKit
=======

PathKit provides path drawing and utilisation capabilities for iOS SpriteKit.

![Example of PathKit in action](Example.png)

## Overview

PathKit lets your users draw paths with their finger.  You can then use the points of the path in your code, or make use of the CGPath capabilities built-in.

### Typical usage

As per the [example code](https://github.com/matryer/PathKit/blob/master/PathKitExample/PathKitExample/MyScene.m), it is recommended that you use `touchesBegan:withEvent:`, `touchesEnd:withEvent:` and `touchesMoved:withEvent:` to allow interactions with your `PKPathNode`.

More advanced users may decide to interact with the `PKPath` directly, but the `PKPathNode` is a SpriteKit friendly `SKShapeNode` that draws the path on the screen for the user.

### Features

#### Tolerance

You are able to specify a tolerance (a `CGSize` describing a grid of tolerances), which represents the minimum distance the point must be away from the previous point in order for a new point to be added to the path.  This helps limit the resolution of paths that can otherwise become memory consuming.  It can also be used to create an interesting effect for paths.

```
self.pathNode = [[PKPathNode alloc] initWithTolerance:CGSizeMake(10, 10)];
```

## Usage

### Creating and adding a PKPathNode

From within a `SKScene`:

```
// make a new path node
PKPathNode *pathNode = [[PKPathNode alloc] initWithTolerance:CGSizeMake(10, 10)];

// use self as the delegate (optional) see below
[pathNode setDelegate:self];

// add the child node to SpriteKit
[self addChild:pathNode];
```

### Adding points

Once you have created your PKPath, adding points in response to user interactions can be achieved by implementing the touchesMoved:withEvent: selector:

```
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  
  // get the location in this SpriteKit scene
  CGPoint touchPosition = [[touches anyObject] locationInNode:self];
  
  // add it to the PKPathNode
  [self.pathNode addPoint:touchPosition];
  
}
```

  * Only points that are far enough away from the previous point will be added (within the specified tolerance.)
  * Whenever points are indeed added and the path has changed, `PKPathNode` will update itself.
  * You may use the `pathNode:makeCGPathForPKPath:` in the delegate if you want to control exactly what sort of path is displayed.

### Resetting the path

Instead of removing the `PKPathNode` from the scene and creating a new one, you may use the `clearPath` method which will release the path from memory and clear the points.

## PKPathNodeDelegate

The `PKPathNodeDelegate` provides optional selectors that you can take advantage of to further customize the behaviour of the PKPathNode.

```
/**
 * Called when the PKPathNode creates a new path.
 * 
 * This is the perfect place to do any additional configuration on the 
 * PKPath before points are added to it.
 */
- (void)pathNode:(PKPathNode *)node didCreateNewPath:(PKPath *)path;

/**
 * Called whenever the path changes.
 */
- (void)pathNode:(PKPathNode *)node didChangePath:(PKPath *)path;

/**
 * Will be called when the PKNodePath needs a CGPathRef for the
 * specified path.  Otherwise, the default path joining all points will be used.
 *
 * PKNodePath will release the returned CGPathRef when it is finished with it.
 */
- (CGPathRef)pathNode:(PKPathNode *)node makeCGPathForPKPath:(PKPath *)path;

/**
 * Will be called if a maximumLength is set on the PKPath and adding a point
 * would have caused the length to exceed it.  The PKPath will adjust the last 
 * point if possible to make it fit wihtin the maximum, or might not add the
 * point at all.
 *
 * At this point, path.length should == path.maximumLength.
 *
 * pathNode:reachedMaximumLengthForPath: will be called every time you add a point
 * that would have taken the length past the maximum.  It is worth checking the
 * PKPathNode.maximumLengthReached property before calling [PKPathNode addPoint:].
 */
- (void)pathNode:(PKPathNode *)node reachedMaximumLengthForPath:(PKPath *)path;
```

## PKPath

#### PKPathChangedBlock

Passing a block to `initWithTolerance:pathChangedBlock:` will cause the block to be called every time there is a significant change to the path, allowing you to take appropriate action.

#### useToleranceAsMaximumDistance = YES

Setting `useToleranceAsMaximumDistance` to `YES` will mean that no two points in the path will be any further away from each other, than the specified tolerance.  This is useful if you want to keep all legs of the path a similar length.

#### snapStartPointToTolerance = YES

Settings `snapStartPointToTolerance` to `YES` will cause the start point to be snapped to the nearest grid point as specified by the tolerance size.  This ensures that your paths will strictly adhear to the grid.

## Troubleshooting

If you're getting `unrecognized selector sent to instance` for `UIBezierPath smoothedPath`, you need to make sure you have set `-all_load` in the *Other Linker Flags* build setting.
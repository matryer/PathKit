PathKit
=======

PathKit provides path drawing capabilities for iOS SpriteKit.

![Example of PathKit in action](Example.png)

## Overview

PathKit lets your users draw paths with their finger.

### Typical usage

As per the [example code](https://github.com/matryer/PathKit/blob/master/PathKitExample/PathKitExample/MyScene.m#L31), it is recommended that you use `touchesBegan:withEvent:`, `touchesEnd:withEvent:` and `touchesMoved:withEvent:` to allow interactions with your `PKPath`.

### Features

#### Tolerance

You are able to specify a tolerance (a `CGSize` describing a grid of tolerances), which represents the minimum distance the finger must travel in order for a new point to be added to the path.  This helps limit the resolution of paths that can otherwise become memory consuming.

#### `PKPathChangedBlock`

Passing a block to `initWithTolerance:pathChangedBlock:` will cause the block to be called every time there is a significant change to the path, allowing you to take appropriate action.

#### `useToleranceAsMaximumDistance = YES`

Setting `useToleranceAsMaximumDistance` to `YES` will mean that no two points in the path will be any further away from each other, than the specified tolerance.  This is useful if you want to keep all legs of the path a similar length.

#### `snapStartPointToTolerance = YES`

Settings `snapStartPointToTolerance` to `YES` will cause the start point to be snapped to the nearest grid point as specified by the tolerance size.  This ensures that your paths will strictly adhear to the grid.

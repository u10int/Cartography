//
//  Distribute.swift
//  Cartography
//
//  Created by Robert Böhnke on 17/02/15.
//  Copyright (c) 2015 Robert Böhnke. All rights reserved.
//

#if os(iOS)
	import UIKit
	#else
	import AppKit
#endif

typealias Accumulator = ([NSLayoutConstraint], LayoutProxy)

private func reduce(first: LayoutProxy, rest: [LayoutProxy], combine: (LayoutProxy, LayoutProxy) -> NSLayoutConstraint) -> [NSLayoutConstraint] {
    rest.last?.view.car_translatesAutoresizingMaskIntoConstraints = false

    return rest.reduce(([], first)) { (acc, current) -> Accumulator in
        let (constraints, previous) = acc

        return (constraints + [ combine(previous, current) ], current)
    }.0
}

/// Distributes multiple views horizontally.
///
/// All views passed to this function will have
/// their `translatesAutoresizingMaskIntoConstraints` properties set to `false`.
///
/// - parameter amount: The distance between the views.
/// - parameter views:  The views to distribute.
///
/// - returns: An array of `NSLayoutConstraint` instances.
///
public func distribute(by amount: CGFloat, horizontally first: LayoutProxy, rest: LayoutProxy...) -> [NSLayoutConstraint] {
	return distribute(by: amount, horizontally: [first] + rest)
}

/// Distributes multiple views horizontally from left to right.
///
/// All views passed to this function will have
/// their `translatesAutoresizingMaskIntoConstraints` properties set to `false`.
///
/// - parameter amount: The distance between the views.
/// - parameter views:  The views to distribute.
///
/// - returns: An array of `NSLayoutConstraint` instances.
///
public func distribute(by amount: CGFloat, leftToRight first: LayoutProxy, rest: LayoutProxy...) -> [NSLayoutConstraint] {
	return distribute(by: amount, leftToRight: [first] + rest)
}

/// Distributes multiple views vertically.
///
/// All views passed to this function will have
/// their `translatesAutoresizingMaskIntoConstraints` properties set to `false`.
///
/// - parameter amount: The distance between the views.
/// - parameter views:  The views to distribute.
///
/// - returns: An array of `NSLayoutConstraint` instances.
///
public func distribute(by amount: CGFloat, vertically first: LayoutProxy, _ rest: LayoutProxy...) -> [NSLayoutConstraint] {
	return distribute(by: amount, vertically: [first] + rest)
}


public func distribute(by amount: CGFloat, inside parent: LayoutProxy? = .None, horizontally views: [LayoutProxy]) -> [NSLayoutConstraint] {
	var constraints: [NSLayoutConstraint] = []
	
	if let parent = parent {
		constraints.append(views.first!.leading == parent.leading + amount)
		constraints.append(views.last!.trailing == parent.trailing - amount)
	}
	
	return constraints + reduce(views.first!, rest: Array(views[1..<views.count])) { $0.trailing == $1.leading - amount }
}

public func distribute(by amount: CGFloat, inside parent: LayoutProxy? = .None, leftToRight views: [LayoutProxy]) -> [NSLayoutConstraint] {
	var constraints: [NSLayoutConstraint] = []
	
	if let parent = parent {
		constraints.append(views.first!.left == parent.left + amount)
		constraints.append(views.last!.right == parent.right - amount)
	}
	
	return constraints + reduce(views.first!, rest: Array(views[1..<views.count])) { $0.trailing == $1.leading - amount }
}

public func distribute(by amount: CGFloat, inside parent: LayoutProxy? = .None, vertically views: [LayoutProxy]) -> [NSLayoutConstraint] {
	var constraints: [NSLayoutConstraint] = []
	
	if let parent = parent {
		constraints.append(views.first!.left == parent.left + amount)
		constraints.append(views.last!.right == parent.right - amount)
	}
	
	return constraints + reduce(views.first!, rest: Array(views[1..<views.count])) { $0.bottom == $1.top - amount }
}

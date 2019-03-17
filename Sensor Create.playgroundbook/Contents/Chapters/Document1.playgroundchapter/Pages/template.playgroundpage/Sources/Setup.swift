// 
//  Setup.swift
//
//  Copyright © 2016-2018 Apple Inc. All rights reserved.
//
import UIKit


public func playgroundPrologue() {
    registerEvaluator(PageAssessment(), style: .discrete)
    assessmentController?.shouldStopPageAfterDiscreteAssessment = false
}


public func playgroundEpilogue() {
    performAssessment()
}

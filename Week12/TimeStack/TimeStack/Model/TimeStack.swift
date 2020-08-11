//
//  TimeStack.swift
//  TimeStack
//
//  Created by Bill Matthews on 2020-08-11.
//  Copyright © 2020 Bill Matthews. All rights reserved.
//

import Foundation

struct TimeStack {
  
  enum TimerState {
    case pending, inProgress, done
  }
  
  enum StackState {
    case solo, first, last, stacked
  }
  
  private let id: UUID
  private var activeTimer: Timer?
  
  private var duration: TimeInterval
  private var elapsed: TimeInterval
  
  private var timerState: TimerState
  private var stackState: StackState
  
  
  
}

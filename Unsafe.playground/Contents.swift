import UIKit
import Foundation

MemoryLayout<Int>.size          // returns 8 (on 64-bit)
MemoryLayout<Int>.alignment     // returns 8 (on 64-bit)
MemoryLayout<Int>.stride        // returns 8 (on 64-bit)

MemoryLayout<Int16>.size        // returns 2
MemoryLayout<Int16>.alignment   // returns 2
MemoryLayout<Int16>.stride      // returns 2

MemoryLayout<Bool>.size         // returns 1
MemoryLayout<Bool>.alignment    // returns 1
MemoryLayout<Bool>.stride       // returns 1

MemoryLayout<Float>.size        // returns 4
MemoryLayout<Float>.alignment   // returns 4
MemoryLayout<Float>.stride      // returns 4

MemoryLayout<Double>.size       // returns 8
MemoryLayout<Double>.alignment  // returns 8
MemoryLayout<Double>.stride     // returns 8

struct EmptyStruct {}

MemoryLayout<EmptyStruct>.size      // returns 0
MemoryLayout<EmptyStruct>.alignment // returns 1
MemoryLayout<EmptyStruct>.stride    // returns 1

struct SampleStruct {
    let number: UInt32
    let flag: Bool
}

MemoryLayout<SampleStruct>.size       // returns 5
MemoryLayout<SampleStruct>.alignment  // returns 4
MemoryLayout<SampleStruct>.stride     // returns 8



let count = 2
let stride = MemoryLayout<Int>.stride
let alignment = MemoryLayout<Int>.alignment
let byteCount = stride * count


do {
    print("Raw pointers")

    let pointer = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: alignment)
    // 4
    defer {
        pointer.deallocate()
    }
    

    pointer.storeBytes(of: 42, as: Int.self)
    pointer.advanced(by: stride).storeBytes(of: 6, as: Int.self)
    pointer.load(as: Int.self)
    pointer.advanced(by: stride).load(as: Int.self)
    

    let bufferPointer = UnsafeRawBufferPointer(start: pointer, count: byteCount)
    for (index, byte) in bufferPointer.enumerated() {
        print("byte \(index): \(byte)")
    }
}

do {
    print("Typed pointers")
    
    let pointer = UnsafeMutablePointer<Int>.allocate(capacity: count)
    pointer.initialize(repeating: 0, count: count)
    defer {
        pointer.deinitialize(count: count)
        pointer.deallocate()
    }
    
    pointer.pointee = 42
    pointer.advanced(by: 1).pointee = 6
    pointer.pointee
    pointer.advanced(by: 1).pointee
    
    let bufferPointer = UnsafeBufferPointer(start: pointer, count: count)
    for (index, value) in bufferPointer.enumerated() {
        print("value \(index): \(value)")
    }
}

do {
    print("Converting raw pointers to typed pointers")
    
    let rawPointer = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: alignment)
    defer {
        rawPointer.deallocate()
    }
    
    let typedPointer = rawPointer.bindMemory(to: Int.self, capacity: count)
    typedPointer.initialize(repeating: 0, count: count)
    defer {
        typedPointer.deinitialize(count: count)
    }
    
    typedPointer.pointee = 42
    typedPointer.advanced(by: 1).pointee = 6
    typedPointer.pointee
    typedPointer.advanced(by: 1).pointee
    
    let bufferPointer = UnsafeBufferPointer(start: typedPointer, count: count)
    for (index, value) in bufferPointer.enumerated() {
        print("value \(index): \(value)")
    }
}


do {

    
    let count = 10
    let stride = MemoryLayout<Int8>.stride
    let alignment = MemoryLayout<Int8>.alignment
    let byteCount = stride * count
    
    let rawPointer = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: alignment)

    
    let typedPointer = rawPointer.bindMemory(to: Int8.self, capacity: count)
    typedPointer.initialize(repeating: 0, count: count)
    defer {
        typedPointer.deinitialize(count: count)
    }
    
    for i in 0..<count {
        typedPointer.advanced(by: i).pointee = Int8(truncatingIfNeeded: i + 1)
    }
    
    let bufferPointer = UnsafeBufferPointer(start: typedPointer, count: count)
    for (index, value) in bufferPointer.enumerated() {
        print("value \(index): \(value)")
    }
    
}


import Foundation
import Metal
import PlaygroundSupport

let view = View(frame: NSRect(origin: .zero, size: CGSize(width: 500, height: 500)))
PlaygroundPage.current.liveView = view


Picture(image: #imageLiteral(resourceName: "goldenGate.jpg")) --> view

//: [Previous](@previous)   |    [Next](@next)

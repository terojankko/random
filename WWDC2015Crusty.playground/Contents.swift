import CoreGraphics
import PlaygroundSupport

struct Renderer {
    func moveTo(_ p: CGPoint) { print("moveTo(\(p.x), \(p.y))") }
    func lineTo(_ p: CGPoint) { print("lineTo(\(p.x), \(p.y))") }
    func arcAt(_ center: CGPoint, radius: CGFloat,
               startAngle: CGFloat, endAngle: CGFloat) {
        print("arcAt(\(center), radius: \(radius),"
            + " startAngle: \(startAngle), endAngle: \(endAngle))")
    }
    
}

protocol Drawable {
    func draw(_ renderer: Renderer)
}

struct Polygon : Drawable {
    func draw(_ renderer: Renderer) {
        
        renderer.moveTo(corners.last!)
        for p in corners {
            renderer.lineTo(p)
        }
    }
    var corners: [CGPoint] = []
}

struct Circle : Drawable {
    func draw(_ renderer: Renderer) {
    }
    var center: CGPoint
    var radius: CGFloat
}

struct Diagram : Drawable {
    func draw(_ renderer: Renderer) {
        for f in elements {
            f.draw(renderer)
        } }
    var elements: [Drawable] = []
}
var circle = Circle(center:
    CGPoint(x: 187.5, y: 333.5),
                    radius: 93.75)
var triangle = Polygon(corners: [
    CGPoint(x: 187.5, y: 427.25),
    CGPoint(x: 268.69, y: 286.625),
    CGPoint(x: 106.31, y: 286.625)])

var diagram = Diagram(elements: [circle, triangle])

diagram.draw(Renderer())


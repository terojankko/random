import Routing
import Vapor
import FluentSQLite


/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    
    router.post("send") { req -> Future<Response> in
        let username: String = try req.content.syncGet(at: "username")
        let content: String = try req.content.syncGet(at: "content")
        let msg = Message(id: nil, username: username, content: content, date: Date())
        
        return msg.save(on: req).map(to: Response.self) { _ in
            return req.redirect(to: "/")
        }
    }
    
    router.get { req -> Future<View> in
        return try Message.query(on: req).sort(\Message.date, .descending).all().flatMap(to: View.self) { messages in
            let context = ["messages": messages]
            return try req.view().render("home", context)
        }
    }
    
    router.get("list") { req -> Future<[Message]> in
        return try Message.query(on: req).sort(\Message.date, .descending).all()
    }
}

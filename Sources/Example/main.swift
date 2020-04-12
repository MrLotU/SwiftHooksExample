import NIO
import SwiftHooks
import Discord
import GitHub
import Foundation

// Use SwiftHooks for global events & builtin command handling
let swiftHooks = SwiftHooks()

let token = ProcessInfo.processInfo.environment["TOKEN"]!
try swiftHooks.hook(DiscordHook.self, .init(token: token))
//try swiftHooks.hook(GitHubHook.self, .createApp(host: "0.0.0.0", port: 8080))

// Or use a standalone Hook if that's all you need.

//let elg = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
//let gitHub = GitHubHook(.createApp(host: "0.0.0.0", port: 8080), elg)

// Create plugins to register listeners & commands.
// NOTE: Commands & GlobalListeners only work when using SwiftHooks.

class MyPlugin: Plugin {
    
    var commands: some Commands {
        Group {
            Command("echo")
                .arg(String.self, named: "content", .requiredConsume)
                .execute { (hooks, event, argOne) in
                    event.message.reply(argOne)
                }
            Command("ping")
                .execute { (hooks, event) in
                    event.message.reply("Pong!")
                    print("Ping succeed!")
            }
            
            Command("mone")
                .arg(Int.self, named: "a")
                .arg(Int.self, named: "b")
                .arg(Int.self, named: "c")
                .execute { (hooks, event, a, b, c) in
                    event.message.reply("\(a + b + c)")
            }
            
            Command("mtwo")
                .arg(Int.self, named: "a")
                .arg(Int.self, named: "b")
                .arg(Int.self, named: "c")
                .arg(Int.self, named: "d")
                .execute { (hooks, event, args) in
                    let a = try args.get(Int.self, named: "a", on: event)
                    let b = try args.get(Int.self, named: "b", on: event)
                    let c = try args.get(Int.self, named: "c", on: event)
                    let d = try args.get(Int.self, named: "d", on: event)
                    event.message.reply("\(a + b + c + d)")
            }
        }
    }
    
    var listeners: some EventListeners {
        Listeners {
            Listener(Discord.messageCreate) { (event, message) in
                print("Discord: \(message.content)")
            }
            
            Listener(GitHub.issueComment) { event, comment in
                print("GitHub: \(comment.content)")
            }
            
            Listener(Discord.guildCreate) { event, guild in
                print("""
                    Succesfully loaded \(guild.name).
                    It has \(guild.members.count) members and \(guild.channels.count) channels.
                """)
            }
            
            GlobalListener(GlobalEvent.messageCreate) { event, message in
                print("Global: \(message.content)")
            }
        }
    }
}

// Register your plugin to the system.
// Either SwiftHooks or your Hook

swiftHooks.register(MyPlugin())
//gitHub.register(MyPlugin())

print(swiftHooks.commands)

// Run the system!

try swiftHooks.run()
//try gitHub.boot()

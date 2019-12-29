import NIO
import SwiftHooks
import Discord
import GitHub
import Foundation

// Use SwiftHooks for global events & builtin command handling

let swiftHooks = SwiftHooks()
//let token = ProcessInfo.processInfo.environment["TOKEN"]!
//try swiftHooks.hook(DiscordHook.self, .init(token: token))
try swiftHooks.hook(GitHubHook.self, .createApp(host: "0.0.0.0", port: 8080))

// Or use a standalone Hook if that's all you need.

let elg = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
let gitHub = GitHubHook(.createApp(host: "0.0.0.0", port: 8080))

// Create plugins to register listeners & commands.
// NOTE: Commands & GlobalListeners only work when using SwiftHooks.

class MyPlugin: Plugin {
    
//    @Command("ping")
//    var closure = { (hooks, event, command) in
//        print("Ping succeed!")
//    }
    
    @Listener(GitHub.issueComment)
    var onIssueComment = { event in
        print("GitHub: \(event.content)")
    }
    
    @Listener(Discord.guildCreate)
    var guildListener = { guild in
        print("""
            Succesfully loaded \(guild.name).
            It has \(guild.members.count) members and \(guild.channels.count) channels.
        """)
    }
    
    @Listener(Discord.messageCreate)
    var messageListener = { message in
        print("Discord: \(message.content)")
        if let flags = message.flags {
            print(flags.contains(.isCrossposted))
            print(flags.contains(.sourceMessageDeleted))
        }
    }
    
    @Listener(Discord.messageUpdate)
    var updateListener = { message in
        print("Discord: \(message.content)")
        if let flags = message.flags {
            print(flags.contains(.isCrossposted))
            print(flags.contains(.sourceMessageDeleted))
        }
    }
    
    @GlobalListener(GlobalEvent.messageCreate)
    var globalMessageListener = { message in
        print("Global: \(message.content)")
    }
}

// Register your plugin to the system.
// Either SwiftHooks or your Hook

swiftHooks.register(MyPlugin())
//gitHub.register(MyPlugin())


// Run the system!

try swiftHooks.run()
//try gitHub.boot(on: elg)

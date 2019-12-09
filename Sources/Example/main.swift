import SwiftHooks
import Discord
import Foundation

let swiftHooks = SwiftHooks()
let token = ProcessInfo.processInfo.environment["TOKEN"]!
try swiftHooks.hook(DiscordHook.self, DiscordHookOptions(token: token))

class MyPlugin: Plugin {
    
//    @Command("ping")
//    var closure = { (hooks, event, command) in
//        print("Ping succeed!")
//    }
    
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
        print("Flags: \(message.flags)")
        if let flags = message.flags {
            print(flags.contains(.isCrossposted))
            print(flags.contains(.sourceMessageDeleted))
        }
    }
    
    @Listener(Discord.messageUpdate)
    var updateListener = { message in
        print("Discord: \(message.content)")
        print("Flags: \(message.flags)")
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

swiftHooks.register(MyPlugin())

try swiftHooks.run()

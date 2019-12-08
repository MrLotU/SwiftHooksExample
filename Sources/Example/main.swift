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
    
    @Listener(DiscordEvent.guildCreate)
    var guildListener = { guild in
        print("Other guild thing \(guild.name)")
    }
    
    @Listener(DiscordEvent.messageCreate)
    var messageListener = { message in
        print("Discord: \(message.content)")
    }
    
    @GlobalListener(GlobalEvent.messageCreate)
    var globalMessageListener = { message in
        print("Global: \(message.content)")
    }
}

swiftHooks.register(MyPlugin())

try swiftHooks.run()

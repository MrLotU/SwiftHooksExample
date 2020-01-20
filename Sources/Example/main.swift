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
    
    @Command("ping")
    var closure = { (hooks, event, command) in
        print("Ping succeed!")
    }
    
    @Listener(GitHub.issueComment)
    var onIssueComment = { event, comment in
        print("GitHub: \(comment.content)")
    }

    @Listener(Discord.guildCreate)
    var guildListener = { event, guild in
        print("""
            Succesfully loaded \(guild.name).
            It has \(guild.members.count) members and \(guild.channels.count) channels.
        """)
    }
    
    @Listener(Discord.messageCreate)
    var messageListener = { event, message in
        print("Discord: \(message.content)")
        if message.content == "!ping" {
            message.reply("PONG!")
        }
    }

    @GlobalListener(GlobalEvent.messageCreate)
    var globalMessageListener = { event, message in
        print("Global: \(message.content)")
    }
}

// Register your plugin to the system.
// Either SwiftHooks or your Hook

swiftHooks.register(MyPlugin())
swiftHooks.register(FunPlugin())
//gitHub.register(MyPlugin())


// Run the system!

try swiftHooks.run()
//try gitHub.boot()

import Cocoa
import QuartzCore

// 1. Read the duration from Alfred's environment variables first
let durationString = ProcessInfo.processInfo.environment["DURATION"] ?? "5.0"
let duration = TimeInterval(durationString) ?? 5.0
let particleCountString = ProcessInfo.processInfo.environment["PARTICLE_COUNT"] ?? "14"
let particleCount = Float(particleCountString) ?? 14.0
let theme = ProcessInfo.processInfo.environment["THEME"] ?? "default"

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

guard let screen = NSScreen.main else { exit(1) }
let frame = screen.frame

let window = NSWindow(contentRect: frame, styleMask: .borderless, backing: .buffered, defer: false)
window.level = .screenSaver
window.isOpaque = false
window.backgroundColor = .clear
window.ignoresMouseEvents = true
window.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
window.hasShadow = false

let contentView = NSView(frame: NSRect(origin: .zero, size: frame.size))
contentView.wantsLayer = true
// Natural (un-flipped) layer coordinates: y = 0 at the BOTTOM, increasing upward.
window.contentView = contentView

func particleImage(color: NSColor) -> CGImage? {
    let size = 10
    let image = NSImage(size: NSSize(width: size, height: size))
    image.lockFocus()
    color.setFill()
    NSBezierPath(roundedRect: NSRect(x: 0, y: 0, width: size, height: size), xRadius: 2, yRadius: 2).fill()
    image.unlockFocus()
    var rect = NSRect(x: 0, y: 0, width: size, height: size)
    return image.cgImage(forProposedRect: &rect, context: nil, hints: nil)
}

let colors: [NSColor] = {
    switch theme.lowercased() {
	case "standard":
		return [
			.systemRed, .systemBlue, .systemGreen, .systemYellow, .systemPurple, .systemOrange, .systemPink
		]
	case "two-bit":
        return [
            NSColor(red: 1.0, green: 0.4, blue: 0.0, alpha: 1.0), // #ff6600
            NSColor(red: 0.0, green: 0.6, blue: 1.0, alpha: 1.0), // #0099ff
            NSColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0), // #ff9900
            NSColor(red: 0.0, green: 0.4, blue: 0.8, alpha: 1.0), // #0066cc
            NSColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0), // #333333
            .white,
        ]
    case "neon":
        return [.systemGreen, .systemPink, .systemYellow, .cyan]
    case "pastel":
        return [
            NSColor(red: 1.0, green: 0.7, blue: 0.7, alpha: 1.0), // Light Red
            NSColor(red: 0.7, green: 1.0, blue: 0.7, alpha: 1.0), // Light Green
            NSColor(red: 0.7, green: 0.7, blue: 1.0, alpha: 1.0), // Light Blue
            NSColor(red: 1.0, green: 1.0, blue: 0.7, alpha: 1.0)  // Light Yellow
        ]
    case "monochrome":
        return [.white, .lightGray, .darkGray, .black]
    default:
        return [.systemRed, .systemBlue, .systemGreen, .systemYellow, .systemPurple, .systemOrange, .systemPink]
    }
}()

// Standard angle convention here (no flip): 0 = right, .pi/2 = up, .pi = left, -.pi/2 = down.
func makeCannon(position: CGPoint, longitude: CGFloat) -> CAEmitterLayer {
    let emitter = CAEmitterLayer()
    emitter.emitterPosition = position
    emitter.emitterShape = .point
    emitter.renderMode = .unordered

    emitter.emitterCells = colors.compactMap { color -> CAEmitterCell? in
        guard let img = particleImage(color: color) else { return nil }
        let cell = CAEmitterCell()
        cell.birthRate = particleCount
        cell.lifetime = 6.5
        cell.velocity = 900
        cell.velocityRange = 250
        cell.emissionLongitude = longitude
        cell.emissionRange = .pi / 7
        cell.spin = 4
        cell.spinRange = 8
        cell.scale = 0.7
        cell.scaleRange = 0.4
        cell.contents = img
        cell.alphaSpeed = -0.2
        cell.yAcceleration = -380 // gravity pulls back down (negative y is down in natural coords)
        return cell
    }
    return emitter
}

let leftCannon = makeCannon(position: CGPoint(x: 0, y: -10), longitude: .pi / 4) // up + right

let rightCannon = makeCannon(position: CGPoint(x: frame.width, y: -10), longitude: 3 * .pi / 4) // up + left

contentView.layer?.addSublayer(leftCannon)
contentView.layer?.addSublayer(rightCannon)
// Make the window visible
window.makeKeyAndOrderFront(nil)

// Schedule the app to fade out and close after the duration
DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
    NSAnimationContext.runAnimationGroup({ context in
        context.duration = 1.0 // Fade out over 1 second
        window.animator().alphaValue = 0.0
    }, completionHandler: {
        app.terminate(nil)
    })
}

// Start the app
app.run()
import SwiftUI

struct FireworksView: View {
    let isActive: Bool
    
    @State private var particles: [FireworkParticle] = []
    @State private var timer: Timer?
    
    var body: some View {
        Canvas { context, size in
            for particle in particles {
                var contextCopy = context
                contextCopy.addFilter(.colorMultiply(particle.color))
                contextCopy.opacity = particle.opacity
                
                contextCopy.fill(
                    Path(ellipseIn: CGRect(x: particle.x, y: particle.y, width: particle.size, height: particle.size)),
                    with: .color(particle.color)
                )
            }
        }
        .ignoresSafeArea()
        .onChange(of: isActive) { newValue in
            if newValue {
                startFireworks()
            } else {
                stopFireworks()
            }
        }
    }
    
    private func startFireworks() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            createExplosion()
        }
    }
    
    private func stopFireworks() {
        timer?.invalidate()
        timer = nil
        withAnimation(.easeOut(duration: 1.0)) {
            particles.removeAll()
        }
    }
    
    private func createExplosion() {
        let centerX = Double.random(in: 50...UIScreen.main.bounds.width - 50)
        let centerY = Double.random(in: 50...UIScreen.main.bounds.height / 2)
        let color = [Color.leetCodeOrange, Color.leetCodeYellow, Color.leetCodeGreen, Color.red, Color.blue, Color.purple].randomElement()!
        
        for _ in 0..<20 {
            let angle = Double.random(in: 0..<360) * .pi / 180
            let speed = Double.random(in: 5...15)
            
            let particle = FireworkParticle(
                x: centerX,
                y: centerY,
                vx: cos(angle) * speed,
                vy: sin(angle) * speed,
                color: color,
                opacity: 1.0,
                size: Double.random(in: 4...8)
            )
            particles.append(particle)
        }
        
        // Update particles
        Task {
            // Simple animation loop simulation
            for _ in 0..<50 {
                try? await Task.sleep(nanoseconds: 50_000_000) // 50ms
                updateParticles()
            }
        }
    }
    
    private func updateParticles() {
        for i in particles.indices {
            particles[i].x += particles[i].vx
            particles[i].y += particles[i].vy
            particles[i].vy += 0.5 // Gravity
            particles[i].opacity -= 0.02
            particles[i].size *= 0.95
        }
        particles.removeAll { $0.opacity <= 0 }
    }
}

struct FireworkParticle {
    var x: Double
    var y: Double
    var vx: Double
    var vy: Double
    var color: Color
    var opacity: Double
    var size: Double
}

import SwiftUI

struct GypsyDiceGameView: View {
    @State private var diceOne = Int.random(in: 1...6)
    @State private var diceTwo = Int.random(in: 1...6)
    @State private var diceThree = Int.random(in: 1...6)
    @State private var rolling = false
    @State private var currentPoints = 0
    @State private var totalPoints = 0
    @State private var lostPoints = 0

    var body: some View {
        VStack {
            Spacer()
            Text("Барбут")
                .font(.largeTitle)
            Spacer()
            Text("Текущи точки: \(currentPoints)")
                .font(.title)
            Text("Общо точки: \(totalPoints)")
                .font(.title)
            Spacer()
            HStack(spacing: 5.0) {
                DiceView(number: diceOne, rolling: $rolling)
                DiceView(number: diceTwo, rolling: $rolling)
                DiceView(number: diceThree, rolling: $rolling)
            }
            Spacer()
            Button(action: rollDice) {
                Text(rolling ? "Въртене..." : "Хвърли заровете")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .background(rolling ? Color.blue : Color.green)
                    .cornerRadius(10)
                    .disabled(rolling)
            }
            Button("Запази точките") {
                savePoints()
            }
            .font(.largeTitle)
            .disabled(rolling || currentPoints == 0)
            Spacer()
        }
        .background(Color.pink)
    }
    
    func rollDice() {
        rolling = true
        let times = Int.random(in: 10...15) // Random number of changes
        var currentCount = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
            self.diceOne = Int.random(in: 1...6)
            self.diceTwo = Int.random(in: 1...6)
            self.diceThree = Int.random(in: 1...6)
            
            currentCount += 1
            if currentCount == times {
                timer.invalidate()
                self.rolling = false
                calculatePoints()
            }
        }
    }
    
    func calculatePoints() {
        let previousPoints = currentPoints // Запазете текущите точки преди пресмятането
        let diceResults = [diceOne, diceTwo, diceThree].sorted()
        let uniqueResults = Set(diceResults)
        
        switch uniqueResults.count {
        case 1: // Всички зарове са еднакви
            if diceResults[0] == 6 {
                totalPoints = lostPoints // Връщаме загубените точки при 666
                currentPoints = 0
            } else {
                let points = diceResults[0] * 100 * diceResults.count
                currentPoints += points
            }
        case 2: // Два еднакви зара
            if diceResults.contains(1) {
                currentPoints += 100 * (diceResults.filter { $0 == 1 }.count)
            }
            if diceResults.contains(5) {
                currentPoints += 50 * (diceResults.filter { $0 == 5 }.count)
            }
        default: // Всички зарове са различни
            let diceString = diceResults.map { String($0) }.joined()
            switch diceString {
            case "123", "234", "345", "456", "135", "246":
                currentPoints += 200
            default:
                currentPoints += (diceResults.contains(1) ? 100 : 0) + (diceResults.contains(5) ? 50 : 0)
            }
        }

        // Ако точките не са се увеличили след пресмятането, занулете текущите точки
        if currentPoints == previousPoints {
            currentPoints = 0 // Зануляване на текущите точки, ако няма промяна
        }
    }

    func savePoints() {
        if currentPoints > 0 { // Добавете точките само ако има какво да се добави
            totalPoints += currentPoints
            lostPoints = totalPoints // Запазваме текущите точки за възможно връщане при 666
        }
        currentPoints = 0 // Зануляване на текущите точки след запазване
    }

}

struct DiceView: View {
    let number: Int
    @Binding var rolling: Bool
    
    var body: some View {
        Image(systemName: "die.face.\(number).fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .rotationEffect(.degrees(rolling ? 360 : 0))
            .animation(rolling ? Animation.linear(duration: 0.15).repeatForever(autoreverses: false) : .default, value: rolling)
            .padding()
    }
}

struct GypsyDiceGameView_Previews: PreviewProvider {
    static var previews: some View {
        GypsyDiceGameView()
    }
}

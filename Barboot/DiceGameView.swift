import SwiftUI

struct DiceGameView: View {
    @State private var diceOne = Int.random(in: 1...6)
    @State private var diceTwo = Int.random(in: 1...6)
    @State private var diceThree = Int.random(in: 1...6)
    @State private var rolling = false
    @State private var currentPoints = 0
    @State private var totalPoints = 0
    @State private var lastRollPoints = 0
    @State private var lostPoints = 0
    @State private var holdDiceOne = false
    @State private var holdDiceTwo = false
    @State private var holdDiceThree = false
    @State private var resetAfterZeroPoints = false

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
                DiceView(number: diceOne, rolling: $rolling, held: holdDiceOne)
                DiceView(number: diceTwo, rolling: $rolling, held: holdDiceTwo)
                DiceView(number: diceThree, rolling: $rolling, held: holdDiceThree)
            }
            Spacer()
            Button(action: {
                if resetAfterZeroPoints {
                    resetAfterZeroPoints = false
                }
                rollDice()
            }) {
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
        let times = Int.random(in: 10...15)
        var currentCount = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
            if !self.holdDiceOne {
                self.diceOne = Int.random(in: 1...6)
            }
            if !self.holdDiceTwo {
                self.diceTwo = Int.random(in: 1...6)
            }
            if !self.holdDiceThree {
                self.diceThree = Int.random(in: 1...6)
            }
            
            currentCount += 1
            if currentCount == times {
                timer.invalidate()
                self.rolling = false
                calculatePoints()
            }
        }
    }
    
    func calculatePoints() {
        let diceResults = [diceOne, diceTwo, diceThree].sorted()
        lastRollPoints = 0
        
        // Проверка за специалните комбинации при хвърляне и на трите зара
        if !holdDiceOne && !holdDiceTwo && !holdDiceThree {
            if diceResults == [1, 1, 1] {
                lastRollPoints = 1000
            } else if diceResults == [2, 2, 2] {
                lastRollPoints = 200
            } else if diceResults == [3, 3, 3] {
                lastRollPoints = 300
            } else if diceResults == [4, 4, 4] {
                lastRollPoints = 400
            } else if diceResults == [5, 5, 5] {
                lastRollPoints = 500
            } else if diceResults == [6, 6, 6] {
                currentPoints = 0
                resetAfterZeroPoints = true
                return
            } else if diceResults == [1, 2, 3] || diceResults == [2, 3, 4] || diceResults == [3, 4, 5] || diceResults == [4, 5, 6] {
                lastRollPoints = 200
            }
        }

        // Изчисляване на точките за отделните зарове, ако не е имало специална комбинация
        if lastRollPoints == 0 {
            var newHoldDiceOne = false
            var newHoldDiceTwo = false
            var newHoldDiceThree = false
            
            if !holdDiceOne {
                lastRollPoints += calculatePointsForDice(diceOne)
                newHoldDiceOne = isWinningDice(diceOne)
            }
            
            if !holdDiceTwo {
                lastRollPoints += calculatePointsForDice(diceTwo)
                newHoldDiceTwo = isWinningDice(diceTwo)
            }
            
            if !holdDiceThree {
                lastRollPoints += calculatePointsForDice(diceThree)
                newHoldDiceThree = isWinningDice(diceThree)
            }
            
            currentPoints += lastRollPoints
            
            holdDiceOne = newHoldDiceOne || holdDiceOne
            holdDiceTwo = newHoldDiceTwo || holdDiceTwo
            holdDiceThree = newHoldDiceThree || holdDiceThree
            
            if holdDiceOne && holdDiceTwo && holdDiceThree {
                holdDiceOne = false
                holdDiceTwo = false
                holdDiceThree = false
            }
            
            if lastRollPoints == 0 {
                currentPoints = 0
                holdDiceOne = false
                holdDiceTwo = false
                holdDiceThree = false
                resetAfterZeroPoints = true
            }
        } else {
            currentPoints += lastRollPoints
        }
    }
    
    func calculatePointsForDice(_ number: Int) -> Int {
        switch number {
        case 1:
            return 100
        case 5:
            return 50
        default:
            return 0
        }
    }
    
    func isWinningDice(_ number: Int) -> Bool {
        return number == 1 || number == 5
    }

    func savePoints() {
        if currentPoints > 0 {
            totalPoints += currentPoints
            lostPoints = totalPoints
        }
        currentPoints = 0
        holdDiceOne = false
        holdDiceTwo = false
        holdDiceThree = false
    }
}

struct DiceView: View {
    let number: Int
    @Binding var rolling: Bool
    let held: Bool
    
    var body: some View {
        Image(systemName: "die.face.\(number).fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .rotationEffect(.degrees(rolling && !held ? 360 : 0))
            .animation(rolling && !held ? Animation.linear(duration: 0.15).repeatForever(autoreverses: false) : .default, value: rolling)
            .opacity(held ? 0.5 : 1.0)
            .padding()
    }
}

struct DiceGameView_Previews: PreviewProvider {
    static var previews: some View {
        DiceGameView()
    }
}

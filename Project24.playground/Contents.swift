import UIKit


let name = "Taylor"

for letter in name {
    print("Letters in name: \(letter)")
}

//The reason for this is that letters in a string aren’t just a series of alphabetical characters – they can contain accents such as á, é, í, ó, or ú, they can contain combining marks that generate wholly new characters by building up symbols, or they can even be emoji.

let letter = name[name.index(name.startIndex, offsetBy: 3)] //forth character in Taylor

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

let letter2 = name[3]

let password = "12345"
password.hasPrefix("123")
password.hasSuffix("456")

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}



let weather = "it's going to rain"
print(weather.capitalized)


extension String {
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
}


let input = "Swift is like Objective-C without the C"
input.contains("Swift")


let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")

extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        return false
    }
}

input.containsAny(of: languages)

languages.contains(where: input.contains)



let string = "This is a test string"

//let attributes: [NSAttributedString.Key: Any] = [
//    .foregroundColor: UIColor.white,
//    .backgroundColor: UIColor.red,
//    .font: UIFont.boldSystemFont(ofSize: 36)]


//let attributedString = NSAttributedString(string: string, attributes: attributes)


let attributedString = NSMutableAttributedString(string: string)

attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 5, length: 2))

attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 8, length: 1))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 10, length: 4))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 15, length: 6))

// Challenge 1
extension String {
    func addPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix){
            return self
        }
        return prefix + self
    }
}

var test = "pet"
var prefix = "car"
let result = test.addPrefix(prefix)
print(result)


// Challenge 2

//let numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
extension String {
    func isNumeric(array: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        return false
    }
}

test = "He wears the number 23"
test.isNumeric()

// Challenge 3
extension String {
    func stringToArray() -> [String] {
            var result: [String] = []
            self.enumerateLines {
                //The line parameter represents the current line of the string, and the _ parameter represents the range of the line in the original string. Rage is the index of the letter in String.
                 line, _ in
                result.append(line)
            }
            return result
    }
}

test = "this nis na ntest"
var linesArray = test.stringToArray()
print(linesArray)

test = "this\nis\na\ntest"
linesArray = test.stringToArray()
print(linesArray)

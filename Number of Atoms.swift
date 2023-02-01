class Solution {
    func countOfAtoms(_ formula: String) -> String {
        
        var atoms = [String: Int]()
        var stack = [[String: Int]]()
        var lastElement: String = ""
        var lastNum = 1
        
        // Merge atoms with previous atoms array
        func mergeAtoms() {
            if lastElement == "." {
                var prevAtoms = stack.removeLast()
                for pair in atoms {
                    atoms[pair.key, default: 1] *= lastNum == 0 ? 1 : lastNum
                }
                atoms = atoms.merging(prevAtoms) { current, new in
                    current + new
                }
                lastElement = ""
            }
        }
        
        for char in formula {
            switch char {
                case "0"..."9":
                    lastNum = lastNum * 10 + Int(String(char))!
                case "A"..."Z":
                    mergeAtoms()
                    atoms[lastElement, default: 0] += lastNum == 0 ? 1 : lastNum
                    lastElement = String(char)
                    lastNum = 0
                case "a"..."z":
                    lastElement += String(char)
                case "(":
                    mergeAtoms()
                    atoms[lastElement, default: 0] += lastNum == 0 ? 1 : lastNum
                    lastElement = ""
                    lastNum = 0
                    stack.append(atoms)
                    atoms = [String: Int]()
                case ")":
                    mergeAtoms()
                    atoms[lastElement, default: 0] += lastNum == 0 ? 1 : lastNum
                    // We use lastElement as a marker here to signify we've reached the end of a group and want to merge it with the previous atoms dict
                    lastElement = "."
                    lastNum = 0
                default:
                    continue
            }
        }
                
        mergeAtoms()
        atoms[lastElement, default: 0] += lastNum == 0 ? 1 : lastNum
        
        return atoms
            // Remove "" from the dictionary
            .filter({ $0.0 != "" })
            .map({
                var string = $0.0
                if $0.1 > 1 {
                    string += String($0.1)
                }
                return string
            })
            .sorted()
            .joined()
    }
}
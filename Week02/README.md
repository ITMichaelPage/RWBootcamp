### BullsEye MVC Conversion Approach

Initially, I created `BullsEyeGame` as a class.

Even though it worked, I felt that each round of the game could also be represented as a separate struct. Therefore, I created a `Round` struct containing a target value and a method for calculating the round's points and text that could be displayed to the player.

Since BullsEyeGame did not require inheritance, I decided to convert it into a struct. This required prefixing its methods with the word `mutating`, thus allowing `score` and `rounds` to be modified.

The major differences I have noticed between classes and structs:

##### Classes

- reference type; when assigned to a variable/constant a pointer to the object is set
- properties are mutable
- allows for inheritance; to apply a superclass or be subclassed

##### Structs

- value type; when assigned to a variable/constant they are copied
- properties are immutable, unless the method that is changing the value is prefixed with `mutating`
- the recommended default approach in Swift, more resource efficient than classes
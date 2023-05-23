<p align="center">
    <img src="./assets/logo.png" alt="CLOWN Logo" />
</p>

# CLOWN

### Programming doesn't have to be a joke - unless it's CLOWN

CLOWN is a simple programming language that is designed to be easy to learn and use. It is a high-level language and a mixture of C, Python, and JavaScript. It is statically typed, and supports functions, loops, and many other features.

## Note:

- This is a project for the course "CMP4060 Compilers and Languages" at the University of Cairo, Faculty of Engineering, Computer Engineering Department.
- The compiler doesn't execute the code, it only checks for syntax errors and prints the intermediate assembly code (Quadruples).
- Not all the features have quadruples generation (Functions, Enums, Break, Continue, and Return).
- The compiler is not fully tested, so it may contain bugs.

# Run The code (Ubuntu)

- Remove `extern int yydebug;` in `src/clown.y` if any
- Remove `yydebug = 1;` in main function in `src/clown.y` if any

```
make all
make run INPUT_FILE=inputs/code.clown
```

# Run The code with debug (Ubuntu)

- Add `extern int yydebug;` to `src/clown.y`
- Add `yydebug = 1;` to main function in `src/clown.y`

```
make all
make run INPUT_FILE=inputs/code.clown
```

## Keywords and Operators

```
"int", "float", "string", "bool", "print", "if", "else", "elif", "while", "for", "do", "break", "continue", "return", "=", "==", "!=", ">", ">=", "<", "<=", "+", "-", "*", "/", "^", "%", "||", "&&", "!", "(", ")", "{", "}", ";", "function", "const", "switch", "case", "default", "enum", "NULL", ":", ","
```

## Syntax

### print

```
print("Hello World");
print(a);
print(a + b);
print(1 + 2 + 3);
```

### if elif else

```
if (a == 1) {
    print("a is 1");
} elif (a == 2) {
    print("a is 2");
} else {
    print("a is not 1 or 2");
}
```

### while

```
int a = 0;
while (a < 10) {
    print(a);
    a = a + 1;
}
```

### for loop

```
for (int i = 0; i < 10; i = i + 1) {
    print(i);
}

```

### do while

```
int a = 0;
do {
    print(a);
    a = a + 1;
} while (a < 10);
```

### break

```
int a = 0;
while (a < 10) {
    print(a);
    a = a + 1;
    if (a == 5) {
        break;
    }
}
```

### continue

```
int a = 0;
while (a < 10) {
    a = a + 1;
    if (a == 5) {
        continue;
    }
    print(a);
}
```

### return

```
function add(a, b) {
    return a + b;
}
```

### function call

```
z = add(1, 2);
add(1, 2);
```

### const

```
const int a = 1;
```

### switch case

```
int a = 1;
switch (a) {
    case 1:
        print("a is 1");
        break;
    case 2:
        print("a is 2");
        break;
    default:
        print("a is not 1 or 2");
        break;
}
```

### enum

```
enum Color {
    RED,
    GREEN,
    BLUE = 5
};
```

### enum usage

```
Color color = RED;
```

### NULL

```
a = NULL;
return NULL;
```

### comments

```
/* This is a comment */
```

### Mathematical operations

```
int a = 1 + 2;
int b = 1 - 2;
int c = 1 * 2;
float d = 1.0 / 2.0;
int e = 5 ^ 2;
int f = 5 % 2;
int z = (a + b) * ((c - f) ^ e);
```

### Logical operations

```
bool a = 5 > 2;
bool b = 5 >= 2;
bool c = 5 < 2;
bool d = 5 <= 2;
bool e = 5 == 2;
bool f = 5 != 2;
bool g = a && b;
bool h = a || b;
bool i = !a;
```

### Quadruples

|   Quadruple   |                                   Description                                   |
|:-------------:|:-------------------------------------------------------------------------------:|
| ADD s1, s2, R |           Pop the top 2 values of the stack (s1, s2) and push s1 + s2           |
| SUB s1, s2, r |           Pop the top 2 values of the stack (s1, s2) and push s1 - s2           |
| MUL s1, s2, r |           Pop the top 2 values of the stack (s1, s2) and push s1 * s2           |
| DIV s1, s2, r |           Pop the top 2 values of the stack (s1, s2) and push s1 / s2           |
| MOD s1, s2, r |           Pop the top 2 values of the stack (s1, s2) and push s1 % s2           |
| LT s1, s2, r  | Pop the top 2 values of the stack (s1, s2) and push true if s1 < s2 else false  |
| GT s1, s2, r  | Pop the top 2 values of the stack (s1, s2) and push true if s1 > s2 else false  |
| LE s1, s2, r  | Pop the top 2 values of the stack (s1, s2) and push true if s1 <= s2 else false |
| GE s1, s2, r  | Pop the top 2 values of the stack (s1, s2) and push true if s1 >= s2 else false |
| EQ s1, s2, r  | Pop the top 2 values of the stack (s1, s2) and push true if s1 == s2 else false |
| NE s1, s2, r  | Pop the top 2 values of the stack (s1, s2) and push true if s1 != s2 else false |
|   NOT s1, r   |                Pop the top 2 values of the stack (s) and push !s                |
| AND s1, s2, r |      Pop the top 2 values of the stack (s1, s2) and push true if s1 && s2       |
|OR s1, s2, r|Pop the top 2 values of the stack (s1, s2) and push true if s1 || s2|
|XOR s1, s2, r|Pop the top 2 values of the stack (s1, s2) and push s1 ^ s2|
|PUSH value|Push value to the stack|
|POP dst|Pop the top of the stack in into dst|
|L<num>:|Add label with number num|
|JMP L|Unconditional jump to L|
|JZ L|Jump to L if stack top == 0|

## Contributors

Thanks goes to these awesome people in the team.

<table>
    <tr>
        <td align="center">
            <a href="https://github.com/abdullahlashawafi"  target="_black">
                <img src="https://avatars.githubusercontent.com/u/53022307?v=4" width="150px;" alt="Abdullah Adel"/><br />
                <sub><b>Abdullah Adel</b></sub>
            </a>
            <br />
        </td>
        <td align="center">
            <a href="https://github.com/AhmedKhaled590"  target="_black">
                <img src="https://avatars.githubusercontent.com/u/62337087?v=4" width="150px;" alt="Ahmed Khaled"/><br />
                <sub><b>Ahmed Khaled</b></sub>
            </a>
            <br />
        </td>
        <td align="center">
            <a href="https://github.com/HazemAbdo"  target="_black">
                <img src="https://avatars.githubusercontent.com/u/59124058?v=4" width="150px;" alt="Hazem Abdo"/><br />
                <sub><b>Hazem Abdo</b></sub>
            </a>
            <br />
        </td>
        <td align="center">
            <a href="https://github.com/mhmdahmedfathi"  target="_black">
                <img src="https://avatars.githubusercontent.com/u/52926511?v=4" width="150px;" alt="Mohamed Fathy"/><br />
                <sub><b>Mohamed Fathy</b></sub>
            </a>
            <br />
        </td>
    </tr>
 </table>
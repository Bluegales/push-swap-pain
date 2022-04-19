import 'dart:async';
import 'dart:collection';
import 'dart:html';

final Element stacks = document.createElement('div');
final Stack stack1 = Stack(stacks, '0px');
final Stack stack2 = Stack(stacks, '110%');
final CommandList commands = CommandList();

enum eCommands {
  swap1,
  swap2,
  swapBoth,
  rotate1,
  rotate2,
  rotateBoth,
  reverseRotate1,
  reverseRotate2,
  reverseRotateBoth,
  push1,
  push2,
  none
}

class Stack {
  final Element _dom;
  final Queue<Element> _children = Queue();
  final String left;

  Stack(this._dom, this.left) {
    _dom.classes.add("stack");
  }
  // private

  // public
  void updatePosition() {
    int i = 0;
    while (i < _children.length) {
      _children.elementAt(i).style.top = (i * 4).toString() + "px";
      i++;
    }
  }

  int add(Element? e, bool update) {
    if (e == null) return 1;
    _children.addFirst(e);
    print(left);
    e.style.left = left;
    if (update) updatePosition();
    return 0;
  }

  Element? remove(bool update) {
    if (_children.isEmpty) return null;
    if (update) updatePosition();
    return _children.removeFirst();
  }

  int swap(bool update) {
    if (_children.length < 2) return 1;
    Element first = _children.removeFirst();
    Element second = _children.removeFirst();
    _children.addFirst(first);
    _children.addFirst(second);
    if (update) updatePosition();
    return 0;
  }

  int rotate(bool update) {
    if (_children.length < 2) return 1;
    _children.addLast(_children.removeFirst());
    if (update) updatePosition();
    return 0;
  }

  int reverseRotate(bool update) {
    if (_children.length < 2) return 1;
    _children.addFirst(_children.removeLast());
    if (update) updatePosition();
    return 0;
  }
}

class CommandList {
  final List<eCommands> _commands = [];
  int _position = 0;
  Timer? _playTimer;

  bool finished() {
    return ((_position >= _commands.length) ? true : false);
  }

  int addCommandString(String commands) {
    final commandRunes = commands.runes;
    final firstCommand = "a".runes.first;
    for (int c in commandRunes) {
      c -= firstCommand;
      if (c < 0 || c > 10) return 1;
      _commands.add(eCommands.values[c]);
    }
    return 0;
  }

  void play(Duration speed, [int count = 1]) {
    if (finished()) reset();
    _playTimer?.cancel();
    _playTimer = Timer.periodic(
        speed, (timer) => {if (commands.execute(count) != 0) timer.cancel()});
  }

  void pause() {
    _playTimer?.cancel();
  }

  int execute(int count) {
    if (_commands.isEmpty) return 1;
    if (count > 0 && _position >= _commands.length) return 2;
    if (count < 0 && _position <= 0) return 2;
    while (count > 0 && _position < _commands.length) {
      if (executeCommand(_commands[_position], false) != 0) {
        _commands[_position] = eCommands.none;
      }
      count--;
      _position++;
    }
    while (count < 0 && _position > 0) {
      count++;
      _position--;
      if (reverseCommand(_commands[_position], false) != 0) {
        _commands[_position] = eCommands.none;
      }
    }
    stack1.updatePosition();
    stack2.updatePosition();
    colorCommands(_position);
    return (0);
  }

  void reset() {
    execute(-_position);
  }
}

void initButtons() {
  querySelector("#cmdPlay")?.onClick.listen((event) {
    commands.play(Duration(milliseconds: 200));
  });
  querySelector("#cmdFast")?.onClick.listen((event) {
    commands.play(Duration(milliseconds: 100), 2);
  });
  querySelector("#cmdFFast")?.onClick.listen((event) {
    commands.play(Duration(milliseconds: 100), 6);
  });
  querySelector("#cmdPause")?.onClick.listen((event) {
    commands.pause();
  });
  querySelector("#cmd1")?.onClick.listen((event) {
    commands.execute(1);
  });
  querySelector("#cmd1m")?.onClick.listen((event) {
    commands.execute(-1);
  });
}

void main() {
  document.addEventListener("DOMContentLoaded", (Event e) {
    final wrapper = querySelector('.stackWrapper');
    wrapper?.append(stacks);
    printCommandList();
    addElements();
    addCommands();
    initButtons();
  });
}

void addElements() {
  final uri = Uri.parse(window.location.href);
  final numbers = uri.queryParameters["nbr"]?.split(",");
  if (numbers == null) return;

  final count = numbers.length;

  for (var n in numbers.reversed) {
    HtmlElement newDiv = document.createElement("div") as HtmlElement;
    newDiv.classes.add("element");
    newDiv.style.width = ((int.parse(n) + 1) / count * 100).toString() + "%";
    newDiv.style.background = "hsl(" +
        ((int.parse(n) / count * 200).floor()).toString() +
        ", 80%, 40%)";
    //newDiv.style.top = (int.parse(n) * 4).toString() + "px";
    //newDiv.style.background = "red";
    stacks.append(newDiv);
    stack1.add(newDiv, false);
    stack1.updatePosition();
  }
}

int addCommands() {
  final uri = Uri.parse(window.location.href);
  final commandString = uri.queryParameters["cmd"];
  if (commandString == null) return (1);
  commands.addCommandString(commandString);
  return (0);
}

int executeCommand(eCommands cmd, [bool update = true]) {
  switch (cmd) {
    case eCommands.swap1:
      return stack1.swap(update);
    case eCommands.swap2:
      return stack2.swap(update);
    case eCommands.swapBoth:
      stack1.swap(update);
      stack2.swap(update);
      return (0);
    case eCommands.rotate1:
      return stack1.rotate(update);
    case eCommands.rotate2:
      return stack2.rotate(update);
    case eCommands.rotateBoth:
      stack1.rotate(update);
      stack2.rotate(update);
      return (0);
    case eCommands.reverseRotate1:
      return stack1.reverseRotate(update);
    case eCommands.reverseRotate2:
      return stack2.reverseRotate(update);
    case eCommands.reverseRotateBoth:
      stack1.reverseRotate(update);
      stack2.reverseRotate(update);
      return (0);
    case eCommands.push1:
      return stack1.add(stack2.remove(update), update);
    case eCommands.push2:
      return stack2.add(stack1.remove(update), update);
    case eCommands.none:
      return (0);
  }
}

int reverseCommand(eCommands cmd, [bool update = true]) {
  switch (cmd) {
    case eCommands.swap1:
    case eCommands.swap2:
    case eCommands.swapBoth:
      return executeCommand(cmd, update);
    case eCommands.rotate1:
      return executeCommand(eCommands.reverseRotate1, update);
    case eCommands.rotate2:
      return executeCommand(eCommands.reverseRotate2, update);
    case eCommands.rotateBoth:
      return executeCommand(eCommands.reverseRotateBoth, update);
    case eCommands.reverseRotate1:
      return executeCommand(eCommands.rotate1, update);
    case eCommands.reverseRotate2:
      return executeCommand(eCommands.rotate2, update);
    case eCommands.reverseRotateBoth:
      return executeCommand(eCommands.rotateBoth, update);
    case eCommands.push1:
      return executeCommand(eCommands.push2, update);
    case eCommands.push2:
      return executeCommand(eCommands.push1, update);
    case eCommands.none:
      return 0;
  }
}

void printCommandList() {
  final printedList = querySelector("#commandList");
  if (printedList == null) return;
  final uri = Uri.parse(window.location.href);
  var commandString = uri.queryParameters["cmd"];
  if (commandString == null) return;
  commandString = commandString.replaceAll("a", "sa  ");
  commandString = commandString.replaceAll("b", "sb  ");
  commandString = commandString.replaceAll("c", "ss  ");
  commandString = commandString.replaceAll("d", "ra  ");
  commandString = commandString.replaceAll("e", "rb  ");
  commandString = commandString.replaceAll("f", "rr  ");
  commandString = commandString.replaceAll("g", "rra ");
  commandString = commandString.replaceAll("h", "rrb ");
  commandString = commandString.replaceAll("i", "rrr ");
  commandString = commandString.replaceAll("j", "pa  ");
  commandString = commandString.replaceAll("k", "pb  ");
  printedList.setInnerHtml('<font color="red"></font>' + commandString);
}

void colorCommands(int i) {
  final printedList = querySelector("#commandList");
  if (printedList == null) return;
  final original = printedList.innerHtml?.replaceFirst("</font>", "");
  print(original);
  if (original == null) return;

  final first = original.substring(0, i * 4 + 18);
  final second = original.substring(i * 4 + 18);
  print(first + "</font>");
  printedList.innerHtml = first + "</font>" + second;
}

class Node<T> {
  T? value;
  Node<T>? next;

  Node({
    this.value,
    this.next,
  });

  @override
  bool operator ==(Object other) {
    return other is Node && other.value == value && other.next == next;
  }

  @override
  int get hashCode => Object.hash(value, next);
}

class Stack<T> {
  Node<T>? node;

  Stack({this.node});

  ///Adds an entry to the stack
  void push(T? value) {
    Node<T> newNode = Node<T>(value: value);

    if (node == null) {
      node = newNode;
    } else {
      Node<T> lastNode = node!;
      while (lastNode.next != null) {
        lastNode = lastNode.next!;
      }
      lastNode.next = newNode;
    }
  }

  ///Pops an entry from stack.
  ///
  ///Returns null if stack is empty.
  T? pop() {
    if (node == null) return null;
    Node<T> lastNode = node!;
    Node<T> prevNode = lastNode;

    while (lastNode.next != null) {
      prevNode = lastNode;
      lastNode = lastNode.next!;
    }
    prevNode.next = null;
    return lastNode.value;
  }

  @override
  String toString() {
    if (node == null) {
      return '[]';
    }

    String res = '';
    Node nextNode = node!;
    while (nextNode.next != null) {
      res += '${nextNode.value} -> ';
      nextNode = nextNode.next!;
    }
    res += '${nextNode.value}';

    return '[$res]';
  }
}

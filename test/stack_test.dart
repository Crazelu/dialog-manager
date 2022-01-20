import 'package:flutter_dialog_manager/src/stack.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Given a Stack is constructed", () {
    test(
      "with a null node object, then Stack.node should be null",
      () {
        Stack stack = Stack();

        expect(null, stack.node);
      },
    );
    test(
      "with a non-null node object, then Stack.node should not be null",
      () {
        Node node = Node();
        Stack stack = Stack(node: node);

        expect(node, stack.node);
      },
    );
  });

  group("Stack.push tests |", () {
    test(
      '''
      Given a stack is constructed without a node,
      when push is called,
      Stack.node should be a node whose value is same
      as the one passed in the push method
      ''',
      () {
        Stack stack = Stack();

        expect(null, stack.node);
        stack.push(1);
        expect(1, stack.node!.value);
      },
    );

    test(
      '''
      Given a stack is constructed with a non-null node,
      when push is called,
      Stack.node.next should be a node whose value is same
      as the one passed in the push method
      ''',
      () {
        Stack stack = Stack(node: Node());
        Node newNode = Node(value: const Object());

        stack.push(const Object());
        expect(newNode, stack.node!.next!);
      },
    );
    test(
      '''
      Given a stack is constructed with a non-null node,
      when push is called,
      Stack.node.next.value should be same
      as the one passed in the push method
      ''',
      () {
        Stack stack = Stack(node: Node());

        stack.push(1);
        expect(1, stack.node!.next!.value);
      },
    );
  });

  group("Stack.pop tests |", () {
    test(
      '''
      Given a stack is constructed without a node,
      when pop is called,
      null should be returned
      ''',
      () {
        Stack stack = Stack();
        expect(null, stack.pop());
      },
    );
    test(
      '''
      Given a stack is constructed with a non-null node,
      when pop is called,
      the value of the node should be returned
      ''',
      () {
        const String testValue = "TEST";
        Stack stack = Stack(node: Node(value: testValue));
        expect(testValue, stack.pop());
      },
    );
    test(
      '''
      Given a stack is constructed with a non-null node
      which has a non-null next property,
      when pop is called,
      the value of Stack.node.next should be returned
      ''',
      () {
        Node initialNode = Node(value: 1, next: Node(value: 2));

        Stack stack = Stack(node: initialNode);
        expect(2, stack.pop());
      },
    );
  });
}

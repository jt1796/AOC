#include "intcode.hpp"

int main() {
    auto machine = IntCodeMachine(
        "input.txt",
        []() { return 2ll; },
        [](long long num) { cout << num << endl; }
    );

    machine.execute();
}

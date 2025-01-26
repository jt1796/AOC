#include "intcode.hpp"
#include "queue"
#include "mutex"
#include "condition_variable"
#include <algorithm>
#include <thread>

using namespace std;

int check(int a, int b, int c, int d, int e) {
    function<int()> inputs[5];
    function<void(int)> outputs[5];
    vector<IntCodeMachine> machines;

    queue<int> outputQueue[5];
    mutex outputQueueMutexes[5];
    condition_variable condvars[5];

    auto last_val = 0;

    for (int i = 0; i < 5; i++) {
        auto prev_i = (i + 4) % 5;
        inputs[i] = [&outputQueue, &outputQueueMutexes, &condvars, i, prev_i]() {
            unique_lock lock(outputQueueMutexes[prev_i]);
            auto& q = outputQueue[prev_i];
            if (q.empty()) {
                condvars[prev_i].wait(lock, [&q]() { return not q.empty(); });
            }
            auto val = q.front();
            q.pop();
            return val;
        };
        outputs[i] = [&outputQueue, &outputQueueMutexes, &condvars, &last_val, i](int num) {
            if (i == 4) {
                last_val = num;
            }
            lock_guard lock(outputQueueMutexes[i]);
            outputQueue[i].push(num);
            condvars[i].notify_all();
        };

        machines.emplace_back("input.txt", inputs[i], outputs[i]);
    }

    outputQueue[4].push(a);
    outputQueue[4].push(0);
    outputQueue[0].push(b);
    outputQueue[1].push(c);
    outputQueue[2].push(d);
    outputQueue[3].push(e);

    vector<jthread> threads;
    for (auto& machine : machines) {
        threads.push_back(jthread([&machine]() { machine.execute(); }));
    }

    for (auto& thread : threads) {
        thread.join();
    }

    return last_val;
}

int main() {
    vector<int> phases = {5, 6, 7, 8, 9};
    int maxFound = 0;
    do {
        auto checked = check(phases[0], phases[1], phases[2], phases[3], phases[4]);
        maxFound = max(maxFound, checked);
    } while (next_permutation(phases.begin(), phases.end()));

    cout << maxFound << endl;
    return 0;
}
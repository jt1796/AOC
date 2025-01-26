#include "iostream"
#include "sstream"
#include <fstream>
#include <functional>
#include <stdexcept>
#include <string>

using namespace std;

class IntCodeMachine {
public:
    int pointer = 0;
    int relativeBase = 0;
    unordered_map<long long, long long> program;
    function<long long()> input;
    function<void(long long)> output;

    IntCodeMachine(
        string fileinput,
        function<long long()> input,
        function<void(long long)> output
    ) {
        this->input = input;
        this->output = output;
        ifstream inputFile(fileinput);
        if (!inputFile) {
            throw runtime_error("unable to open file");
        }

        string line;
        while (getline(inputFile, line)) {
            if (line.ends_with("\r")) {
                line.pop_back();
            }
            string token;
            stringstream ss(line);
            int i = 0;
            while (getline(ss, token, ',')) {
                if (not token.empty()) {
                    program.insert({i++, stoll(token)});
                }
            }
        }
        inputFile.close();
    }

    long long getArgWrite(int mode) {
        if (mode == 0) {
            return program[pointer++];
        }
        if (mode == 1) {
            return pointer++;
        }
        if (mode == 2) {
            return relativeBase + program[pointer++];
        }
        throw runtime_error("invalid mode");
    }

    long long getArgRead(int mode) {
        return program[getArgWrite(mode)];
    }

    void execute() {
        while (true) {
            long long modesAndInst = program[pointer++];
            int inst = modesAndInst % 100;
            int modes = modesAndInst / 100;
            int mode0 = modes % 10;
            int mode1 = (modes / 10) % 10;
            int mode2 = (modes / 100) % 10;

            if (inst == 99) {
                return;
            }

            if (inst == 1) {
                program[getArgWrite(mode2)] = getArgRead(mode0) + getArgRead(mode1);
            }

            if (inst == 2) {
                program[getArgWrite(mode2)] = getArgRead(mode0) * getArgRead(mode1);
            }

            if (inst == 3) {
                auto retrievedInput = input();
                program[getArgWrite(mode0)] = retrievedInput;
            }

            if (inst == 4) {
                output(getArgRead(mode0));
            }

            if (inst == 5) {
                auto test = getArgRead(mode0);
                auto next = getArgRead(mode1);
                if (test != 0) {
                    pointer = next;
                }
            }

            if (inst == 6) {
                auto test = getArgRead(mode0);
                auto next = getArgRead(mode1);
                if (test == 0) {
                    pointer = next;
                }
            }

            if (inst == 7) {
                auto a = getArgRead(mode0);
                auto b = getArgRead(mode1);
                auto to = getArgWrite(mode2);
                program[to] = (a < b) ? 1 : 0;
            }

            if (inst == 8) {
                auto a = getArgRead(mode0);
                auto b = getArgRead(mode1);
                auto to = getArgWrite(mode2);
                program[to] = (a == b) ? 1 : 0;
            }

            if (inst == 9) {
                relativeBase += getArgRead(mode0);
            }
        }
    }
};


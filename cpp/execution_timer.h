// usage: EXEC_TIME(block_name)
#pragma once
#include <time.h>
#include <cstdio>

namespace NSild {
struct TExecTime {
    TExecTime(const char* aId)
    : Id(aId), ExecStart(clock()) 
    {}

    void Dump() {
        printf("Time taken for %s (seconds): %.10f\n", Id, static_cast<double>(clock() - ExecStart)/CLOCKS_PER_SEC);
        Dumped = true;
    }

    ~TExecTime() {
        if(!Dumped) {
            Dump();
        }
    }
    const char* Id;
    const clock_t ExecStart;
    bool Dumped = false;
};
}
#define EXEC_TIME(x) const auto& some_var = ::NSild::TExecTime(x)



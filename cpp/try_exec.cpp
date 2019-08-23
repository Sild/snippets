#pragma once
#include <functional>
namespace NSild {

template<typename TFunc, typename ...TFuncArgs>
auto TryExec(size_t aTryCount, TFunc aFunction, TFuncArgs&&... aFuncArgs) {
    size_t sTryNum = 1;
    while (++sTryNum <= aTryCount) {
        try {
            return std::invoke(aFunction, aFuncArgs...);
        }
        catch (...) {
        }
    }
    return std::invoke(aFunction, std::forward<TFuncArgs>(aFuncArgs)...);
}

// int main() {
//     auto foo = [](size_t i, size_t j) {
//         throw std::exception();
//     };
//     try {
//         TryExec(3, foo, 3, 4);
//     } catch (...) {}
// }

}
import <iostream>;
import <ratio>;

import si;

auto main() -> int {
    using namespace si;
    auto a = 4._kg;
    auto b = .2_kg;
    auto c = a * b;
    c *= 54;
    auto d = c * c;
    std::cout << d.value << std::endl;
    return 0;
}

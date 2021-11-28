import <iostream>;
import <ratio>;

import si;

auto main() -> int {
    using namespace si;

    double α = 0.0072973525693;
    auto ε₀ = (e * e) / (2 * α * h * c);
    std::cout << "ε₀ = " << ε₀ << std::endl;
    Measurement<UnitExp<Meter, std::ratio<2>>> S = 20e6;

    Measurement<Farad> C = (ε₀ * S) / 1000._m;
    std::cout << "C = " << C << std::endl;

    return 0;
}

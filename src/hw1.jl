# IN SOME FUNCTIONS, IT MAY BE NECESSARY TO ADD KEYWORD ARGUMENTS

abstract type BracketingMethod end

struct Bisection <: BracketingMethod end
struct RegulaFalsi <: BracketingMethod end

midpoint(::Bisection, f, a, b) = (a + b) / 2
midpoint(::RegulaFalsi, f, a, b) = (a * f(b) - b * f(a)) / (f(b) - f(a))

function findroot(
    method::BracketingMethod,
    f::Function,
    a::Real,
    b::Real;
    atol=1e-8,
    maxiter=1000
)
    c = a
    current_iter = 1
    while abs(f(c)) > atol && current_iter < maxiter
        # We do not need to consider case a = b as it will cause a DomainError later
        if a > b
            a, b = b, a
        end

        # If the root was supplied as one the endpoints, return it
        if abs(f(a)) < atol
            return a
        elseif abs(f(b)) < atol
            return b
        end

        sign(f(a)) == sign(f(b)) && throw(DomainError((a, b), "endpoints of the interval must have oposite signs"))

        c = midpoint(method, f, a, b)

        a, b = sign(f(a)) == sign(f(c)) ? (c, b) : (a, c)
        current_iter += 1
    end

    return c
end
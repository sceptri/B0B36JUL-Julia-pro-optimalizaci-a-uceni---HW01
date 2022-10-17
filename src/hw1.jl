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
    maxiter=1000,
    curiter=1
)
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

    if abs(f(c)) < atol || curiter > maxiter
        return c
    else
        aₙ, bₙ = sign(f(a)) == sign(f(c)) ? (c, b) : (a, c)
        return findroot(method, f, aₙ, bₙ; atol, maxiter, curiter=curiter + 1)
    end
end
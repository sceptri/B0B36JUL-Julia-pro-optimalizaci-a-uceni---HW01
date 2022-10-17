using Test

include("./../src/hw1.jl")

f = x -> x^3 - x - 2

@test findroot(Bisection(), f, 1, 2) ≈ 1.5213797063123649
@test findroot(RegulaFalsi(), f, 1, 2) ≈ 1.5213797063123649

@test findroot(RegulaFalsi(), f, 1.5213797067990527, 2) ≈ 1.5213797067990527
@test findroot(RegulaFalsi(), f, 1, 1.5213797067990527) ≈ 1.5213797067990527

@test_throws DomainError findroot(RegulaFalsi(), f, 1, 1)
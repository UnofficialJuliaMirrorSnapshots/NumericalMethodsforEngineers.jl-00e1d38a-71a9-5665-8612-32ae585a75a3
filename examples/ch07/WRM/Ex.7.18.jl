# Continuation of ex 7.13, Least Squares WRM

using NumericalMethodsforEngineers
using Test

@sym begin
  ClearAll(xi, yi, N1, Y, Ydotdot, C11, ytilde1, ytilde2)
  xi = [0, 1//2, 1]
  yi = [0, a, 1]
  Y(x_) := LagrangePolynomial(xi, yi)
  #
  # Can be formulated as ytile(x) = F(x) + C1(a) * Ψ(x)
  #
  # F(x_) := 2*x^2 - x
  # C(a_) := -4a
  Ψ(x_) := x^2 - x
  #
  #Y(x_) := F(x) + C(a)*Ψ(x)
  #
  Ydotdot(x_) = D(Y(x), x, 2)
  R(x_) := Simplify(Expand(Ydotdot(x) - 3*x - 4*Y(x)))
  R(x_) = Simplify(Expand(R(x) ./ (a => -C1/4)))
  C11 = Solve(Integrate(R(x)*Ψ(x), [x, 0, 1]), C1)[1]
  SetJ(r, ToString(Simplify(R(x))))
  SetJ(C1, ToString(C11[1][2]))
  ytilde1 = Simplify(Y(x) ./ (a => -C1/4))
  ytilde2 = Simplify(ytilde1 ./ C11)
  SetJ(y, ToString(Simplify(Expand(ytilde2))));
end

println("\n\nExample 7.18: y''=3x + 4y, y(0)=0, y(1)=1")
println("using 1-point Galerkin Weighted Residual Method")
@sym Println("\nY(x) = $(Y(x))\n")
@sym Println("Y(x) = $(Simplify(Expand(Y(x) ./ (a => -C1/4))))\n")
@sym Println("R(x) = $(R(x))\n")
@sym Println("C1 = $(Solve(Integrate(R(x)*Ψ(x), [x, 0, 1]), C1)[1][1][2])\n")
@sym Println("ytilde_1pt_galerkin(x) = $(ytilde2)\n")
println("( Example 7.18 gives: ytilde = 1/4*x*(5x - 1) )\n")
@eval ytilde_1pt_galerkin(x) = $(Meta.parse(y))
@eval rf_1pt_galerkin(x, C1) = $(Meta.parse(r))

C1 = Meta.parse(C1)
rf_1pt_galerkin_1(x) = rf_1pt_galerkin(x, C1)
println()

@test r == "4 + 2C1 + x + 4C1*x - 8x^2 - 4C1*x^2"
@test y == "(1/4)*x*(-1 + 5x)"
#@test (quadgk(rf_1pt_galerkin_1, 0, 1))[1] < 5*eps()


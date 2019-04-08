using NumericalMethodsforEngineers

ProjDir = dirname(@__FILE__)
cd(ProjDir) do

  f1(x::Float64, y::Vector{Float64}) = [y[2], 2.0*y[1]-3.0*y[2]+3.0*x^2]
  steps = 4
  h = 0.05

  x = 0.0
  y = [1.0, 0.0]

  r = Array{Float64,2}[]
  push!(r, euler(f1, x, y, steps, h))
  push!(r, modified_euler(f1, x, y, steps, h))
  push!(r, mid_point_euler(f1, x, y, steps, h))
  push!(r, runga_kutta_4(f1, x, y, steps, h))

  @test r[1][steps+1,:][:] == [0.2, 1.0272471874999998, 0.3254353125]
  @test r[2][steps+1,:][:] == [0.2, 1.0338953695013426, 0.3110140747716065]
  @test r[3][steps+1,:][:] == [0.2, 1.033871576010437, 0.3107074949932251]
  @test r[4][steps+1,:][:] == [0.2, 1.033615605146455, 0.3112553545583527]

end